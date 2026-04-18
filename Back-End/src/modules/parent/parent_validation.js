import joi from "joi";
import { isValidObject } from "../../middleware/validation_middleware.js";

export const childIdSchema = joi
  .object({
    childId: joi.string().custom(isValidObject),
  })
  .options({ presence: "required" });

export const pointsSchema = joi
  .object({
    points: joi.number(),
    type: joi.string().valid("add", "remove"),
    reason: joi.string(),
    childId: joi.string().custom(isValidObject),
  })
  .options({ presence: "required" });
