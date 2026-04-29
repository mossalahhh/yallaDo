import Joi, { number } from "joi";
import { isValidObject } from "../../middleware/validation_middleware.js";
import { type } from "node:os";

export const createTaskSchema = Joi.object({
  title: Joi.string().min(3).max(100).required(),
  description: Joi.string().max(500).optional(),
  createdBy: Joi.string().custom(isValidObject).required(),
  type: Joi.string().valid("personal", "open").required(),
  assignedTo: Joi.when("type", {
    is: "personal",
    then: Joi.string().required(),
    otherwise: Joi.forbidden(),
  }),
  points: Joi.number().required(),
  priority: Joi.string().valid("low", "medium", "high").default("medium"),
  category: Joi.string().required(),
  submissionType: Joi.string().valid("text", "image", "both").default("text"),
  minImages: Joi.number()
    .min(0)
    .when("submissionType", {
      is: "text",
      then: Joi.valid(0),
      otherwise: Joi.optional(),
    }),
});
