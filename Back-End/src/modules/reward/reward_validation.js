import Joi from "joi";

import { isValidObject } from "../../middleware/validation_middleware.js";

export const addRewardSchema = Joi.object({
  name: Joi.string().required(),
  description: Joi.string().optional(),
  points: Joi.number().min(1).required(),
  quantity: Joi.number().optional(),
});

export const updateRewardSchema = Joi.object({
  rewardId: Joi.string().custom(isValidObject).required(),
  name: Joi.string().optional(),
  description: Joi.string().optional(),
  points: Joi.number().min(1).optional(),
  quantity: Joi.number().optional(),
});

export const idRewardSchema = Joi.object({
  rewardId: Joi.string().custom(isValidObject).required(),
});

export const getRewardSchema = Joi.object({
  page: Joi.number().optional(),
  fields: Joi.string().optional(),
});
