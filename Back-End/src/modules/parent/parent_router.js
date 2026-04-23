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
  detailsChild,
  childHistory,
  allHistory,
} from "./parent_controller.js";
import {
  childIdSchema,
  pointsSchema,
  childHistorySchema,
  historySchema,
} from "./parent_validation.js";

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
  isValid(childIdSchema),
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

router.get(
  "/:childId/details",
  isAuthenticated,
  isValid(childIdSchema),
  isAuthorized("parent"),
  catchErorr(detailsChild),
);

router.get(
  "/:childId/history",
  isAuthenticated,
  isValid(childHistorySchema),
  isAuthorized("parent"),
  catchErorr(childHistory),
);

router.get(
  "/children-history",
  isAuthenticated,
  isValid(historySchema),
  isAuthorized("parent"),
  catchErorr(allHistory),
);
export default router;
