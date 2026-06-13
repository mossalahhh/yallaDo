import Child from "../../../Db/models/child_model.js";
import Parent from "../../../Db/models/parent_model.js";
import mongoose from "mongoose";
import Task from "../../../Db/models/task_model.js";
import History from "../../../Db/models/history_mode.js";

export const linkAccounts = async (req, res, next) => {
  //get data
  const { code } = req.body;
  //transaction session
  const session = await mongoose.startSession();
  try {
    session.startTransaction();

    //find parent
    const parent = await Parent.findOne({ "inviteCode.code": code }).session(
      session,
    );
    //validation on parent if not found
    if (!parent || !parent.inviteCode.code) {
      return next(new Error("Invalid request", { cause: 400 }));
    }
    //check expires date
    if (parent.inviteCode.expiresAt < Date.now()) {
      return next(new Error("Code expired", { cause: 400 }));
    }
    //check who use the code
    if (parent.userId.toString() === req.user._id.toString()) {
      return next(
        new Error("You can't use your own invite code", { cause: 403 }),
      );
    }
    //check max uses
    if (parent.inviteCode.usedCount >= parent.inviteCode.maxUses) {
      return next(new Error("Invite code usage limit reached", { cause: 400 }));
    }
    //child profile
    const child = await Child.findOne({ userId: req.user._id }).session(
      session,
    );
    if (!child) {
      return next(new Error("Child profile not found", { cause: 404 }));
    }
    //updates
    const result = await Parent.updateOne(
      {
        _id: parent._id,
        children: { $ne: child._id }, //if child not exist do this update
      },
      { $push: { children: child._id }, $inc: { "inviteCode.usedCount": 1 } },
      { session },
    );

    if (result.modifiedCount === 0) {
      return next(new Error("Child already linked", { cause: 409 }));
    }

    await Child.updateOne(
      { _id: child._id },
      { $push: { parents: parent._id } },
      { session },
    );

    await session.commitTransaction();
    //send response
    return res.status(200).json({
      success: true,
      message: "Accounts Linked Successfully",
    });
  } catch (error) {
    await session.abortTransaction();
    next(error);
  } finally {
    await session.endSession();
  }
};

export const myParents = async (req, res, next) => {
  const child = await Child.findOne({ userId: req.user._id }).populate({
    path: "parents",
    select: "age",
    populate: {
      path: "userId",
      select: " -_id name dateOfBirth profilePic",
    },
  });
  if (!child) {
    return next(new Error("Parent profile not found", { cause: 404 }));
  }

  const parents = child.parents.map((parent) => ({
    parentId: parent._id,
    avater: parent.userId.profilePic,
    name: parent.userId.name,
    age: parent.userId.age,
  }));

  return res.status(200).json({ success: true, results: parents });
};

export const myStats = async (req, res, next) => {
  const child = await Child.findOne({ userId: req.user._id });

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
        rejected: { $sum: { $cond: [{ $eq: ["$status", "rejeted"] }, 1, 0] } },
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

  return res.status(200).json({ success: true, lastActivity, stats });
};

export const myRank = async (req, res, next) => {
  const child = await Child.findOne({
    userId: req.user._id,
  });

  if (!child) {
    return next(new Error("child profile not found", { cause: 404 }));
  }

  const higherRanks = await Child.countDocuments({
    parents: { $in: child.parents },
    totalPoints: { $gt: child.totalPoints },
  });

  const rank = higherRanks + 1;

  return res.status(200).json({
    success: true,
    rank,
    points: child.totalPoints,
  });
};

export const myPoints = async (req, res, next) => {
  const child = await Child.findOne({
    userId: req.user._id,
  });

  if (!child) {
    return next(new Error("child profile not found", { cause: 404 }));
  }

  const points = child.totalPoints;

  return res.status(200).json({ success: true, points });
};

export const topThree = async (req, res, next) => {
  const child = await Child.findOne({
    userId: req.user._id,
  });

  if (!child) {
    return next(
      new Error("Child profile not found", {
        cause: 404,
      }),
    );
  }

  const children = await Child.find({
    parents: { $in: child.parents },
  }).populate({
    path: "userId",
    select: "name profilePic",
  });

  const leaderboard = children
    .map((c) => ({
      childId: c._id,
      avatar: c.userId?.profilePic,
      name: c.userId?.name,
      points: c.totalPoints,
    }))
    .sort((a, b) => b.points - a.points);

  const top3 = leaderboard.slice(0, 3);

  return res.status(200).json({
    success: true,
    top3,
  });
};
