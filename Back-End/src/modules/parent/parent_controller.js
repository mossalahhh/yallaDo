import Child from "../../../Db/models/child_model.js";
import Parent from "../../../Db/models/parent_model.js";
import History from "../../../Db/models/history_mode.js";
import RandomString from "randomstring";
import Notification from "../../../Db/models/notification_model.js";
import Task from "../../../Db/models/task_model.js";
import mongoose from "mongoose";
import User from "../../../Db/models/user_model.js";

export const inviteCode = async (req, res, next) => {
  //generate code
  const code = RandomString.generate({
    length: 8,
    charset: "alphanumeric",
  });

  //generate expire date
  const expireDate = Date.now() + 2 * 24 * 60 * 60 * 1000;

  //find parent And Update
  const parent = await Parent.findOneAndUpdate(
    { userId: req.user._id },
    {
      $set: {
        "inviteCode.code": code,
        "inviteCode.expiresAt": expireDate,
        "inviteCode.maxUses": 5,
        "inviteCode.usedCount": 0,
      },
    },
    { new: true },
  );

  if (!parent) {
    return next(new Error("Parent profile not found", { cause: 404 }));
  }

  const codeRes = {
    code: parent.inviteCode.code,
    expiresAt: parent.inviteCode.expiresAt,
    maxUses: parent.inviteCode.maxUses,
    usedCount: parent.inviteCode.usedCount,
  };

  return res.status(201).json({
    success: true,
    message: "Code Generated successfully",
    results: codeRes,
  });
};

export const myChildren = async (req, res, next) => {
  const parent = await Parent.findOne({ userId: req.user._id }).populate({
    path: "children",
    select: "age totalPoints",
    populate: {
      path: "userId",
      select: " -_id name dateOfBirth profilePic",
    },
  });
  if (!parent) {
    return next(new Error("Parent profile not found", { cause: 404 }));
  }

  const children = parent.children.map((child) => ({
    childId: child._id,
    avater: child.userId.profilePic,
    name: child.userId.name,
    age: child.userId.age,
    totalPoints: child.totalPoints,
  }));

  return res.status(200).json({ success: true, results: children });
};

export const unLinkChild = async (req, res, next) => {
  const { childId } = req.params;
  const session = await mongoose.startSession();
  try {
    session.startTransaction();

    const child = await Child.findById(childId).session(session);

    if (!child) {
      return next(new Error("child profile not found", { cause: 404 }));
    }

    const parent = await Parent.findOneAndUpdate(
      { userId: req.user._id, children: childId },
      { $pull: { children: child._id } },
      { new: true, session },
    );

    if (!parent) {
      return next(new Error("Child not linked to this parent", { cause: 400 }));
    }

    await Child.findByIdAndUpdate(
      childId,
      { $pull: { parents: parent._id } },
      { new: true, session },
    );

    const user = await User.findOne({ _id: req.user._id });

    const parentName = user.name;
    //create Notification
    await Notification.create(
      [
        {
          receiver: child._id,
          receiverModel: "Child",

          sender: parent._id,
          senderModel: "Parent",

          title: "Family Unlinked",
          message: `Your connection with ${parentName}'s family account has been removed.`,

          type: "parent_unlink",

          relatedId: child._id,
          relatedModel: "Child",
        },
      ],
      { session },
    );

    await session.commitTransaction();

    return res.status(200).json({
      success: true,
      message: "Child Unlinked successfully ",
    });
  } catch (error) {
    await session.abortTransaction();
    next(error);
  } finally {
    await session.endSession();
  }
};

