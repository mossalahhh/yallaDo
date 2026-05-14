import Joi from "joi";

import { isValidObject } from "../../middleware/validation_middleware.js";

export const getNotififcationSchema = Joi.object({
  page: Joi.number().optional(),
  fields: Joi.string().optional(),
  type: Joi.string().optional(),
  isRead: Joi.boolean().optional(),
});
