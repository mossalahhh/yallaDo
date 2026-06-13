import { Router } from "express";
import { isAuthorized } from "../../middleware/authorization.js";
import { isAuthenticated } from "../../middleware/authentication.js";
import { isValid } from "../../middleware/validation_middleware.js";
import { catchErorr } from "../../utils/catchErorr.js";
import { linkAccountsSchema } from "./child_validation.js";
import {
  linkAccounts,
  myParents,
  myStats,
  myRank,
  myPoints,
  topThree,
} from "./child_controller.js";
const router = Router();

router.post(
  "/link-accounts",
  isAuthenticated,
  isAuthorized("child"),
  isValid(linkAccountsSchema),
  catchErorr(linkAccounts),
);
//get my parents
router.get(
  "/my-parents",
  isAuthenticated,
  isAuthorized("child"),
  catchErorr(myParents),
);
//get my stats
router.get(
  "/my-stats",
  isAuthenticated,
  isAuthorized("child"),
  catchErorr(myStats),
);
//get my rank
router.get(
  "/my-rank",
  isAuthenticated,
  isAuthorized("child"),
  catchErorr(myRank),
);
router.get(
  "/my-points",
  isAuthenticated,
  isAuthorized("child"),
  catchErorr(myPoints),
);
router.get(
  "/top-children",
  isAuthenticated,
  isAuthorized("child"),
  catchErorr(topThree),
);
export default router;
