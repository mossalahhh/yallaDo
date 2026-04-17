import { Router } from "express";
import { isAuthorized } from "../../middleware/authorization.js";
import { isAuthenticated } from "../../middleware/authentication.js";
import { isValid } from "../../middleware/validation_middleware.js";
import { catchErorr } from "../../utils/catchErorr.js";
import {
  inviteCode,
  myChildren,
  unLinkChild,
  bounsPoints,
} from "./parent_controller.js";
import { unlinkSchema, pointsSchema } from "./parent_validation.js";

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

router.delete(
  "/:childId",
  isAuthenticated,
  isValid(unlinkSchema),
  isAuthorized("parent"),
  catchErorr(unLinkChild),
);

router.post(
  "/:childId/adjust-points",
  isAuthenticated,
  isValid(pointsSchema),
  isAuthorized("parent"),
  catchErorr(bounsPoints),
);
export default router;
