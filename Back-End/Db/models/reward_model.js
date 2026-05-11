import mongoose, { Schema, Types, model } from "mongoose";

import { queryHelperPlugin } from "../query_helpers.js";

const rewardSchema = new Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
    },
    createdBy: {
      type: Types.ObjectId,
      ref: "Parent",
      required: true,
    },
    description: {
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
    isActive: {
      type: Boolean,
      default: true,
    },

    isDeleted: {
      type: Boolean,
      default: false,
    },

    quantity: {
      type: Number,
      default: 1,
      min: 0,
    },
  },
  { timestamps: true },
);

rewardSchema.plugin(queryHelperPlugin);
const Reward = mongoose.models.Reward || model("Reward", rewardSchema);

export default Reward;
