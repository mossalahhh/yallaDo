import { Router } from "express";
import { isAuthorized } from "../../middleware/authorization.js";
import { isAuthenticated } from "../../middleware/authentication.js";
import { isValid } from "../../middleware/validation_middleware.js";
import { catchErorr } from "../../utils/catchErorr.js";
import { linkAccountsSchema } from "./child_validation.js";
import { linkAccounts } from "./child_controller.js";
const router = Router();

router.post(
  "/link-accounts",
  isAuthenticated,
  isAuthorized("child"),
  isValid(linkAccountsSchema),
  catchErorr(linkAccounts),
);

//get my status
//get my rank
export default router;
