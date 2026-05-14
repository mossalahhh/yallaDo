import { Router } from "express";
import { isAuthorized } from "../../middleware/authorization.js";
import { isAuthenticated } from "../../middleware/authentication.js";
import { catchErorr } from "../../utils/catchErorr.js";
import { isValid } from "../../middleware/validation_middleware.js";
import {
  getNotififcationSchema,
  idNotSchema,
} from "./notification_validation.js";
import { getNotifications, readNot } from "./notification_controller.js";

const router = Router();

router.get(
  "/",
  isAuthenticated,
  isValid(getNotififcationSchema),
  catchErorr(getNotifications),
);

router.patch(
  "/:notificationId/read",
  isAuthenticated,
  isValid(idNotSchema),
  catchErorr(readNot),
);

export default router;
