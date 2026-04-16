import joi from "joi";
import { isValidObject } from "../../middleware/validation_middleware.js";

export const unlinkSchema = joi
  .object({
    childId: joi.string().custom(isValidObject).required(),
  })
  .options({ presence: "required" });
