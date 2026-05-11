import Task from "../../../Db/models/task_model.js";
import cloudinary from "../../utils/cloudinary.js";
import Parent from "../../../Db/models/parent_model.js";
import Child from "../../../Db/models/child_model.js";
import History from "../../../Db/models/history_mode.js";
import mongoose from "mongoose";

export const createTask = async (req, res, next) => {
  //data
  const {
    title,
    description,
    type,
    assignedTo,
    points,
    priority,
    category,
    submissionType,
    minImages,
    dueDate,
  } = req.body;
  //find parent
  if (type === "open" && assignedTo) {
    return next(new Error("Open task cannot have assignedTo"));
  }

  if (type === "personal" && !assignedTo) {
    return next(new Error("assignedTo is required for personal tasks"));
  }

  if (submissionType === "text" && minImages > 0) {
    return next(new Error("minImages must be 0 when submissionType is text"));
  }

  let due = undefined;

  if (dueDate) {
    due = new Date(dueDate);
    due.setHours(23, 59, 59, 999);

    if (due < new Date()) {
      return next(new Error("Due date must be in the future", { cause: 400 }));
    }
  }

  const parent = await Parent.findOne({ userId: req.user._id }).lean();
  if (!parent) {
    return next(new Error("Parent profile not found", { cause: 404 }));
  }
  const createdBy = parent._id;

  //find child
  let child = null;
  if (type === "personal") {
    child = await Child.findOne({
      _id: assignedTo,
      parents: parent._id,
    }).lean();
    if (!child) {
      return next(
        new Error("Child profile not found or Not linked with this parent", {
          cause: 404,
        }),
      );
    }
  }

  //create Task
  const task = await Task.create({
    title,
    description,
    createdBy,
    type,
    assignedTo: type === "personal" ? assignedTo : null,
    points,
    priority,
    category,
    requirements: {
      submissionType: submissionType ?? "text",
      minImages: minImages ?? 0,
    },
    dueDate: due || undefined,
  });

  if (req.file) {
    //upload image for task
    const { secure_url, public_id } = await cloudinary.uploader.upload(
      req.file.path,
      {
        folder: `${process.env.FOLDER_NAME}/tasks/${task._id}`,
      },
    );

    task.image = {
      url: secure_url,
      id: public_id,
    };

    await task.save();
  }
  //clean res
  const taskResObj = {
    taskId: task._id,
    taskImage: task.image,
    title: task.title,
    description: task.description,
    createdBy: task.createdBy,
    type: task.type,
    assignedTo: child?._id || null,
    points: task.points,
    priority: task.priority,
    category: task.category,
    requirements: task.requirements,
    dueDate: task.dueDate,
  };

  //return res
  return res.status(201).json({
    success: true,
    message: "Task Created Successfully",
    taskDetails: taskResObj,
  });
};

export const getTasks = async (req, res, next) => {
  const user = req.user;
  const { fields, page, ...rest } = req.query;
  const filter = {};

  const parent = await Parent.findOne({ userId: user._id });
  const child = await Child.findOne({ userId: user._id });

  if (user.role === "parent" && !parent) {
    return next(new Error("Parent not found", { cause: 404 }));
  }

  if (user.role === "child" && !child) {
    return next(new Error("Child not found", { cause: 404 }));
  }
  if (user.role === "parent") {
    filter.createdBy = parent._id;
    filter.isDeleted = { $ne: true };
  } else {
    filter.isDeleted = { $ne: true };
    filter.$or = [
      { assignedTo: child._id },
      { type: "open", claimedBy: null },
      { claimedBy: child._id },
    ];
  }

  const task = await Task.find(filter)
    .customFilter(rest)
    .customSelect(fields)
    .paginate(page)
    .sort({ createdAt: -1 });

  return res.json({ success: true, page, data: task });
};

export const singleTask = async (req, res, next) => {
  const { taskId } = req.params;

  const task = await Task.findById(taskId);

  if (!task) {
    return next(new Error("invaild task Id", { cause: 404 }));
  }

  return res.status(200).json({ success: true, task });
};

