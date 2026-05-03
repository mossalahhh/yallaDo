import mongoose, { Schema, Types, model } from "mongoose";

const rewardSchema = new Schema(
  {
    name: {
      type: String,
      required: true,
    },
    createdBy: {
      type: Types.ObjectId,
      ref: "Parent",
    },
    describtion: {
      type: String,
    },
    image: {
      url: String,
      id: String,
    },
    points: {
      type: Number,
      min: 1,
      required: true,
    },
  },
  { timestamps: true },
);

const Reward = mongoose.models.Reward || model("Reward", rewardSchema);

export default Reward;
