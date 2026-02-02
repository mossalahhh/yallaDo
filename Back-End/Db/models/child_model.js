import mongoose, { Schema, Types, model } from "mongoose";

const childSchema = new Schema(
  {
    userId: {
      type: Types.ObjectId,
      ref: "User",
      required: true,
      unique: true,
    },
    age: {
      type: Number,
      min: 5,
    },
    parents: [
      {
        type: Types.ObjectId,
        ref: "Parent",
      },
    ],
    totalPoints: {
      type: Number,
      default: 0,
      min: 0,
    },
    spentPoints: {
      type: Number,
      default: 0,
      min: 0,
    },
  },
  { timestamps: true },
);

const Child = mongoose.models.Child || model("Child", childSchema);

export default Child;
