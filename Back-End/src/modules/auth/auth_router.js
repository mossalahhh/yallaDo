import { Router } from "express";
import { catchErorr } from "../../utils/catchErorr.js";
import { isValid } from "../../middleware/validation_middleware.js";
import {
  register,
  confirmEmail,
  login,
  forgetPassword,
  resetPassword,
  resendCode,
  logout,
} from "./auth_controller.js";
import {
  registerSchema,
  confirmEmailSchema,
  loginSchema,
  forgetPasswordSchema,
  resetPasswordSchema,
  resendCodeSchema,
} from "./auth_validation.js";
import { isAuthenticated } from "../../middleware/authentication.js";

const router = Router();

router.post("/register", isValid(registerSchema), catchErorr(register));

router.post(
  "/verify-email",
  isValid(confirmEmailSchema),
  catchErorr(confirmEmail),
);

router.post("/login", isValid(loginSchema), catchErorr(login));

router.post(
  "/forget-password",
  isValid(forgetPasswordSchema),
  catchErorr(forgetPassword),
);

router.post(
  "/reset-password",
  isValid(resetPasswordSchema),
  catchErorr(resetPassword),
);

router.post("/resend-code", isValid(resendCodeSchema), catchErorr(resendCode));

router.delete("/logout", isAuthenticated, catchErorr(logout));

export default router;
