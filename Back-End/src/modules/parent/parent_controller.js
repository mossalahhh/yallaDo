import Child from "../../../Db/models/child_model.js";
import Parent from "../../../Db/models/parent_model.js";
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
    await session.startTransaction();

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
