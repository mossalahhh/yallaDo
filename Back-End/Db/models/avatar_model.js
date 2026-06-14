import mongoose, { model, Schema } from "mongoose";

const avatarSchema = new Schema(
  {
    title: {
      type: String,
      required: [true, "Avatar title is required"],
      trim: true,
    },
    imageUrl: {
      type: String,
      required: [true, "Avatar image URL is required"],
      trim: true,
    },
    pointsRequired: {
      type: Number,
      default: 0,
      min: [0, "Points cannot be negative"],
    },
    isDefault: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
    toJSON: { virtuals: true },
    toObject: { virtuals: true },
  },
);

avatarSchema.set("toJSON", {
  transform: (doc, ret) => {
    ret.avatarId = ret._id;
    delete ret._id;
    delete ret.__v;
    return ret;
  },
});

const Avatar = mongoose.models.Avatar || model("Avatar", avatarSchema);

export default Avatar;
