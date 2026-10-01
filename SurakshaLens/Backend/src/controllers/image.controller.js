const fs = require("fs");

const {
  extractTextFromImage
} = require("../services/ocrService");

const {
  analyzeMessage
} = require("../services/riskEngine");

const {
  getEvidence
} = require("../services/evidenceService");

const {
  extractIdentifiers
} = require("../services/identifierService");

const {
  verifyIdentifiers
} = require("../services/identifierVerificationService");

const {
  extractClaims
} = require("../services/claimExtractor");

async function analyzeImage(req, res) {
  let imagePath = null;

  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        message: "Please upload an image."
      });
    }

    imagePath = req.file.path;

    console.log("OCR started...");

    const extractedText =
      await extractTextFromImage(imagePath);

    console.log("OCR completed.");

    if (!extractedText.trim()) {
      return res.status(400).json({
        success: false,
        message:
          "No readable text was found in the image."
      });
    }

    const analysis =
      analyzeMessage(extractedText);

    const evidence = getEvidence(analysis.signals);

    const identifiers = verifyIdentifiers(
      extractIdentifiers(extractedText)
    );

    const claims = extractClaims(extractedText);

    return res.json({
      success: true,
      data: {
        input: extractedText,
        source: "image",
        ...analysis,
        evidence,
        identifiers,
        claims
      }
    });
  } catch (error) {
    console.error(
      "Image analysis error:",
      error
    );

    return res.status(500).json({
      success: false,
      message:
        "Something went wrong while processing the image."
    });
  } finally {
    if (imagePath && fs.existsSync(imagePath)) {
      fs.unlinkSync(imagePath);
    }
  }
}

module.exports = {
  analyzeImage
};