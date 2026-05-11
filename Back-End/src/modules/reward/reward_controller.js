import History from "../../../Db/models/history_mode.js";
import Parent from "../../../Db/models/parent_model.js";
import Child from "../../../Db/models/child_model.js";
import Reward from "../../../Db/models/reward_model.js";
import cloudinary from "../../utils/cloudinary.js";

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
