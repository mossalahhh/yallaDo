import Parent from "../../../Db/models/parent_model.js";
import Child from "../../../Db/models/child_model.js";
import Notifications from "../../../Db/models/notification_model.js";

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

  const rewards = await Notifications.find(filter)
    .customFilter(rest)
    .customSelect(fields)
    .paginate(page)
    .sort({ createdAt: -1 });

  return res.status(200).json({ success: true, rewards });
};
