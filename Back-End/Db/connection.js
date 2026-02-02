import mongoose from "mongoose";

export const connectDB = async () => {
  return await mongoose
    .connect(process.env.CONNECTION_STRING)
    .then(() => {
      console.log("DB Connected");
    })
    .catch((error) => {
      console.log(error);
    });
};
