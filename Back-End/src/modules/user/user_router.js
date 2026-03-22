import { Router } from "express";
import { isAuthenticated } from "../../middleware/authentication.js";
import { isValid } from "../../middleware/validation_middleware.js";
import { fileUpload, validationImg } from "../../utils/multer.js";
import { updateProfileSchema } from "./user_validation.js";
import { catchErorr } from "../../utils/catchErorr.js";
import {
  profilePic,
  deleteProfilePic,
  myProfile,
  updateProfile,
} from "./user_controller.js";

const router = Router();

router.put(
  "/update-avatar",
  isAuthenticated,
  fileUpload(validationImg.images).single("avatar"),
  catchErorr(profilePic),
);

router.delete("/delete-avatar", isAuthenticated, catchErorr(deleteProfilePic));

router.get("/me", isAuthenticated, catchErorr(myProfile));

router.patch(
  "/profile",
  isAuthenticated,
  isValid(updateProfileSchema),
  catchErorr(updateProfile),
);
export default router;
