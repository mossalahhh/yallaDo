import { Router } from "express";
import { isAuthorized } from "../../middleware/authorization.js";
import { isAuthenticated } from "../../middleware/authentication.js";
import { isValid } from "../../middleware/validation_middleware.js";
import { fileUpload, validationImg } from "../../utils/multer.js";
import { catchErorr } from "../../utils/catchErorr.js";
import {
  addReward,
  updateReward,
  deleteReward,
  getRewards,
  getDeletedRewards,
} from "./reward_controller.js";

import {
  addRewardSchema,
  updateRewardSchema,
  idRewardSchema,
  getRewardSchema,
} from "./reward_validation.js";
const router = Router();

router.post(
  "/add",
  isAuthenticated,
  isAuthorized("parent"),
  fileUpload(validationImg.images).single("rewardImg"),
  isValid(addRewardSchema),
  catchErorr(addReward),
);

router.get(
  "/rewards",
  isAuthenticated,
  isValid(getRewardSchema),
  catchErorr(getRewards),
);

router.get(
  "/deleted",
  isAuthenticated,
  isAuthorized("parent"),
  isValid(getRewardSchema),
  catchErorr(getDeletedRewards),
);

router.patch(
  "/:rewardId/update",
  isAuthenticated,
  isAuthorized("parent"),
  fileUpload(validationImg.images).single("rewardImg"),
  isValid(updateRewardSchema),
  catchErorr(updateReward),
);
router.patch(
  "/:rewardId/delete",
  isAuthenticated,
  isAuthorized("parent"),
  isValid(idRewardSchema),
  catchErorr(deleteReward),
);

export default router;
