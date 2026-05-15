import mongoose, { model, Schema, Types } from "mongoose";

const parentSchema = new Schema(
  {
    userId: {
      type: Types.ObjectId,
      ref: "User",
      required: true,
      unique: true,
    },
    phoneNum: {
      type: String,
      unique: true,
      sparse: true,
    },
    children: [
      {
        type: Types.ObjectId,
        ref: "Child",
      },
    ],
    inviteCode: {
      code: {
        type: String,
        sparse: true,
      },
      expiresAt: Date,
      maxUses: { type: Number, default: 5 },
      usedCount: { type: Number, default: 0 },
    },
  },
  { timestamps: true },
);

const Parent = mongoose.models.Parent || model("Parent", parentSchema);

export default Parent;
