import mongoose, { Types, Schema, model } from "mongoose";
const historySchema = new Schema(
  {
    childId: {
      type: Types.ObjectId,
      ref: "child",
      required: true,
    },
    parentId: {
      type: Types.ObjectId,
      ref: "parent",
      required: true,
    },
    points: {
      type: Number,
      required: true,
    },
    type: {
      type: String,
      enum: ["add", "remove"],
      required: true,
    },
    source: {
      type: String,
      enum: ["manual", "task", "reward"],
    },
    reason: String,
  },
  { timestamps: true },
);

const History = mongoose.models.History || model("History", historySchema);

export default History;
