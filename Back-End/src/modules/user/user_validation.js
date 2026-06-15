import joi from "joi";

export const updateProfileSchema = joi
  .object({
    name: joi.string(),
    userName: Joi.string(),
  })
  .options({ presence: "required" });

export const changeEmailScehma = joi
  .object({
    newEmail: joi.string().email(),
    password: joi.string(),
  })
  .options({ presence: "required" });

export const cnfirmEmailScehma = joi
  .object({
    code: joi.string(),
  })
  .options({ presence: "required" });

export const updatePasswordScehma = joi
  .object({
    oldPassword: joi.string(),
    newPassword: joi.string(),
    confirmPassword: joi.string().valid(joi.ref("newPassword")),
  })
  .options({ presence: "required" });
