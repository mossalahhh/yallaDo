import { Router } from "express";
import { isAuthorized } from "../../middleware/authorization.js";
import { isAuthenticated } from "../../middleware/authentication.js";
import { isValid } from "../../middleware/validation_middleware.js";
import { fileUpload, validationImg } from "../../utils/multer.js";
import { catchErorr } from "../../utils/catchErorr.js";
import { addReward, updateReward } from "./reward_controller.js";
import { addRewardSchema, updateRewardSchema } from "./reward_validation.js";
const router = Router();

router.post(
  "/add",
  isAuthenticated,
  isAuthorized("parent"),
  fileUpload(validationImg.images).single("rewardImg"),
  isValid(addRewardSchema),
  catchErorr(addReward),
);

router.patch(
  "/:rewardId/update",
  isAuthenticated,
  isAuthorized("parent"),
  fileUpload(validationImg.images).single("rewardImg"),
  isValid(updateRewardSchema),
  catchErorr(updateReward),
);

export default router;
