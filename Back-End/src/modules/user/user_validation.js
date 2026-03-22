import joi from "joi";

export const updateProfileSchema = joi
  .object({
    name: joi.string(),
  })
  .options({ presence: "required" });
