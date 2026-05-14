import { Router } from "express";
import { isAuthorized } from "../../middleware/authorization.js";
import { isAuthenticated } from "../../middleware/authentication.js";
import { isValid } from "../../middleware/validation_middleware.js";
import { catchErorr } from "../../utils/catchErorr.js";

import { getNotifications } from "./notification_controller.js";

const router = Router();

router.get("/", isAuthenticated, catchErorr(getNotifications));

export default router;
