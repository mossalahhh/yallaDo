import generateReply from "./ai_services.js";
import Child from "../../../Db/models/child_model.js";

export const chatWithAi = async (req, res, next) => {
  const child = await Child.findOne({ userId: req.user._id });
  const childId = child._id;

  const { promot } = req.body;

  const reply = await generateReply(childId, promot);

  return res.status(200).json({ success: true, reply });
};
