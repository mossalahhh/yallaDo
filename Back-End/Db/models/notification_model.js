import mongoose, { Schema, Types, model } from "mongoose";

const notificationSchema = new Schema(
  {
    receiver: {
      type: Types.ObjectId,
      required: true,
      refPath: "receiverModel",
    },

    receiverModel: {
      type: String,
      enum: ["Parent", "Child"],
      required: true,
    },

    sender: {
      type: Types.ObjectId,
      refPath: "senderModel",
    },

    senderModel: {
      type: String,
      enum: ["Parent", "Child"],
    },

    title: {
      type: String,
      required: true,
      trim: true,
    },

    message: {
      type: String,
      required: true,
      trim: true,
    },

    type: {
      type: String,
      enum: [
        "new_personal_task",
        "new_open_task",

        "task_claimed",
        "task_submitted",
        "task_approved",
        "task_rejected",

        "reward_created",
        "reward_redeemed",

        "points_added",
        "points_removed",
      ],
      required: true,
    },

    relatedId: {
      type: Types.ObjectId,
      refPath: "relatedModel",
    },

    relatedModel: {
      type: String,
      enum: ["Task", "Reward"],
    },

    isRead: {
      type: Boolean,
      default: false,
    },

    readAt: Date,
  },
  {
    timestamps: true,
  },
);

notificationSchema.index({
  receiver: 1,
  isRead: 1,
  createdAt: -1,
});

notificationSchema.set("toJSON", {
  transform: (doc, ret) => {
    ret.notificationId = ret._id;

    delete ret._id;
    delete ret.__v;

    if (!ret.sender) {
      delete ret.sender;
      delete ret.senderModel;
    }

    if (!ret.relatedId) {
      delete ret.relatedId;
      delete ret.relatedModel;
    }

    if (!ret.readAt) {
      delete ret.readAt;
    }

    return ret;
  },
});

notificationSchema.index({ receiver: 1, isRead: 1, createdAt: -1 });

const Notification =
  mongoose.models.Notification || model("Notification", notificationSchema);

export default Notification;
