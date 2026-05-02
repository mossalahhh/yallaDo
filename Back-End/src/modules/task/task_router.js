import { Router } from "express";
import { isAuthorized } from "../../middleware/authorization.js";
import { isAuthenticated } from "../../middleware/authentication.js";
import { isValid } from "../../middleware/validation_middleware.js";
import { fileUpload, validationImg } from "../../utils/multer.js";
import { catchErorr } from "../../utils/catchErorr.js";
import {
  createTask,
  getTasks,
  singleTask,
  claimTask,
  submitTask,
  approveTask,
  rejectTask,
  updateTask,
  deleteTask,
  getDelTasks,
} from "./task_controller.js";
import {
  createTaskSchema,
  getTasksSchema,
  checkIdSchema,
  submitSchema,
  rejectSchema,
  updateSchema,
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
  "/tasks-deleted",
  isAuthenticated,
  isAuthorized("parent"),
  catchErorr(getDelTasks),
);
router.get(
  "/:taskId",
  isAuthenticated,
  isValid(checkIdSchema),
  catchErorr(singleTask),
);
router.patch(
  "/:taskId/claim",
  isAuthenticated,
  isAuthorized("child"),
  isValid(checkIdSchema),
  catchErorr(claimTask),
);
router.patch(
  "/:taskId/submit",
  isAuthenticated,
  isAuthorized("child"),
  fileUpload(validationImg.images).array("submitImgs", 5),
  isValid(submitSchema),
  catchErorr(submitTask),
);
router.patch(
  "/:taskId/approve",
  isAuthenticated,
  isAuthorized("parent"),
  isValid(checkIdSchema),
  catchErorr(approveTask),
);
router.patch(
  "/:taskId/reject",
  isAuthenticated,
  isAuthorized("parent"),
  isValid(rejectSchema),
  catchErorr(rejectTask),
);
router.patch(
  "/:taskId/update",
  isAuthenticated,
  isAuthorized("parent"),
  isValid(updateSchema),
  catchErorr(updateTask),
);
router.patch(
  "/:taskId/delete",
  isAuthenticated,
  isAuthorized("parent"),
  isValid(checkIdSchema),
  catchErorr(deleteTask),
);
export default router;
