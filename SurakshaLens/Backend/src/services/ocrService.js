const { createWorker } = require("tesseract.js");

async function extractTextFromImage(imagePath) {
  const worker = await createWorker("eng");

  try {
    const result = await worker.recognize(imagePath);

    return result.data.text;
  } finally {
    await worker.terminate();
  }
}

module.exports = {
  extractTextFromImage
};