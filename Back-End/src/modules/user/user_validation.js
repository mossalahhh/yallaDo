import joi from "joi";

export const updateProfileSchema = joi
  .object({
    name: joi.string(),
  })
  .options({ presence: "required" });

export const changeEmailSechma = joi
  .object({
    newEmail: joi.string().email(),
    password: joi.string(),
  })
  .options({ presence: "required" });
