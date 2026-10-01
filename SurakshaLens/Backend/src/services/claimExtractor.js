const CLAIM_RULES = [
  {
    type: "guaranteed_return",
    label: "Guaranteed / unrealistic return claim",
    description:
      "The message promises fixed or extremely high returns — a classic investment fraud signal.",
    keywords: ["guaranteed return", "guaranteed 5x", "guaranteed 10x", "no loss", "risk free", "assured profit", "double your money"]
  },
  {
    type: "lottery_prize",
    label: "Lottery / prize scam",
    description:
      "The message claims you won a lottery or prize you never entered — usually asked to pay a fee to claim it.",
    keywords: ["lottery", "you have won", "won a prize", "lucky draw", "jackpot", "congratulations you"]
  },
  {
    type: "bank_kyc",
    label: "Bank KYC / OTP phishing",
    description:
      "The message pressures you to update KYC or share OTP/password — banks never ask for these over chat.",
    keywords: ["kyc update", "kyc expire", "share otp", "send otp", "password", "account blocked", "account suspend", "verify your account"]
  },
  {
    type: "courier_parcel",
    label: "Fake courier / parcel scam",
    description:
      "The message claims a parcel is stuck and asks for a fee or personal details.",
    keywords: ["courier", "parcel", "package held", "customs fee", "delivery failed"]
  },
  {
    type: "job_offer",
    label: "Fake job offer",
    description:
      "The message offers easy part-time work with upfront payment — a common task-scam pattern.",
    keywords: ["work from home", "part time job", "easy money", "daily payment", "hiring now", "registration fee"]
  },
  {
    type: "loan_offer",
    label: "Fake loan offer",
    description:
      "The message promises instant loans with no documents — often a data-theft or advance-fee scam.",
    keywords: ["instant loan", "personal loan", "no documents", "loan approved", "pre-approved loan"]
  },
  {
    type: "crypto_investment",
    label: "Crypto / trading scam",
    description:
      "The message promotes crypto or trading profits through a group or app — verify the platform's registration.",
    keywords: ["crypto", "bitcoin", "trading", "forex", "binary option", "investment app"]
  },
  {
    type: "government_scheme",
    label: "Fake government scheme",
    description:
      "The message claims government benefits or subsidies requiring an upfront payment.",
    keywords: ["government scheme", "subsidy", "pm kisan", "free laptop", "govt yojana", "relief fund"]
  },
  {
    type: "refund",
    label: "Fake refund / cashback",
    description:
      "The message promises a refund or cashback in exchange for clicking a link or sharing details.",
    keywords: ["refund", "cashback", "processing fee", "tax refund"]
  },
  {
    type: "romance_lottery",
    label: "Emergency / emotional pressure",
    description:
      "The message uses urgency or emotional pressure to make you act quickly.",
    keywords: ["urgent", "immediately", "act now", "limited time", "last chance", "emergency", "help me"]
  }
];

function extractClaims(message) {
  const lower = message.toLowerCase();

  return CLAIM_RULES.filter((rule) =>
    rule.keywords.some((keyword) => lower.includes(keyword))
  ).map((rule) => ({
    type: rule.type,
    label: rule.label,
    description: rule.description
  }));
}

module.exports = {
  extractClaims
};
