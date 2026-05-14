import History from "../../../Db/models/history_mode.js";
import Parent from "../../../Db/models/parent_model.js";
import Child from "../../../Db/models/child_model.js";
import Reward from "../../../Db/models/reward_model.js";
import cloudinary from "../../utils/cloudinary.js";
import Notification from "../../../Db/models/notification_model.js";
import mongoose from "mongoose";

export const addReward = async (req, res, next) => {
  const { name, description, points, quantity } = req.body;

  const parent = await Parent.findOne({ userId: req.user._id });
  if (!parent) {
    return next(new Error("Parent Not Found", { cause: 404 }));
  }
  const createdBy = parent._id;

  const reward = await Reward.create([
    { name, description, points, quantity, createdBy },
  ]);

  if (req.file) {
    const { secure_url, public_id } = await cloudinary.uploader.upload(
      req.file.path,
      { folder: `${process.env.FOLDER_NAME}/rewards/${reward._id}` },
    );

    reward.image = {
      url: secure_url,
      id: public_id,
    };

    await reward.save();
  }

  const children = await Child.find({
    parents: parent._id,
  }).select("_id");

  const notifications = children.map((child) => ({
    receiver: child._id,
    receiverModel: "Child",

    sender: parent._id,
    senderModel: "Parent",

    title: "New Reward at Store",
    message: `A new reward "${reward.name}" is available`,

    type: "reward_created",

    relatedId: reward._id,
    relatedModel: "Reward",
  }));
  await Notification.insertMany(notifications);

  return res
    .status(201)
    .json({ success: true, message: "Reward Created", reward });
};

export const getRewards = async (req, res, next) => {
  const user = req.user;
  const { fields, page } = req.query;

  const parent = await Parent.findOne({ userId: user._id });
  const child = await Child.findOne({ userId: user._id });

  if (user.role === "parent" && !parent) {
    return next(new Error("Parent not found", { cause: 404 }));
  }

  if (user.role === "child" && !child) {
    return next(new Error("Child not found", { cause: 404 }));
  }
  const filter = {};

  if (user.role === "parent") {
    filter.createdBy = parent._id;
    filter.isDeleted = { $ne: true };
  } else {
    filter.createdBy = { $in: child.parents };
    filter.isDeleted = { $ne: true };
    filter.isActive = true;
  }

  const rewards = await Reward.find(filter)
    .customSelect(fields)
    .paginate(page)
    .sort({ createdAt: -1 });

  return res.status(200).json({ success: true, rewards });
};

export const updateReward = async (req, res, next) => {
  const { name, description, points, quantity } = req.body;
  const { rewardId } = req.params;

  const reward = await Reward.findById(rewardId);
  if (!reward) {
    return next(new Error("Reward not found", { cause: 404 }));
  }

  const parent = await Parent.findOne({ userId: req.user._id });
  if (!parent) {
    return next(new Error("Parent not found", { cause: 404 }));
  }

  //isOwner
  if (reward.createdBy.toString() !== parent._id.toString()) {
    return next(new Error("Not authorized", { cause: 403 }));
  }

  if (req.file) {
    if (reward.image?.id) {
      await cloudinary.uploader.destroy(reward.image.id);
    }
    const { secure_url, public_id } = await cloudinary.uploader.upload(
      req.file.path,
      { folder: `${process.env.FOLDER_NAME}/rewards/${reward._id}` },
    );

    reward.image = {
      url: secure_url,
      id: public_id,
    };
  }

  reward.name = name ? name : reward.name;
  reward.description = description ? description : reward.description;
  reward.points = points ? points : reward.points;
  reward.quantity = quantity ? quantity : reward.quantity;

  await reward.save();

  return res
    .status(200)
    .json({ success: true, message: "Reward Updated Successfully", reward });
};

//soft delete
export const deleteReward = async (req, res, next) => {
  const { rewardId } = req.params;

  const reward = await Reward.findById(rewardId);
  if (!reward) {
    return next(new Error("Reward not found", { cause: 404 }));
  }

  const parent = await Parent.findOne({ userId: req.user._id });
  if (!parent) {
    return next(new Error("Parent not found", { cause: 404 }));
  }

  //isOwner
  if (reward.createdBy.toString() !== parent._id.toString()) {
    return next(new Error("Not authorized", { cause: 403 }));
  }

  reward.isDeleted = true;
  await reward.save();

  return res
    .status(200)
    .json({ success: true, message: "Reward Deleted Successfully" });
};