export const claimTask = async (req, res, next) => {
  const { taskId } = req.params;
  const child = await Child.findOne({ userId: req.user._id });

  const task = await Task.findOneAndUpdate(
    {
      _id: taskId,
      type: "open",
      claimedBy: null,
    },
    { claimedBy: child._id, status: "claimed" },
    { new: true },
  );

  if (!task) {
    return next(new Error("Task already claimed", { cause: 400 }));
  }

  return res.json({ sucess: true, data: task });
};

export const submitTask = async (req, res, next) => {
  //get data
  const { taskId } = req.params;
  const description = req.body?.description;

  const task = await Task.findById({ _id: taskId });

  const child = await Child.findOne({ userId: req.user._id });

  if (!child) {
    return next(new Error("child profile not found ", { cause: 404 }));
  }

  // console.log({
  //   user: child._id.toString(),
  //   assignedTo: task.assignedTo?.toString(),
  //   claimedBy: task.claimedBy?.toString(),
  //   type: task.type,
  // });

  if (!task) {
    return next(new Error("Task not found", { cause: 404 }));
  }
  //check ownership
  const isOwner =
    child._id.toString() === task.claimedBy?.toString() ||
    child._id.toString() === task.assignedTo?.toString();

  if (!isOwner) {
    return next(new Error("Not authorized", { cause: 403 }));
  }

  //check status
  if (task.status !== "pending" && task.status !== "claimed") {
    return next(new Error("Task cannot be submitted", { cause: 400 }));
  }

  //requirments
  if (
    (task.requirements.submissionType === "text" ||
      task.requirements.submissionType === "both") &&
    !description
  ) {
    return next(new Error("Description is required", { cause: 400 }));
  }

  let images = [];
  if (
    task.requirements.submissionType === "image" ||
    task.requirements.submissionType === "both"
  ) {
    if (!req.files || req.files.length < task.requirements.minImages) {
      return next(new Error("Not enough images", { cause: 400 }));
    }

    for (const file of req.files) {
      const { secure_url, public_id } = await cloudinary.uploader.upload(
        file.path,
        { folder: `${process.env.FOLDER_NAME}/tasks/submissions/${task._id}` },
      );
      images.push({ url: secure_url, id: public_id });
    }
  }

  task.submission = {
    description,
    images,
    submittedAt: new Date(),
  };

  task.status = "submitted";

  await task.save();

  return res
    .status(200)
    .json({ success: true, message: "Task submitted successfully", task });
};

export const approveTask = async (req, res, next) => {
  const { taskId } = req.params;
  const session = await mongoose.startSession();

  session.startTransaction();
  try {
    const task = await Task.findById(taskId).session(session);

    const parent = await Parent.findOne({ userId: req.user._id }).session(
      session,
    );
    //isOwner
    if (parent._id.toString() !== task.createdBy.toString()) {
      return next(new Error("Not authorized", { cause: 403 }));
    }

    if (!task) {
      return next(new Error("Task Not Found", { cause: 404 }));
    }

    if (task.status === "approved") {
      return next(new Error("Task already approved", { cause: 400 }));
    }

    if (task.status !== "submitted") {
      return next(
        new Error("You Can not approve unsubmitted tasks", { cause: 400 }),
      );
    }

    const childId = task.claimedBy || task.assignedTo;
    console.log(childId);
    if (!childId) {
      return next(new Error("Task has no assigned child", { cause: 400 }));
    }

    task.status = "approved";
    task.approvedAt = new Date();

    await task.save({ session });

    const updatedPoints = task.points;

    await Child.findByIdAndUpdate(
      childId,
      { $inc: { totalPoints: updatedPoints } },
      { session },
    );
    await History.create(
      [
        {
          childId,
          parentId: parent._id,
          points: updatedPoints,
          source: "task",
          type: "add",
          reason: "Approved Task",
        },
      ],
      { session },
    );
    await session.commitTransaction();

    return res.status(200).json({ success: true, message: "Task Approved" });
  } catch (error) {
    await session.abortTransaction();
    next(error);
  } finally {
    session.endSession();
  }
};

