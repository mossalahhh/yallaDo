import { Router } from "express";
import { isAuthorized } from "../../middleware/authorization.js";
import { isAuthenticated } from "../../middleware/authentication.js";
import { isValid } from "../../middleware/validation_middleware.js";
import { fileUpload, validationImg } from "../../utils/multer.js";
import { catchErorr } from "../../utils/catchErorr.js";
import { createTask } from "./task_controller.js";
import { createTaskSchema } from "./task_validation.js";

const router = Router();

router.post(
  "/create",
  isAuthenticated,
  isAuthorized("parent"),
  fileUpload(validationImg.images).single("taskImg"),
  isValid(createTaskSchema),
  catchErorr(createTask),
);
export default router;
