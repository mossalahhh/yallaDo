import { Router } from "express";
import { isAuthorized } from "../../middleware/authorization.js";
import { isAuthenticated } from "../../middleware/authentication.js";
import { isValid } from "../../middleware/validation_middleware.js";
import { catchErorr } from "../../utils/catchErorr.js";
import { inviteCode, myChildren } from "./parent_controller.js";
const router = Router();

router.post(
  "/invite-code",
  isAuthenticated,
  isAuthorized("parent"),
  catchErorr(inviteCode),
);

router.get(
  "/children",
  isAuthenticated,
  isAuthorized("parent"),
  catchErorr(myChildren),
);
export default router;
