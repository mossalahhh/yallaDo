import { Router } from "express";
import { isAuthorized } from "../../middleware/authorization.js";
import { isAuthenticated } from "../../middleware/authentication.js";
import { isValid } from "../../middleware/validation_middleware.js";
import { fileUpload, validationImg } from "../../utils/multer.js";
import { catchErorr } from "../../utils/catchErorr.js";
import { createTask, getTasks, singleTask } from "./task_controller.js";
import {
  createTaskSchema,
  getTasksSchema,
  getSingleTaskSchema,
} from "./task_validation.js";

const router = Router();

router.post(
  "/create",
  isAuthenticated,
  isAuthorized("parent"),
  fileUpload(validationImg.images).single("taskImg"),
  isValid(createTaskSchema),
  catchErorr(createTask),
);

router.get(
  "/tasks",
  isAuthenticated,
  isValid(getTasksSchema),
  catchErorr(getTasks),
);
router.get(
  "/:taskId",
  isAuthenticated,
  isValid(getSingleTaskSchema),
  catchErorr(singleTask),
);
export default router;