export const bounsPoints = async (req, res, next) => {
  const { points, type, reason } = req.body;
  const { childId } = req.params;

  console.log(req.params);
  console.log(req.body);
  console.log(req.user);
  const session = await mongoose.startSession();
  try {
    session.startTransaction();
    //parent profile
    const parent = await Parent.findOne({ userId: req.user._id }).session(
      session,
    );
    if (!parent) {
      await session.abortTransaction();
      return next(new Error("Parent profile not found", { cause: 404 }));
    }

    //ensure this child linked to this parent
    const child = await Child.findOne({
      _id: childId,
      parents: parent._id,
    }).session(session);

    if (!child) {
      await session.abortTransaction();
      return next(new Error("Child not found or not linked", { cause: 404 }));
    }

    // Make sure the points are not negative
    if (points <= 0) {
      await session.abortTransaction();
      return next(new Error("Points Must be Greater than 0", { cause: 400 }));
    }

    //make sure from number of points
    if (type === "remove" && child.totalPoints < points) {
      await session.abortTransaction();
      return next(new Error("Insufficient points", { cause: 400 }));
    }
    //make sure from daily limits
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const totalDay = await History.aggregate([
      {
        $match: {
          childId: child._id,
          parentId: parent._id,
          source: "manual",
          createdAt: { $gte: today }, //greater than or equal current time
        },
      },
      {
        $group: {
          _id: null,
          total: { $sum: { $abs: "$points" } }, //$ to refer on points in schema
        },
      },
    ]).session(session);

    const usedPoints = totalDay[0]?.total || 0;

    if (usedPoints + points > Number(process.env.DAILY_LIMIT)) {
      await session.abortTransaction();
      return next(new Error("Daily manual points limit exceeded"));
    }

    //update points in child
    const updatedValue = type === "add" ? points : -points;

    await Child.updateOne(
      { _id: childId },
      {
        $inc: { totalPoints: updatedValue },
      },
      { session },
    );

    //create history
    await History.create(
      [
        {
          childId: child._id,
          parentId: parent._id,
          points: updatedValue,
          source: "manual",
          type,
          reason,
        },
      ],
      { session },
    );
    //return res
    await session.commitTransaction();
    console.log("Before response");
    return res
      .status(201)
      .json({ success: true, message: `points ${type}ed seccessfully` });
  } catch (error) {
    console.error(error);
    await session.abortTransaction();
    next(error);
  } finally {
    await session.endSession();
  }
};

export const detailsChild = async (req, res, next) => {
  const { childId } = req.params;

  const parent = await Parent.findOne({ userId: req.user._id });

  if (!parent) {
    return next(new Error("Parent profile not found", { cause: 404 }));
  }

  const child = await Child.findOne({
    _id: childId,
    parents: parent._id,
  }).populate({
    path: "userId",
    select: "name dateOfBirth profilePic",
  });

  const lastActivity = await History.findOne({ childId: child._id }).sort({
    createdAt: -1,
  });

  const taskStats = await Task.aggregate([
    {
      $match: {
        $or: [{ assignedTo: child._id }, { claimedBy: child._id }],
        isDeleted: { $ne: true },
      },
    },
    {
      $group: {
        _id: null,
        total: { $sum: 1 },
        approved: { $sum: { $cond: [{ $eq: ["$status", "approved"] }, 1, 0] } },
        rejected: { $sum: { $cond: [{ $eq: ["$status", "rejected"] }, 1, 0] } },
        pending: {
          $sum: {
            $cond: [
              { $in: ["$status", ["pending", "claimed", "submitted"]] },
              1,
              0,
            ],
          },
        },
      },
    },
    {
      $project: {
        _id: 0,
        total: 1,
        approved: 1,
        rejected: 1,
        pending: 1,
      },
    },
  ]);

  const stats = taskStats[0] || {
    total: 0,
    approved: 0,
    rejected: 0,
    pending: 0,
  };

  const resObject = {
    child: {
      childId: child._id,
      avatar: child.userId.profilePic,
      name: child.userId.name,
      age: child.userId.age,
      totalPoints: child.totalPoints,
      spentPoints: child.spentPoints,
    },
    // A freshly linked child has no history yet, so lastActivity is null —
    // guard against it instead of dereferencing null (which 500'd the request).
    latestActivity: lastActivity
      ? {
          type: lastActivity.type,
          source: lastActivity.source,
          points: Math.abs(lastActivity.points),
          createdAt: lastActivity.createdAt,
        }
      : null,
    taskStats: stats,
  };

  return res.status(200).json({ success: true, results: resObject });
};

