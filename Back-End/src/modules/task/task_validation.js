import Joi from "joi";
import { isValidObject } from "../../middleware/validation_middleware.js";

export const createTaskSchema = Joi.object({
  title: Joi.string().min(3).max(100).required(),
  description: Joi.string().max(500).optional(),
  type: Joi.string().valid("personal", "open").required(),
  assignedTo: Joi.when("type", {
    is: "personal",
    then: Joi.string().required(),
    otherwise: Joi.forbidden(),
  }),
  points: Joi.number().min(1).required(),
  priority: Joi.string().valid("low", "medium", "high").default("medium"),
  category: Joi.string().required(),
  submissionType: Joi.string()
    .valid("text", "image", "both")
    .default("text")
    .trim(),
  minImages: Joi.number()
    .min(0)
    .default(0)
    .when("submissionType", {
      is: "text",
      then: Joi.valid(0),
      otherwise: Joi.optional(),
    }),
  dueDate: Joi.date().iso().optional(),
});

export const getTasksSchema = Joi.object({
  page: Joi.number().optional(),
  fields: Joi.string().optional(),

  priority: Joi.string().optional(),
  points: Joi.number().optional(),
  status: Joi.string().optional(),
  category: Joi.string().optional(),
  type: Joi.string().optional(),
});

export const checkIdSchema = Joi.object({
  taskId: Joi.string().custom(isValidObject).required(),
});

export const submitSchema = Joi.object({
  description: Joi.string().optional(),
  taskId: Joi.string().custom(isValidObject).required(),
});
