import User, { DEFAULT_PROFILE_PIC } from "../../../Db/models/user_model.js";
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
  res
    .status(200)
    .json({ success: true, message: "Profile picture updated successfully" });
};

//return to default img
export const deleteProfilePic = async (req, res, next) => {
  const user = await User.findById(req.user._id);
  if (!user) {
    return next(new Error("user not found", { cause: 403 }));
  }

  const currentProfilePicId = user.profilePic?.id;

  if (currentProfilePicId && currentProfilePicId !== DEFAULT_PROFILE_PIC.id) {
    await cloudinary.uploader.destroy(currentProfilePicId);
  }

  user.profilePic = DEFAULT_PROFILE_PIC;

  await user.save();

  return res
    .status(200)
    .json({ success: true, message: "Profile picture deleted successfully" });
};