export const getDeletedRewards = async (req, res, next) => {
  const { fields, page } = req.query;

  const parent = await Parent.findOne({ userId: req.user._id });

  if (!parent) {
    return next(new Error("Parent not found", { cause: 404 }));
  }

  const rewards = await Reward.find({ isDeleted: true, createdBy: parent._id });

  return res.status(200).json({ success: true, rewards });
};

export const restoreReward = async (req, res, next) => {
  const { rewardId } = req.params;
  const parent = await Parent.findOne({ userId: req.user._id });

  if (!parent) {
    return next(new Error("Parent not found", { cause: 404 }));
  }

  if (reward.createdBy.toString() !== parent._id.toString()) {
    return next(new Error("Not authorized", { cause: 403 }));
  }

  const rewards = await Reward.findOne({
    _id: rewardId,
    createdBy: parent._id,
  });

  if (!rewards) {
    return next(new Error("Reward not found", { cause: 404 }));
  }

  if (!rewards.isDeleted) {
    return next(new Error("Reward is not deleted", { cause: 400 }));
  }

  rewards.isDeleted = false;
  await rewards.save();

  return res
    .status(200)
    .json({ success: true, message: "Reward Restored Successfully", rewards });
};

export const deActivateReward = async (req, res, next) => {
  const { rewardId } = req.params;

  const reward = await Reward.findById(rewardId);
  if (!reward) {
    return next(new Error("Reward not found", { cause: 404 }));
  }

  const parent = await Parent.findOne({ userId: req.user._id });
  if (!parent) {
    return next(new Error("Parent not found", { cause: 404 }));
  }

  //isOwner
  if (reward.createdBy.toString() !== parent._id.toString()) {
    return next(new Error("Not authorized", { cause: 403 }));
  }

  reward.isActive = false;
  await reward.save();

  return res
    .status(200)
    .json({ success: true, message: "Reward deactivated Successfully" });
};

export const reActivateReward = async (req, res, next) => {
  const { rewardId } = req.params;
  const parent = await Parent.findOne({ userId: req.user._id });

  if (!parent) {
    return next(new Error("Parent not found", { cause: 404 }));
  }

  const rewards = await Reward.findOne({
    _id: rewardId,
    createdBy: parent._id,
  });

  if (rewards.createdBy.toString() !== parent._id.toString()) {
    return next(new Error("Not authorized", { cause: 403 }));
  }

  if (!rewards) {
    return next(new Error("Reward not found", { cause: 404 }));
  }

  if (rewards.isActive) {
    return next(new Error("Reward Already Activated", { cause: 400 }));
  }

  rewards.isActive = true;
  await rewards.save();

  return res
    .status(200)
    .json({ success: true, message: "Reward Activated Successfully", rewards });
};

export const redeemReward = async (req, res, next) => {
  const { rewardId } = req.params;

  const session = await mongoose.startSession();

  try {
    await session.startTransaction();

    const child = await Child.findOne({ userId: req.user._id }).session(
      session,
    );

    if (!child) {
      return next(new Error("child profile not found", { cause: 404 }));
    }

    console.log(child._id);
    const reward = await Reward.findOne({
      _id: rewardId,
      createdBy: { $in: child.parents },
    }).session(session);

    if (!reward) {
      return next(new Error("Reward Not Found", { cause: 404 }));
    }

    if (reward.points > child.totalPoints) {
      return next(
        new Error("Not enough points to redeem this reward", { cause: 400 }),
      );
    }

    if (reward.quantity <= 0) {
      return next(new Error("This Reward sold out", { cause: 400 }));
    }

    if (!reward.isActive) {
      return next(
        new Error("This reward is currently unavailable", { cause: 400 }),
      );
    }

    child.spentPoints += reward.points;
    child.totalPoints -= reward.points;

    await child.save({ session });

    reward.quantity -= 1;

    await reward.save({ session });

    await History.create(
      [
        {
          childId: child._id,
          parentId: reward.createdBy,
          points: reward.points,
          source: "reward",
          type: "remove",
          reason: "claim reward",
        },
      ],
      { session },
    );

    await session.commitTransaction();

    return res.json({ success: true, message: "Reward Claimed", reward });
  } catch (error) {
    await session.abortTransaction();
    next(error);
  } finally {
    await session.endSession();
  }
};