export const rejectTask = async (req, res, next) => {
  const { taskId } = req.params;
  const rejectionReason = req.body?.rejectionReason;
  const task = await Task.findById(taskId);

  if (!task) {
    return next(new Error("Task Not Found", { cause: 404 }));
  }

  const parent = await Parent.findOne({ userId: req.user._id });
  if (parent._id.toString() !== task.createdBy.toString()) {
    return next(new Error("Not authorized", { cause: 403 }));
  }

  if (task.status === "rejected") {
    return next(new Error("Task already rejected", { cause: 400 }));
  }

  if (task.status !== "submitted") {
    return next(
      new Error("You Can not reject unsubmitted tasks", { cause: 400 }),
    );
  }

  task.rejectionReason = rejectionReason;
  task.status = "rejected";
  await task.save();

  return res
    .status(200)
    .json({ success: true, message: "Task Rejected Successfully" });
};

export const updateTask = async (req, res, next) => {
  const { taskId } = req.params;
  const { title, points, dueDate } = req.body;

  const task = await Task.findById(taskId);

  if (!task) {
    return next(new Error("Task Not Found", { cause: 404 }));
  }

  const parent = await Parent.findOne({ userId: req.user._id });
  if (!parent) {
    return next(new Error("Parent Profile Not Found", { cause: 404 }));
  }

  if (parent._id.toString() !== task.createdBy.toString()) {
    return next(new Error("Not authorized", { cause: 403 }));
  }

  let due = undefined;

  if (dueDate) {
    due = new Date(dueDate);
    due.setHours(23, 59, 59, 999);

    if (due < new Date()) {
      return next(new Error("Due date must be in the future", { cause: 400 }));
    }
  }
  if (
    task.status === "submitted" ||
    task.status === "rejected" ||
    task.status === "approved"
  ) {
    return next(new Error("You Can not Updated this Task", { cause: 400 }));
  }

  if (req.file) {
    if (task.image?.id) {
      await cloudinary.uploader.destroy(task.image.id);
    }

    const { secure_url, public_id } = await cloudinary.uploader.upload(
      req.file.path,
      {
        folder: `${process.env.FOLDER_NAME}/tasks/${task._id}`,
      },
    );

    task.image = {
      url: secure_url,
      id: public_id,
    };
  }

  task.title = title ? title : task.title;
  task.points = points ? points : task.points;
  task.dueDate = dueDate ? due : task.dueDate;

  await task.save();

  return res
    .status(200)
    .json({ success: true, message: "Task Updated Successfully", task });
};

//delete task (soft delete)
export const deleteTask = async (req, res, next) => {
  const { taskId } = req.params;

  const task = await Task.findById(taskId);

  if (!task) {
    return next(new Error("Task Not Found", { cause: 404 }));
  }

  const parent = await Parent.findOne({ userId: req.user._id });
  if (!parent) {
    return next(new Error("Parent Profile Not Found", { cause: 404 }));
  }

  if (parent._id.toString() !== task.createdBy.toString()) {
    return next(new Error("Not authorized", { cause: 403 }));
  }

  task.isDeleted = true;
  await task.save();

  return res
    .status(200)
    .json({ success: true, message: "Task Deleted Successfully" });
};

export const getDelTasks = async (req, res, next) => {
  const parent = await Parent.findOne({ userId: req.user._id });
  const task = await Task.find({ isDeleted: true, createdBy: parent._id }).sort(
    { createdAt: -1 },
  );

  return res.status(200).json({ success: true, data: task });
};

export const retoreTask = async (req, res, next) => {
  const { taskId } = req.params;
  const parent = await Parent.findOne({ userId: req.user._id });

  if (!parent) {
    return next(new Error("Parent not found", { cause: 404 }));
  }

  const task = await Task.findOne({
    _id: taskId,
    createdBy: parent._id,
  });

  if (!task) {
    return next(new Error("Task not found", { cause: 404 }));
  }

  if (!task.isDeleted) {
    return next(new Error("Task is not deleted", { cause: 400 }));
  }

  task.isDeleted = false;
  await task.save();

  return res
    .status(200)
    .json({ success: true, message: "Task Restored Successfully", task });
};
