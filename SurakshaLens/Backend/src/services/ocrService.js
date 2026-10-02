const { Jimp, JimpMime } = require("jimp");
const { createWorker } = require("tesseract.js");

let workerPromise = null;

async function getWorker() {
  if (!workerPromise) {
    const path = require("path");
    workerPromise = createWorker("eng", 1, {
      langPath: path.join(__dirname, "..", ".."),
      workerPath: path.join(
        __dirname, "..", "..", "node_modules", "tesseract.js", "dist", "worker.min.js"
      ),
      corePath: require.resolve("tesseract.js-core/tesseract-core.wasm.js"),
      gzip: false
    });
    workerPromise.catch(() => {
      workerPromise = null;
    });
  }
  return workerPromise;
}

async function extractTextFromImage(imagePath) {
  // resize big screenshots to max 1400px so OCR is fast
  const fs = require("fs");
  const image = await Jimp.read(fs.readFileSync(imagePath));
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
