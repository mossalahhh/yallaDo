import axios from "axios";

export const generateReply = async (childId, prompt) => {
  const response = await axios.post(process.env.CHAT_API_URL, {
    childId,
    prompt,
  });

  return response.data.reply;
};
