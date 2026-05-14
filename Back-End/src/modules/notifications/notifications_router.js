import { Router } from "express";
import { isAuthorized } from "../../middleware/authorization.js";
import { isAuthenticated } from "../../middleware/authentication.js";
import { catchErorr } from "../../utils/catchErorr.js";
import { isValid } from "../../middleware/validation_middleware.js";
import {
  getNotififcationSchema,
  idNotSchema,
} from "./notification_validation.js";

import {
  getNotifications,
  readNot,
  readallNot,
  deleteNot,
  deleteallNot,
  countNot,
} from "./notification_controller.js";

const router = Router();

router.get(
  "/",
  isAuthenticated,
  isValid(getNotififcationSchema),
  catchErorr(getNotifications),
);

router.patch("/readall", isAuthenticated, catchErorr(readallNot));

router.delete("/deleteall", isAuthenticated, catchErorr(deleteallNot));

router.get("/count", isAuthenticated, catchErorr(countNot));

router.patch(
  "/:notificationId/read",
  isAuthenticated,
  isValid(idNotSchema),
  catchErorr(readNot),
);

router.delete(
  "/:notificationId/delete",
  isAuthenticated,
  isValid(idNotSchema),
  catchErorr(deleteNot),
);

export default router;
