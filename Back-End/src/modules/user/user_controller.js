import User, { DEFAULT_PROFILE_PIC } from "../../../Db/models/user_model.js";
import Parent from "../../../Db/models/parent_model.js";
import Child from "../../../Db/models/child_model.js";
import cloudinary from "../../utils/cloudinary.js";

export const profilePic = async (req, res, next) => {
  const user = await User.findById(req.user._id);
  if (!user) {
    return next(new Error("user not found", { cause: 404 }));
  }

  if (!req.file) {
    return next(new Error("File Image is Required", { cause: 400 }));
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
    return next(new Error("user not found", { cause: 404 }));
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

//get profile data (children + parents)
export const myProfile = async (req, res, next) => {
  const { _id, role } = req.user;

  let profile;
  if (role === "parent") {
    profile = await Parent.findOne({ userId: _id })
      .select("-__v -updatedAt")
      .populate({
        path: "userId",
        select: "name email profilePic userName",
      })
      .populate({
        path: "children",
        select: "_id",
      });
  } else {
    profile = await Child.findOne({ userId: _id })
      .select("-__v -updatedAt -totalPoints -spentPoints")
      .populate({
        path: "userId",
        select: "name email profilePic userName",
      })
      .populate({
        path: "parents",
        select: "_id ",
      });
  }

  if (!profile) {
    return next(new Error("Profile not found", { cause: 404 }));
  }

  const responseProfile = {
    _id: profile._id,
    user: {
      _id: profile.userId._id,
      userName: profile.userId.userName,
      name: profile.userId.name,
      email: profile.userId.email,
      avatar: profile.userId.profilePic,
    },
    role,
  };

  //parents or child count based on role
  if (role === "parent") {
    responseProfile.childrenCount = profile.children
      ? profile.children.length
      : 0;
  } else {
    responseProfile.parentsCount = profile.parents ? profile.parents.length : 0;
  }
  return res.status(200).json({ success: true, profile: responseProfile });
};

//update basic information (name)
export const updateProfile = async (req, res, next) => {
  const user = await User.findByIdAndUpdate(
    req.user._id,
    { name: req.body.name },
    { new: true },
  );

  if (!user) {
    return next(new Error("user not found", { cause: 404 }));
  }

  return res
    .status(200)
    .json({
      success: true,
      message: "Name changed successfully",
      results: user.name,
    });
};
