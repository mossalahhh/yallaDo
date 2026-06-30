import Parent from "../../../Db/models/parent_model.js";
import Child from "../../../Db/models/child_model.js";
import Notification from "../../../Db/models/notification_model.js";

export const getNotifications = async (req, res, next) => {
  const user = req.user;
  const { fields, page, ...rest } = req.query;

  const parent = await Parent.findOne({ userId: user._id });
  const child = await Child.findOne({ userId: user._id });

  if (user.role === "parent" && !parent) {
    return next(new Error("Parent not found", { cause: 404 }));
  }

  if (user.role === "child" && !child) {
    return next(new Error("Child not found", { cause: 404 }));
  }
  const filter = {};

  if (user.role === "parent") {
    filter.receiver = parent._id;
  } else {
    filter.receiver = child._id;
  }

  const notifications = await Notifications.find(filter)
    .customFilter(rest)
    .customSelect(fields)
    .paginate(page)
    .sort({ createdAt: -1 });

  return res.status(200).json({ success: true, notifications });
};

export const readNot = async (req, res, next) => {
  const { notificationId } = req.params;
  const user = req.user;

  const parent = await Parent.findOne({
    userId: user._id,
  });

  const child = await Child.findOne({
    userId: user._id,
  });

  if (user.role === "parent" && !parent) {
    return next(
      new Error("Parent profile not found", {
        cause: 404,
      }),
    );
  }

  if (user.role === "child" && !child) {
    return next(
      new Error("Child profile not found", {
        cause: 404,
      }),
    );
  }

  const receiverId = user.role === "parent" ? parent._id : child._id;

  const notification = await Notification.findOne({
    _id: notificationId,
    receiver: receiverId,
  });

  if (!notification) {
    return next(
      new Error("Notification not found", {
        cause: 404,
      }),
    );
  }

  if (!notification.isRead) {
    notification.isRead = true;
    notification.readAt = new Date();

    await notification.save();
  }

  return res.status(200).json({
    success: true,
    message: "Notification marked as read",
    notification,
  });
};

export const readallNot = async (req, res, next) => {
  const user = req.user;

  const parent = await Parent.findOne({
    userId: user._id,
  });

  const child = await Child.findOne({
    userId: user._id,
  });

  if (user.role === "parent" && !parent) {
    return next(
      new Error("Parent profile not found", {
        cause: 404,
      }),
    );
  }

  if (user.role === "child" && !child) {
    return next(
      new Error("Child profile not found", {
        cause: 404,
      }),
    );
  }

  const receiverId = user.role === "parent" ? parent._id : child._id;

  const result = await Notification.updateMany(
    {
      receiver: receiverId,
      isRead: false,
    },
    {
      isRead: true,
      readAt: new Date(),
    },
  );

  return res.status(200).json({
    success: true,
    message: "All notifications marked as read",
    matched: result.matchedCount,
    updated: result.modifiedCount,
  });
};

export const deleteNot = async (req, res, next) => {
  const { notificationId } = req.params;
  const user = req.user;

  const parent = await Parent.findOne({
    userId: user._id,
  });

  const child = await Child.findOne({
    userId: user._id,
  });

  if (user.role === "parent" && !parent) {
    return next(
      new Error("Parent profile not found", {
        cause: 404,
      }),
    );
  }

  if (user.role === "child" && !child) {
    return next(
      new Error("Child profile not found", {
        cause: 404,
      }),
    );
  }

  const receiverId = user.role === "parent" ? parent._id : child._id;

  const notification = await Notification.findOneAndDelete({
    _id: notificationId,
    receiver: receiverId,
  });

  if (!notification) {
    return next(
      new Error("Notification not found", {
        cause: 404,
      }),
    );
  }

  return res.status(200).json({
    success: true,
    message: "Notification Deleted",
  });
};

export const deleteallNot = async (req, res, next) => {
  const user = req.user;

  const parent = await Parent.findOne({
    userId: user._id,
  });

  const child = await Child.findOne({
    userId: user._id,
  });

  if (user.role === "parent" && !parent) {
    return next(
      new Error("Parent profile not found", {
        cause: 404,
      }),
    );
  }

  if (user.role === "child" && !child) {
    return next(
      new Error("Child profile not found", {
        cause: 404,
      }),
    );
  }

  const receiverId = user.role === "parent" ? parent._id : child._id;

  const result = await Notification.deleteMany({
    receiver: receiverId,
  });

  return res.status(200).json({
    success: true,
    message: "All notifications Deleted",
    matched: result.matchedCount,
    updated: result.modifiedCount,
  });
};

export const countNot = async (req, res, next) => {
  const user = req.user;

  const parent = await Parent.findOne({
    userId: user._id,
  });

  const child = await Child.findOne({
    userId: user._id,
  });

  if (user.role === "parent" && !parent) {
    return next(
      new Error("Parent profile not found", {
        cause: 404,
      }),
    );
  }

  if (user.role === "child" && !child) {
    return next(
      new Error("Child profile not found", {
        cause: 404,
      }),
    );
  }

  const receiverId = user.role === "parent" ? parent._id : child._id;

  const result = await Notification.find({
    receiver: receiverId,
  });

  const count = result.length;

  return res.status(200).json({
    success: true,
    count,
  });
};
