import crypto from "crypto";
import fs from "fs";

export const generateImageHash = (filePath) => {
  const fileBuffer = fs.readFileSync(filePath);

  return crypto.createHash("sha256").update(fileBuffer).digest("hex");
};
