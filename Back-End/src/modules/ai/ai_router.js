import { Router } from "express";
import { catchErorr } from "../../utils/catchErorr.js";
import { isValid } from "../../middleware/validation_middleware.js";
import { isAuthenticated } from "../../middleware/authentication.js";
import { isAuthorized } from "../../middleware/authorization.js";
import { chatWithAi } from "./ai_controller.js";
import { aiChatSchema } from "./ai_validation.js";
const router = Router();

router.post(
  "/chat",
  isAuthenticated,
  isAuthorized("child"),
  isValid(aiChatSchema),
  catchErorr(chatWithAi),
);

export default router;
