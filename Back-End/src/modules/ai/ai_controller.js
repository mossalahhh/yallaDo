import { generateReply } from "./ai_services.js";
import Child from "../../../Db/models/child_model.js";

export const chatWithAi = async (req, res, next) => {
  const child = await Child.findOne({ userId: req.user._id });

  if (!child) {
    return next(new Error("Child Profile Not Found", { cause: 404 }));
  }

  const childId = child._id;

  const { prompt } = req.body;

  const reply = await generateReply(childId, prompt);

  return res.status(200).json({ success: true, reply });
};
