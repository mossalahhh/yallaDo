import Joi from "joi";

import { isValidObject } from "../../middleware/validation_middleware.js";

export const addRewardSchema = Joi.object({
  name: Joi.string().required(),
  description: Joi.string().optional(),
  points: Joi.number().min(1).required(),
  quantity: Joi.number().optional(),
});
