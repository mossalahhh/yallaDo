import { Router } from "express";
import { isAuthorized } from "../../middleware/authorization.js";
import { isAuthenticated } from "../../middleware/authentication.js";
import { isValid } from "../../middleware/validation_middleware.js";
import { catchErorr } from "../../utils/catchErorr.js";
import { isValid } from "../../middleware/validation_middleware.js";
import { getNotififcationSchema } from "./notification_validation.js";
import { getNotifications } from "./notification_controller.js";

const router = Router();

router.get(
  "/",
  isAuthenticated,
  isValid(getNotififcationSchema),
  catchErorr(getNotifications),
);

export default router;
