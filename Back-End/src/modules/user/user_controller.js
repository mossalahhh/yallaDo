import User from "../../../Db/models/user_model.js";
import cloudinary from "../../utils/cloudinary.js";

export const profilePic = async (req, res, next) => {
  const user = await User.findById(req.user._id);
  if (!user) {
    return next(new Error("user not found", { cause: 403 }));
  }

  if (!req.file) {
    return next(new Error("File Image is Required", { cause: 403 }));
  }

  const { secure_url, public_id } = await cloudinary.uploader.upload(
    req.file.path,
    {
      folder: `${process.env.FOLDER_NAME}/users/${user._id}`,
    },
  );

  user.profilePic = { url: secure_url, id: public_id };
  await user.save();
  res.status(200).json({ message: "Profile picture updated successfully" });
};
