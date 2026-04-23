import Child from "../../../Db/models/child_model.js";
import Parent from "../../../Db/models/parent_model.js";
import History from "../../../Db/models/history_mode.js";
import RandomString from "randomstring";
import mongoose from "mongoose";

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
      select: " -_id name dateOfBirth",
    },
  });
  if (!parent) {
    return next(new Error("Parent profile not found", { cause: 404 }));
  }

  const children = parent.children.map((child) => ({
    _id: child._id,
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

  const session = await mongoose.startSession();
  try {
    session.startTransaction();
    //parent profile
    const parent = await Parent.findOne({ userId: req.user._id }).session(
      session,
    );
    if (!parent) {
      return next(new Error("Parent profile not found", { cause: 404 }));
    }

    //ensure this child linked to this parent
    const child = await Child.findOne({
      _id: childId,
      parents: parent._id,
    }).session(session);

    if (!child) {
      return next(new Error("Child not found or not linked", { cause: 404 }));
    }

    // Make sure the points are not negative
    if (points <= 0) {
      return next(new Error("Points Must be Greater than 0", { cause: 400 }));
    }

    //make sure from number of points
    if (type === "remove" && child.totalPoints < points) {
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
      return next(new Error("Daily manual points limit exceeded"));
    }

    //update points in child
    const updatedValue = type === "add" ? points : -points;

    await Child.updateOne(
      { _id: childId },
      {
        $inc: { totalPoints: updatedValue },
      },
      { new: true, session },
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

    return res
      .status(201)
      .json({ success: true, message: `points ${type}ed seccessfully` });
  } catch (error) {
    await session.abortTransaction();
    next(error);
  } finally {
    await session.endSession();
  }
};

//v1 without tasks aggregation
//todo task aggregate to show task count completed tasks.....
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
    select: "name dateOfBirth",
  });

  const lastActivity = await History.findOne({ childId: child._id }).sort({
    createdAt: -1,
  });

  //todo task aggregate

  const resObject = {
    child: {
      _id: child._id,
      name: child.userId.name,
      age: child.userId.age,
      totalPoints: child.totalPoints,
      spentPoints: child.spentPoints,
    },
    latestActivity: {
      type: lastActivity.type,
      source: lastActivity.source,
      points: Math.abs(lastActivity.points),
      createdAt: lastActivity.createdAt,
    },
    //todo task response
  };

  return res.status(200).json({ success: true, results: resObject });
};

export const childHistory = async (req, res, next) => {
  const { childId } = req.params;
  const { fields, page, ...rest } = req.query;

  const history = await History.find({ childId: childId })
    .customFilter(rest)
    .customSelect(fields)
    .paginate(page);

  return res.status(200).json({ success: true, history });
};
