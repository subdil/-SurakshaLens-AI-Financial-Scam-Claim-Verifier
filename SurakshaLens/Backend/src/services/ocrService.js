const { Jimp, JimpMime } = require("jimp");
const { createWorker } = require("tesseract.js");

let workerPromise = null;

async function getWorker() {
  if (!workerPromise) {
    workerPromise = createWorker("eng");
    workerPromise.catch(() => {
      workerPromise = null;
    });
  }
  return workerPromise;
}

async function extractTextFromImage(imagePath) {
  // resize big screenshots to max 1400px so OCR is fast
  const image = await Jimp.read(imagePath);
  if (image.bitmap.width > 1400 || image.bitmap.height > 1400) {
    image.scaleToFit({ w: 1400, h: 1400 });
  }
  const buffer = await image.getBuffer(JimpMime.png);

  const worker = await getWorker();
  const result = await worker.recognize(buffer);

  return result.data.text;
}

module.exports = {
  extractTextFromImage
};
