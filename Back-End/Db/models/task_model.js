import mongoose, { model, Schema, Types } from "mongoose";

export const taskSchema = new Schema(
  {
    title: {
      type: String,
      required: true,
      trim: true,
      minlength: [3, "Title must be at least 3 characters"],
      maxlength: [100, "Title must be at most 100 characters"],
    },
    description: {
      type: String,
      trim: true,
      maxlength: [500, "Description must be at most 500 characters"],
    },
    createdBy: {
      type: Types.ObjectId,
      required: true,
      ref: "User",
    },
    assignedTo: {
      type: Types.ObjectId,
      required: true,
      ref: "User",
    },
    points: {
      type: Number,
      min: [1, "Points cannot be negative"],
      default: 1,
    },
    priority: {
      type: String,
      enum: ["low", "medium", "high"],
      default: "medium",
    },
    category: {
      type: String,
      required: true,
      trim: true,
      lowercase: true,
    },
    status: {
      type: String,
      enum: ["pending", "accepted", "rejected", "completed"],
      default: "pending",
    },
    image: {
      url: {
        type: String,
      },
      id: {
        type: String,
      },
    },
    dueDate: Date,
    completedAt: Date,
    approvedAt: Date,
    rejectionReason: String,
  },
  { timestamps: true, toJSON: true, toObject: true },
);

taskSchema.virtual("isOverdue").get(function () {
  return (
    this.dueDate && this.status !== "completed" && this.dueDate < new Date()
  );
});

taskSchema.index({ assignedTo: 1, status: 1, dueDate: 1 });
taskSchema.index({ createdBy: 1, status: 1, createdAt: -1 });

const Task = mongoose.models.Task || model("Task", taskSchema);

export default Task;
