import jwt from "jsonwebtoken";
import User from "../../Db/models/user_model.js";
import Token from "../../Db/models/token_model.js";
import { catchErorr } from "../utils/catchErorr.js";

export const isAuthenticated = catchErorr(async (req, res, next) => {
  let token = req.headers["authorization"];

  if (!token || !token.startsWith(process.env.BEARER_TOKEN || "Bearer")) {
    return next(new Error("Valid token is required!", { cause: 401 }));
  }

  token = token.split(process.env.BEARER_TOKEN)[1].trim();

  const decoded = jwt.verify(token, process.env.SECRET_KEY);

  if (!decoded) {
    return next(new Error("Invalid token ", { cause: 401 }));
  }

  const dbToken = await Token.findOne({ token, isValid: true });

  if (!dbToken) {
    return next(new Error("Token expired or logged out!", { cause: 401 }));
  }

  const user = await User.findOne({ email: decoded.email });

  if (!user) {
    return next(new Error("User no longer exists!", { cause: 401 }));
  }

  req.user = user;

  return next();
});
