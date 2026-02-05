import { catchErorr } from "../utils/catchErorr.js";

export const isAuthorized = (role) => {
  return catchErorr(async (req, res, next) => {
    if (role !== req.user.role) {
      return next(new Error("You're Not authorized", { cause: 401 }));
    }
    return next();
  });
};
