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

export const childHistorySchema = joi.object({
  childId: joi.string().custom(isValidObject).required(),
  page: joi.number().integer().min(1).optional(),
  fields: joi.string().optional(),
  //...rest paremters
  type: joi.string().valid("add", "remove").optional(),
  source: joi.string().valid("manual", "task", "reward").optional(),
});

export const historySchema = joi.object({
  page: joi.number().integer().min(1).optional(),
  fields: joi.string().optional(),
  //...rest paremters
  type: joi.string().valid("add", "remove").optional(),
  source: joi.string().valid("manual", "task", "reward").optional(),
});
