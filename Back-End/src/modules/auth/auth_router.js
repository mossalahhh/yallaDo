import { Router } from "express";
import { catchErorr } from "../../utils/catchErorr.js";
import { isValid } from "../../middleware/validation_middleware.js";
import {
  register,
  confirmEmail,
  login,
  forgetPassword,
  resetPassword,
} from "./auth_controller.js";
import {
  registerSchema,
  confirmEmailSchema,
  loginSchema,
  forgetPasswordSchema,
  resetPasswordSchema,
} from "./auth_validation.js";

const router = Router();

router.post("/signup", isValid(registerSchema), catchErorr(register));

router.patch(
  "/confirm-email",
  isValid(confirmEmailSchema),
  catchErorr(confirmEmail),
);

router.post("/login", isValid(loginSchema), catchErorr(login));

router.patch(
  "/forget-password",
  isValid(forgetPasswordSchema),
  catchErorr(forgetPassword),
);

router.patch(
  "/reset-password",
  isValid(resetPasswordSchema),
  catchErorr(resetPassword),
);
export default router;
