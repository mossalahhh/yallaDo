import morgan from "morgan";
import authRouer from "./modules/auth/auth_router.js";
import userRouer from "./modules/user/user_router.js";
import parentRouer from "./modules/parent/parent_router.js";
import childRouer from "./modules/child/child_router.js";
import taskRouer from "./modules/task/task_router.js";

export const appRouter = (app, express) => {
  if (process.env.NODE_ENV === "dev") {
    app.use(morgan("common"));
  }
  //parse express data
  app.use(express.json());

  app.use("/auth", authRouer);
  app.use("/user", userRouer);
  app.use("/parent", parentRouer);
  app.use("/child", childRouer);
  app.use("/task", taskRouer);

  //handle page not found error
  app.use((req, res, next) => {
    return next(new Error("Page Not Found", { cause: 404 }));
  });

  //Global Error Handling
  app.use((error, req, res, next) => {
    const statusCode = error.cause || 500;
    if (process.env.NODE_ENV === "dev") {
      return res.status(statusCode).json({
        success: false,
        message: error.message,
        stack: error.stack,
      });
    } else {
      return res.status(statusCode).json({
        success: false,
        message: error.message,
      });
    }
  });
};
