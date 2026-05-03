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
