import express from "express";
import { appRouter } from "./src/appRouter.js";
import { connectDB } from "./Db/connection.js";
import dotenv from "dotenv";

dotenv.config();
const app = express();
const port = process.env.PORT;
appRouter(app, express);
connectDB();
app.listen(port, () => console.log(`Server running on port ${port}!`));
