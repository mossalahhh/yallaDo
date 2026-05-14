import morgan from "morgan";
import authRouter from "./modules/auth/auth_router.js";
import userRouter from "./modules/user/user_router.js";
import parentRouter from "./modules/parent/parent_router.js";
import childRouter from "./modules/child/child_router.js";
import taskRouter from "./modules/task/task_router.js";
import rewardRouter from "./modules/reward/reward_router.js";
import notificationsRouter from "./modules/notifications/notifications_router.js";

export const appRouter = (app, express) => {
  if (process.env.NODE_ENV === "dev") {
    app.use(morgan("common"));
  }
  //parse express data
  app.use(express.json());

  app.use("/auth", authRouter);
  app.use("/user", userRouter);
  app.use("/parent", parentRouter);
  app.use("/child", childRouter);
  app.use("/task", taskRouter);
  app.use("/reward", rewardRouter);
  app.use("/notifications", notificationsRouter);

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
