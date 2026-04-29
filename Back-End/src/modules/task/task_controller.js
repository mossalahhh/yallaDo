import Task from "../../../Db/models/task_model.js";
import cloudinary from "../../utils/cloudinary.js";
import Parent from "../../../Db/models/parent_model.js";
import Child from "../../../Db/models/child_model.js";

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
  };

  //return res
  return res.status(201).json({
    success: true,
    message: "Task Created Successfully",
    taskDetails: taskResObj,
  });
};
