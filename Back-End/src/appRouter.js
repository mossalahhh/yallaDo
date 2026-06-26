import morgan from "morgan";
import authRouter from "./modules/auth/auth_router.js";
import userRouter from "./modules/user/user_router.js";
import parentRouter from "./modules/parent/parent_router.js";
import childRouter from "./modules/child/child_router.js";
import taskRouter from "./modules/task/task_router.js";
import rewardRouter from "./modules/reward/reward_router.js";
import notificationsRouter from "./modules/notifications/notifications_router.js";
import aiRouter from "./modules/ai/ai_router.js";
import cors from "cors";

export const appRouter = (app, express) => {
  if (process.env.NODE_ENV === "dev") {
    app.use(morgan("common"));
  }

  app.use(
    cors({
      origin: true,
      methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
      allowedHeaders: ["Content-Type", "Authorization"],
      credentials: false,
    }),
  );
  //undefined for postman requests
  //null for fs
  // const whiteList = [
  //   undefined,
  //   null,
  //   "http://127.0.0.1:5500",
  //   "http://localhost:61943",
  //   "http://localhost:3000",
  //   "http://localhost:50780",
  //   "http://localhost:59602",
  // ];
  // app.use((req, res, next) => {
  //   //handle requests from front-end
  //   if (!whiteList.includes(req.header("origin"))) {
  //     return next(new Error("Blocked By CORS"));
  //   }
  //   res.setHeader("Access-Control-Allow-Origin", "*");
  //   res.setHeader("Access-Control-Allow-Methods", "*");
  //   res.setHeader("Access-Control-Allow-Headers", "*");
  //   //to allow request for localHost
  //   res.setHeader("Access-Control-Allow-Private-Network", true);
  //   return next();
  // });

  //parse express data
  app.use(express.json());

  app.use("/auth", authRouter);
  app.use("/user", userRouter);
  app.use("/parent", parentRouter);
  app.use("/child", childRouter);
  app.use("/task", taskRouter);
  app.use("/reward", rewardRouter);
  app.use("/notifications", notificationsRouter);
  app.use("/ai", aiRouter);

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
