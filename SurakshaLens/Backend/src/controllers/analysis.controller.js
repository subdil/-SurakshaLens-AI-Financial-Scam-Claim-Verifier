const { analyzeMessage } = require("../services/riskEngine");
const { getEvidence } = require("../services/evidenceService");
const { extractIdentifiers } = require("../services/identifierService");
const { verifyIdentifiers } = require("../services/identifierVerificationService");
const { extractClaims } = require("../services/claimExtractor");

function analyzeText(req, res) {
  try {
    const { message } = req.body;

    if (!message || typeof message !== "string") {
      return res.status(400).json({
        success: false,
        message: "Please provide a message to analyze."
      });
    }

    if (message.trim().length < 3) {
      return res.status(400).json({
        success: false,
        message: "Message is too short to analyze."
      });
    }

    const result = analyzeMessage(message.trim());

    const evidence = getEvidence(result.signals);

    const identifiers = verifyIdentifiers(
      extractIdentifiers(message.trim())
    );

    const claims = extractClaims(message.trim());

    return res.json({
      success: true,
      data: {
        input: message.trim(),
        ...result,
        evidence,
        identifiers,
        claims
      }
    });
  } catch (error) {
    console.error("Analysis error:", error);

    return res.status(500).json({
      success: false,
      message: "Something went wrong while analyzing the message."
    });
  }
}

module.exports = {
  analyzeText
};