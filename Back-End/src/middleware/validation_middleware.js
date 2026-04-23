import { Types } from "mongoose";

import Joi from "joi";

export const isValidObject = (value, helper) => {
  return Types.ObjectId.isValid(value)
    ? value
    : helper.message("Invalid-ObjID");
};

export const isValid = (schema) => {
  return (req, res, next) => {
    const copyReq = { ...req.body, ...req.query, ...req.params };

    const { error } = schema.validate(copyReq, {
      abortEarly: false,
    });

    if (error) {
      const arrayErrors = error.details.map((error) => error.message);

      return next(new Error(arrayErrors, { cause: 400 }));
    }
    return next();
  };
};
