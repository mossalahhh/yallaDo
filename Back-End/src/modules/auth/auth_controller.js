import User from "../../../Db/models/user_model.js";
import Parent from "../../../Db/models/parent_model.js";
import Child from "../../../Db/models/child_model.js";
import Token from "../../../Db/models/token_model.js";
import Randomstring from "randomstring";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import { sendEmail } from "../../utils/sendEmail.js";
import {
  confirmationTemp,
  resetPasswordTemp,
} from "../../utils/html_template.js";

//############################################################################
//                               signup
//############################################################################

export const register = async (req, res, next) => {
  const { name, userName, email, password, gender, role, dateOfBirth } =
    req.body;
  console.log("Body ok");
  //check if user exist
  const isUser = await User.findOne({ email });
  console.log("if find user");
  if (isUser) {
    return next(new Error("This Email already Exists", { cause: 409 }));
  }

  //hashing for password
  const hashPassword = bcrypt.hashSync(
    password,
    Number(process.env.SALT_ROUND),
  );
  console.log("after hash");

  const activationCode = Randomstring.generate({
    length: 6,
    charset: "numeric",
  });

  const user = await User.create({
    name,
    userName,
    email,
    password: hashPassword,
    gender,
    role,
    dateOfBirth,
    activationCode,
    activationCodeExpires: Date.now() + 10 * 60 * 1000,
  });

  //create profile parent && child
  let profile;

  if (role === "parent") {
    profile = await Parent.create({
      userId: user._id,
      children: [],
    });
  } else {
    profile = await Child.create({
      userId: user._id,
      parents: [],
    });
  }
  //Todo if child create cart for child
  const confirmEmail = await sendEmail({
    to: email,
    subject: "Confirmation Email",
    html: confirmationTemp(activationCode),
  });

  if (!confirmEmail) {
    return next(new Error("Failed to send confirmation email", { cause: 400 }));
  }

  return res.json({
    success: true,
    message: "Please Check Your Email To Verify Your account",
    user: {
      id: user._id,
      name,
      userName,
      email,
      role,
      profileId: profile._id,
      avatar: user.profilePic,
    },
  });
};

//############################################################################
//                            confirm email
//############################################################################

export const confirmEmail = async (req, res, next) => {
  const { activationCode, email } = req.body;
  //find user by code , expired date and update them
  const user = await User.findOneAndUpdate(
    {
      email,
      activationCode,
      activationCodeExpires: { $gt: Date.now() },
    },
    {
      $set: { isEmailVerified: true },
      $unset: { activationCode: 1, activationCodeExpires: 1 },
    },
    { new: true },
  );

  if (!user) {
    return next(new Error("Invalid Code or Code Expired", { cause: 409 }));
  }

  return res.json({
    success: true,
    message: "your email verified successfully , try to login",
  });
};

//############################################################################
//                               logIn
//############################################################################

export const login = async (req, res, next) => {
  const { email, password } = req.body;

  const user = await User.findOne({ email, isEmailVerified: true }).select(
    "+password",
  );

  if (!user) {
    return next(new Error("Invalid Email", { cause: 409 }));
  }

  const isMatch = await bcrypt.compare(password, user.password);
  if (!isMatch) {
    return next(new Error("Invalid Password", { cause: 409 }));
  }

  //generate token
  const token = jwt.sign(
    { email: user.email, id: user._id, role: user.role },
    process.env.SECRET_KEY,
    { expiresIn: "10d" },
  );

  //add token to tokenDB list
  await Token.create({
    token,
    user: user._id,
    agent: req.headers["user-agent"],
  });

  user.status = "online";
  await user.save();

  return res.json({ success: true, token });
};

//############################################################################
//                        forget password code
//############################################################################

export const forgetPassword = async (req, res, next) => {
  const { email } = req.body;
  const user = await User.findOne({ email });

  if (!user) {
    return next(new Error("Invalid Email", { cause: 409 }));
  }

  const code = Randomstring.generate({
    length: 6,
    charset: "numeric",
  });

  user.forgetCode = code;
  user.forgetCodeExpires = Date.now() + 10 * 60 * 1000;

  await user.save();

  const sendCode = await sendEmail({
    to: email,
    subject: "Reset Password Code",
    html: resetPasswordTemp(code),
  });

  if (!sendCode) {
    return next(new Error("Invalid Email", { cause: 409 }));
  }

  return res.json({
    success: true,
    message: "Your Code Sent Successfully , Check Your Email",
  });
};

//############################################################################
//                           reset password
//############################################################################

export const resetPassword = async (req, res, next) => {
  const { newPassword, resetCode, email } = req.body;
  //hash for new password

  const hashPassword = bcrypt.hashSync(
    newPassword,
    Number(process.env.SALT_ROUND),
  );
  const user = await User.findOneAndUpdate(
    {
      email,
      forgetCode: resetCode,
      forgetCodeExpires: { $gt: Date.now() },
    },
    {
      $set: { password: hashPassword },
      $unset: { forgetCode: 1, forgetCodeExpires: 1 },
    },
    { new: true },
  );

  if (!user) {
    return next(new Error("Invalid Code or Code Expired", { cause: 409 }));
  }

  return res.json({
    success: true,
    message: "Your Password Updated Successfully,Try to Login Now",
  });
};

//############################################################################
//                           resend code
//############################################################################
export const resendCode = async (req, res, next) => {
  const { email, type } = req.body;

  const code = Randomstring.generate({
    length: 6,
    charset: "numeric",
  });

  const user = await User.findOne({ email });
  if (!user) {
    return next(new Error("Invalid Email", { cause: 404 }));
  }

  let send;
  const expiresAt = Date.now() + 10 * 60 * 1000;

  if (type === "activationCode") {
    user.activationCode = code;
    user.activationCodeExpires = expiresAt;

    await user.save();

    send = await sendEmail({
      to: email,
      subject: "Confirmation Email",
      html: confirmationTemp(code),
    });
  } else if (type === "forgetPassword") {
    user.forgetCode = code;
    user.forgetCodeExpires = expiresAt;

    await user.save();

    send = await sendEmail({
      to: email,
      subject: "Reset Password Code",
      html: resetPasswordTemp(code),
    });
  } else {
    return next(new Error("Invalid type parameter", { cause: 400 }));
  }

  if (!send) {
    return next(new Error("Failed to send email", { cause: 500 }));
  }

  return res.json({ success: true, message: "Code sent to your email" });
};

//############################################################################
//                                logout
//############################################################################

export const logout = async (req, res, next) => {
  const { authorization } = req.headers;

  const token = authorization.split(process.env.BEARER_TOKEN)[1].trim();

  const deleteToken = await Token.findOneAndDelete({ token });

  if (!deleteToken) {
    return next(
      new Error("You already logged out or token is invalid", { cause: 400 }),
    );
  }

  return res.json({ success: true, message: "logged out" });
};
//TODo
//create complete child && parent profile
