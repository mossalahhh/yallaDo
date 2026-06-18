import axios from "axios";

export const generateReply = async (childId, prompt) => {
  const response = await axios.post(process.env.CHAT_API_UR, {
    childId,
    prompt,
  });

  return response.data.reply;
};
