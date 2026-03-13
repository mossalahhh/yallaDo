import { Router } from "express";
import { isAuthenticated } from "../../middleware/authentication.js";
import { isValid } from "../../middleware/validation_middleware.js";
import { fileUpload, validationImg } from "../../utils/multer.js";
import { catchErorr } from "../../utils/catchErorr.js";
import { profilePic, deleteProfilePic } from "./user_controller.js";

const router = Router();

router.patch(
  "/update-avatar",
  isAuthenticated,
  fileUpload(validationImg.images).single("avatar"),
  catchErorr(profilePic),
);

router.patch("/delete-avatar", isAuthenticated, catchErorr(deleteProfilePic));

export default router;
