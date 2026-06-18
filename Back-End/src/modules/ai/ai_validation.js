import Joi from "joi";

export const aiChatSchema = Joi.object({
  prompt: Joi.string().required(),
});
