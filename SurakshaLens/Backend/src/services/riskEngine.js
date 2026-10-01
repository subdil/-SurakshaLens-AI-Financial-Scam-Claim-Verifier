const rules = [
  {
    id: "guaranteed_return",
    patterns: [
      /guarantee\w*\s+(return|profit)/i,
      /assur\w*\s+(return|profit)/i,
      /\b\d+\s*x\s*(return|profit)?\b/i,
      /\b\d+\s*times?\s*(return|profit)?\b/i,
      /double\s+(your\s+)?money/i,
      /no\s+loss/i,
      /100\s*%\s*(profit|return)/i
    ],
    title: "Guaranteed or unrealistic returns",
    description:
      "The message promises unusually high, guaranteed, or unrealistic financial returns.",
    severity: "high"
  },

  {
    id: "urgency",
    patterns: [
      /act\s*now/i,
      /limited\s*time/i,
      /limited\s*seat/i,
      /today\s*only/i,
      /\bhurry\b/i,
      /last\s*chance/i,
      /immediately/i,
      /don'?t\s*miss/i
    ],
    title: "Urgency or pressure",
    description:
      "The message pressures you to make a financial decision quickly.",
    severity: "medium"
  },

  {
    id: "social_media",
    patterns: [
      /telegram/i,
      /tele\s*gram/i,
      /whatsapp/i,
      /whats\s*app/i,
      /vip\s*(group|channel)/i,
      /join\s+(our|the)\s+group/i
    ],
    title: "Social-media solicitation",
    description:
      "The message directs you to a social-media group or channel for financial activity.",
    severity: "medium"
  },

  {
    id: "payment_request",
    patterns: [
      /\bpay\b/i,
      /\bpayment\b/i,
      /\bdeposit\b/i,
      /send\s+money/i,
      /transfer\s+money/i,
      /activation\s+fee/i,
      /registration\s+fee/i,
      /processing\s+fee/i,
      /pay\s*(₹|rs\.?|inr)/i
    ],
    title: "Payment request",
    description:
      "The message asks you to make a payment, deposit, or transfer money.",
    severity: "high"
  },

  {
    id: "authority_claim",
    patterns: [
      /sebi\s*(certified|approved|registered|authorized)/i,
      /government\s*approved/i,
      /official\s+sebi/i,
      /authorized\s+by\s+sebi/i,
      /registered\s+by\s+sebi/i
    ],
    title: "Authority or regulatory claim",
    description:
      "The message makes a regulatory or authority claim that should be independently verified.",
    severity: "high"
  },

  {
    id: "credential_request",
    patterns: [
      /share\s+(your\s+)?otp/i,
      /send\s+(your\s+)?otp/i,
      /share\s+(your\s+)?password/i,
      /send\s+(your\s+)?password/i,
      /share\s+(your\s+)?pin/i,
      /send\s+(your\s+)?pin/i,
      /login\s+details/i
    ],
    title: "Credential or OTP request",
    description:
      "The message asks for sensitive login or authentication information.",
    severity: "high"
  }
];

function normalizeText(text) {
  return text
    .toLowerCase()
    .replace(/[|]/g, "i")
    .replace(/\s+/g, " ")
    .trim();
}

function analyzeMessage(message) {
  const normalizedMessage = normalizeText(message);

  const signals = [];

  for (const rule of rules) {
    const matchedPatterns = rule.patterns.filter((pattern) =>
      pattern.test(normalizedMessage)
    );

    if (matchedPatterns.length > 0) {
      signals.push({
        id: rule.id,
        title: rule.title,
        description: rule.description,
        severity: rule.severity
      });
    }
  }

  const highSignals = signals.filter(
    (signal) => signal.severity === "high"
  ).length;

  const mediumSignals = signals.filter(
    (signal) => signal.severity === "medium"
  ).length;

  let riskLevel = "LOW";

  if (highSignals >= 2 || signals.length >= 4) {
    riskLevel = "HIGH CONCERN";
  } else if (highSignals >= 1 || mediumSignals >= 2) {
    riskLevel = "MEDIUM CONCERN";
  }

  return {
    riskLevel,
    signalCount: signals.length,
    signals,
    explanation: buildExplanation(signals),
    recommendedActions: [
      "Pause before sending money.",
      "Verify the claim using an independent official source.",
      "Do not share OTPs, passwords, PINs or login credentials.",
      "Avoid making financial decisions based only on this message."
    ]
  };
}

function buildExplanation(signals) {
  if (signals.length === 0) {
    return "No obvious warning patterns were detected. This does not prove that the message is safe, so verify important financial claims independently.";
  }

  return `This message contains ${signals.length} warning sign${
    signals.length === 1 ? "" : "s"
  } that deserve closer verification.`;
}

module.exports = {
  analyzeMessage
};