export const childHistory = async (req, res, next) => {
  const { childId } = req.params;
  const { fields, page, ...rest } = req.query;

  const history = await History.find({ childId: childId })
    .customFilter(rest)
    .customSelect(fields)
    .paginate(page)
    .sort({ createdAt: -1 });

  return res.status(200).json({ success: true, history: { page, history } });
};

export const allHistory = async (req, res, next) => {
  const { fields, page, ...rest } = req.query;
  const history = await History.find()
    .customFilter(rest)
    .customSelect(fields)
    .paginate(page)
    .sort({ createdAt: -1 });
  return res.status(200).json({ success: true, history: { page, history } });
};

export const dashborad = async (req, res, next) => {
  //get parent
  const parent = await Parent.findOne({ userId: req.user._id });
  if (!parent) {
    return next(new Error("Parent profile not found", { cause: 404 }));
  }

  //children count
  const childrenCount = parent.children.length;

  //today manual usage && totalGivenPoints
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const [todayUsageAgg, totalGivenAgg, todayPoints] = await Promise.all([
    //today manual usage
    History.aggregate([
      {
        $match: {
          parentId: parent._id,
          source: "manual",
          createdAt: { $gte: today },
        },
      },
      {
        $group: {
          _id: null,
          total: { $sum: { $abs: "$points" } },
        },
      },
    ]),

    //totalGivenPoints
    History.aggregate([
      {
        $match: {
          parentId: parent._id,
          type: "add",
        },
      },
      {
        $group: {
          _id: null,
          total: { $sum: { $abs: "$points" } },
        },
      },
    ]),

    //totalTodayPoints
    History.aggregate([
      {
        $match: {
          parentId: parent._id,
          type: "add",
          createdAt: { $gte: today },
        },
      },
      {
        $group: {
          _id: null,
          total: { $sum: { $abs: "$points" } },
        },
      },
    ]),
  ]);

  //results of total
  const todayManualUsage = todayUsageAgg[0]?.total || 0;
  const totalGivenPoints = totalGivenAgg[0]?.total || 0;
  const totalTodayPoints = todayPoints[0]?.total || 0;

  //returnRes
  return res.status(200).json({
    success: true,
    dashborad: {
      childrenCount,
      todayManualUsage,
      totalGivenPoints,
      totalTodayPoints,
    },
  });
};

export const analytics = async (req, res, next) => {
  const parent = await Parent.findOne({ userId: req.user._id }).populate({
    path: "children",
    select: "userId totalPoints",
    populate: {
      path: "userId",
      select: "name",
    },
  });

  if (!parent) {
    return next(new Error("Parent profile not found", { cause: 404 }));
  }

  const children = parent.children.map((child) => ({
    name: child.userId.name,
    points: child.totalPoints,
  }));

  children.sort((a, b) => {
    return b.points - a.points;
  });
  return res.status(200).json({ success: true, analytics: children });
};

export const pointsOverTime = async (req, res, next) => {
  //get data
  const { range } = req.query;

  //getParent
  const parent = await Parent.findOne({ userId: req.user._id });

  //check parent
  if (!parent) {
    return next(new Error("Parent profile not found", { cause: 404 }));
  }

  //date format based on range
  let dateFormat;
  if (range === "daily") {
    dateFormat = "%Y-%m-%d";
  } else if (range === "weekly") {
    dateFormat = "%Y-%U";
  } else if (range === "monthly") {
    dateFormat = "%Y-%m";
  }
  //aggregate
  const PointsAnalytics = await History.aggregate([
    {
      $match: {
        parentId: parent._id,
        type: "add",
      },
    },
    {
      $group: {
        _id: {
          $dateToString: {
            format: dateFormat,
            date: "$createdAt",
            timezone: "UTC",
          },
        },
        totalPoints: { $sum: "$points" },
      },
    },
    {
      $sort: { _id: 1 },
    },
    {
      $project: {
        _id: 0,
        date: "$_id",
        points: "$totalPoints",
      },
    },
  ]);
  //return res
  return res.status(200).json({ success: true, results: PointsAnalytics });
};

