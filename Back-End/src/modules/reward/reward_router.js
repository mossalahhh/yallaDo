import { Router } from "express";
import { isAuthorized } from "../../middleware/authorization.js";
import { isAuthenticated } from "../../middleware/authentication.js";
import { isValid } from "../../middleware/validation_middleware.js";
import { fileUpload, validationImg } from "../../utils/multer.js";
import { catchErorr } from "../../utils/catchErorr.js";
import { addRewardSchema } from "./reward_validation.js";
import { addReward } from "./reward_controller.js";
const router = Router();

router.post(
  "/add",
  isAuthenticated,
  isAuthorized("parent"),
  fileUpload(validationImg.images).single("rewardImg"),
  isValid(addRewardSchema),
  catchErorr(addReward),
);

export default router;
