import mongoose, { model, Schema, Types } from "mongoose";
import { queryHelperPlugin } from "../query_helpers.js";

const taskSchema = new Schema(
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
      ref: "Parent",
    },

    assignedTo: {
      type: Types.ObjectId,
      ref: "Child",
      default: null,
      required: function () {
        return this.type === "personal";
      },
    },

    type: {
      type: String,
      enum: ["personal", "open"],
      required: true,
    },

    claimedBy: {
      type: Types.ObjectId,
      ref: "Child",
      default: null,
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
      enum: ["pending", "claimed", "rejected", "submitted", "approved"],
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

    requirements: {
      submissionType: {
        type: String,
        enum: ["text", "image", "both"],
        default: "text",
      },
      minImages: {
        type: Number,
        default: 0,
        min: 0,
      },
    },

    submission: {
      description: {
        type: String,
        maxlength: [500, "Submission description too long"],
      },
      images: [
        {
          url: String,
          id: String,
        },
      ],
      submittedAt: Date,
    },
    isDeleted: {
      type: Boolean,
      default: false,
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
    this.dueDate && this.status !== "approved" && this.dueDate < new Date()
  );
});

taskSchema.virtual("isClaimed").get(function () {
  return !!this.claimedBy;
});

//return clean res and remove empty fields
taskSchema.set("toJSON", {
  transform: (doc, ret) => {
    ret.taskId = ret._id;
    delete ret._id;
    delete ret.__v;

    // remove empty claimedBy
    if (!ret.claimedBy) delete ret.claimedBy;

    //remove assignedTo if null
    if (!ret.assignedTo) delete ret.assignedTo;
    // remove empty submission
    if (!ret.submission?.images?.length && !ret.submission?.description) {
      delete ret.submission;
    }
    // remove empty image
    if (!ret.image?.url) {
      delete ret.image;
    }

    return ret;
  },
});

taskSchema.index({ assignedTo: 1, status: 1, dueDate: 1 });
taskSchema.index({ createdBy: 1, status: 1, createdAt: -1 });

taskSchema.plugin(queryHelperPlugin);

const Task = mongoose.models.Task || model("Task", taskSchema);

export default Task;
