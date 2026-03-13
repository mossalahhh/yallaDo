import mongoose, { Schema, model } from "mongoose";

export const DEFAULT_PROFILE_PIC = {
  url: "https://res.cloudinary.com/dyiwhfw9j/image/upload/v1768753015/360_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69_ii4edj.jpg",
  id: "360_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69_ii4edj",
};

const userSchema = new Schema(
  {
    name: {
      type: String,
      required: true,
      min: 3,
      max: 15,
    },
    userName: {
      type: String,
      required: true,
      unique: true,
      min: 3,
      max: 15,
    },
    email: {
      type: String,
      required: true,
      unique: true,
      match: [
        /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/,
        "Please provide a valid email",
      ],
    },
    password: {
      type: String,
      required: true,
      select: false,
    },
    gender: {
      type: String,
      enum: ["male", "female"],
      required: true,
    },
    role: {
      type: String,
      enum: ["parent", "child"],
      default: "child",
    },
    status: {
      type: String,
      enum: ["online", "offline"],
      default: "offline",
    },
    isEmailVerified: {
      type: Boolean,
      default: false,
    },

    forgetCode: String,
    forgetCodeExpires: Date,

    activationCode: String,
    activationCodeExpires: {
      type: Date,
      default: () => Date.now() + 10 * 60 * 1000, // 10 minutes
    },

    profilePic: {
      url: {
        type: String,
        default: DEFAULT_PROFILE_PIC.url,
      },
      id: {
        type: String,
        default: DEFAULT_PROFILE_PIC.id,
      },
    },
  },
  { timestamps: true },
);

userSchema.index({ role: 1 });

const User = mongoose.models.User || model("User", userSchema);

export default User;
