//joi for validation inputs
import joi from "joi";

export const registerSchema = joi
  .object({
    name: joi.string().min(3).max(15),
    userName: joi.string().alphanum().min(3).max(15),
    email: joi.string().email(),
    password: joi.string(),
    confirmPassword: joi.string().valid(joi.ref("password")),
    gender: joi.string().valid("male", "female"),
    role: joi.string().valid("parent", "chile"),
  })
  .options({ presence: "required" });

export const confirmEmailSchema = joi
  .object({
    activationCode: joi.string(),
  })
  .options({ presence: "required" });

export const loginSchema = joi
  .object({
    email: joi.string().email(),
    password: joi.string(),
  })
  .options({ presence: "required" });

export const forgetPasswordSchema = joi
  .object({
    email: joi.string().email(),
  })
  .options({ presence: "required" });

export const resetPasswordSchema = joi
  .object({
    resetCode: joi.string(),
    newPassword: joi.string(),
  })
  .options({ presence: "required" });
