import { Types } from "mongoose";

export const isValidObject = (value, helper) => {
  if (Types.ObjectId.isValid(value)) {
    return true;
  } else {
    return helper.message("Invalid-ObjID");
  }
};

export const isValid = (schema) => {
  return (req, res, next) => {
    const copyReq = { ...req.body, ...req.query, ...req.params };

    const validationSchema = schema.validate(copyReq, { abortEearly: false });

    if (validationSchema.error) {
      const arrayErrors = validationSchema.error.details.map(
        (error) => error.message,
      );

      return next(new Error(arrayErrors, { cause: 400 }));
    }
    return next();
  };
};
