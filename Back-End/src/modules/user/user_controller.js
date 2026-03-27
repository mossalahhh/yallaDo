import User, { DEFAULT_PROFILE_PIC } from "../../../Db/models/user_model.js";
import Parent from "../../../Db/models/parent_model.js";
import Child from "../../../Db/models/child_model.js";
import cloudinary from "../../utils/cloudinary.js";
import bcrypt from "bcryptjs";
import { sendEmail } from "../../utils/sendEmail.js";
import { changeEmailTemp } from "../../utils/html_template.js";
import Randomstring from "randomstring";

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

  return res.status(200).json({
    success: true,
    message: "Name changed successfully",
    results: user.name,
  });
};

//change email
export const changeEmail = async (req, res, next) => {
  //new email && password from body
  const { newEmail, password } = req.body;
  //get user from db

  const user = await User.findById(req.user._id).select("+password");

  const emailExists = await User.findOne({ email: newEmail });
  if (emailExists) {
    return next(new Error("Email already in use", { cause: 409 }));
  }

  if (user.email === newEmail) {
    return next(
      new Error("This is already your current email", { cause: 400 }),
    );
  }

  //ensure from password to verify user
  const isMatch = await bcrypt.compare(password, user.password);

  if (!isMatch) {
    return next(new Error("Invalid Password", { cause: 409 }));
  }

  //generate code
  const code = Randomstring.generate({
    length: 6,
    charset: "numeric",
  });
  //send gmail code to changeEmail

  const send = await sendEmail({
    to: newEmail,
    subject: "Change Email",
    html: changeEmailTemp(code),
  });

  if (!send) {
    return next(new Error("invalid Email", { cause: 403 }));
  }
  //store email in pending emails Db
  user.pendingEmail = newEmail;
  user.emailChangeCode = code;
  //update expire date
  user.emailChangeCodeExpires = Date.now() + 10 * 60 * 1000;

  await user.save();

  //send res
  return res.status(200).json({ success: true, message: "Check Your Email" });
};

//confirm new email
export const confirmEmail = async (req, res, next) => {
  const { code } = req.body;

  const user = await User.findById(req.user._id);
  if (code !== user.emailChangeCode) {
    return next(new Error("Invalid code", { cause: 400 }));
  }
  if (!user || !user.emailChangeCode) {
    return next(new Error("Invalid request", { cause: 400 }));
  }

  // check expire
  if (user.emailChangeCodeExpires < Date.now()) {
    return next(new Error("Code expired", { cause: 400 }));
  }

  user.email = user.pendingEmail;
  user.emailChangeCode = undefined;
  user.emailChangeCodeExpires = undefined;
  user.pendingEmail = undefined;

  await user.save();

  return res
    .status(200)
    .json({ success: true, message: "Email Changed Successfully" });
};

//update PASSWORD if user know current password
export const updatePassword = async (req, res, next) => {
  //data
  const { oldPassword, newPassword } = req.body;
  //find user
  const user = await User.findById(req.user._id).select("+password");

  const isMatch = await bcrypt.compare(oldPassword, user.password);

  if (!isMatch) {
    return next(new Error("Incorrect Password", { cause: 400 }));
  }

  const hashPassword = bcrypt.hashSync(
    newPassword,
    Number(process.env.SALT_ROUND),
  );

  user.password = hashPassword;
  await user.save();
  return res
    .status(200)
    .json({ success: true, message: "Password Changed Successfully" });
};
