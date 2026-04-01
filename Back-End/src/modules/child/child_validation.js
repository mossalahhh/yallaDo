import Joi from "joi";

export const linkAccountsSchema = Joi.object({
  code: Joi.string().alphanum(),
}).options({ presence: "required" });
