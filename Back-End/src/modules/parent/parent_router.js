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
  dashborad,
  analytics,
  pointsOverTime,
  progressTasks,
  // topThree,
} from "./parent_controller.js";
import {
  childIdSchema,
  pointsSchema,
  childHistorySchema,
  historySchema,
  pointAnalyticsSchema,
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
  "/:childId/unlink",
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
router.get(
  "/dashboard",
  isAuthenticated,
  isAuthorized("parent"),
  catchErorr(dashborad),
);
router.get(
  "/analytics",
  isAuthenticated,
  isAuthorized("parent"),
  catchErorr(analytics),
);
router.get(
  "/analytics-points",
  isAuthenticated,
  isValid(pointAnalyticsSchema),
  isAuthorized("parent"),
  catchErorr(pointsOverTime),
);
router.get(
  "/progress-completion",
  isAuthenticated,
  isAuthorized("parent"),
  catchErorr(progressTasks),
);
// router.get(
//   "/top-children",
//   isAuthenticated,
//   isAuthorized("parent"),
//   catchErorr(topThree),
// );
export default router;