// export const topThree = async (req, res, next) => {
//   //getparent
//   const parent = await Parent.findOne({ userId: req.user._id }).populate({
//     path: "children",
//     select: "_id userId totalPoints",
//     populate: {
//       path: "userId",
//       select: "name profilePic",
//     },
//   });
//   //check parent
//   if (!parent) {
//     return next(new Error("Parent profile not found", { cause: 404 }));
//   }

//   //map to enhance response
//   const children = parent.children.map((child) => ({
//     childId: child._id,
//     avatar: child.userId.profilePic,
//     name: child.userId.name,
//     points: child.totalPoints,
//   }));

//   children.sort((a, b) => {
//     return b.points - a.points;
//   });

//   const top3 = children.slice(0, 3);

//   return res.status(200).json({ success: true, top3 });
// };

export const progressTasks = async (req, res, next) => {
  const parentId = await Parent.findOne({ userId: req.user._id });

  if (!parentId) {
    return next(new Error("Parent profile not found", { cause: 404 }));
  }

  const stats = await Child.aggregate([
    {
      $match: {
        parents: new mongoose.Types.ObjectId(parentId._id),
      },
    },

    {
      $lookup: {
        from: "users",
        localField: "userId",
        foreignField: "_id",
        as: "userInfo",
      },
    },

    { $unwind: { path: "$userInfo", preserveNullAndEmptyArrays: true } },

    {
      $lookup: {
        from: "tasks",
        let: { childId: "$_id" },
        pipeline: [
          {
            $match: {
              $expr: {
                $and: [
                  { $eq: ["$isDeleted", false] },
                  {
                    $or: [
                      { $eq: ["$assignedTo", "$$childId"] },
                      { $eq: ["$claimedBy", "$$childId"] },
                    ],
                  },
                ],
              },
            },
          },
        ],
        as: "childTasks",
      },
    },

    {
      $project: {
        _id: 1,
        childName: "$userInfo.name",
        totalTasks: { $size: "$childTasks" },
        approvedTasks: {
          $size: {
            $filter: {
              input: "$childTasks",
              as: "task",
              cond: { $eq: ["$$task.status", "approved"] },
            },
          },
        },
      },
    },

    {
      $project: {
        _id: 1,
        childName: 1,
        // totalTasks: 1,
        // approvedTasks: 1,
        approvedPercentage: {
          $cond: {
            if: { $gt: ["$totalTasks", 0] },
            then: {
              $round: [
                {
                  $multiply: [
                    { $divide: ["$approvedTasks", "$totalTasks"] },
                    100,
                  ],
                },
                2,
              ],
            },
            else: 0,
          },
        },
      },
    },

    { $sort: { approvedPercentage: -1 } },
  ]);

  res.status(200).json({
    success: true,
    data: stats,
  });
};

export const categoryCompletionRate = async (req, res, next) => {
  const parent = await Parent.findOne({
    userId: req.user._id,
  });

  if (!parent) {
    return next(
      new Error("Parent profile not found", {
        cause: 404,
      }),
    );
  }

  const stats = await Task.aggregate([
    {
      $match: {
        createdBy: parent._id,
        isDeleted: { $ne: true },
      },
    },

    {
      $group: {
        _id: "$category",

        totalTasks: {
          $sum: 1,
        },

        approvedTasks: {
          $sum: {
            $cond: [{ $eq: ["$status", "approved"] }, 1, 0],
          },
        },
      },
    },

    {
      $project: {
        _id: 0,

        category: "$_id",

        // totalTasks: 1,

        // approvedTasks: 1,

        completionRate: {
          $round: [
            {
              $multiply: [
                {
                  $divide: ["$approvedTasks", "$totalTasks"],
                },
                100,
              ],
            },
            2,
          ],
        },
      },
    },

    {
      $sort: {
        completionRate: -1,
      },
    },
  ]);

  return res.status(200).json({
    success: true,
    stats,
  });
};
