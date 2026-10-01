const evidenceRules = {
  guaranteed_return: {
    title: "Verify the return claim",
    explanation:
      "Guaranteed or unusually high returns should not be accepted without independent verification.",
    sourceName: "SEBI Investor",
    sourceUrl: "https://investor.sebi.gov.in/"
  },

  payment_request: {
    title: "Verify before sending money",
    explanation:
      "Do not send money based only on a message. Verify the organisation and payment request independently.",
    sourceName: "SEBI Recognised Intermediaries",
    sourceUrl:
      "https://www.sebi.gov.in/sebiweb/other/OtherAction.do?doRecognised=yes"
  },

  authority_claim: {
    title: "Verify the regulatory claim",
    explanation:
      "A message claiming SEBI approval or registration should be checked against SEBI's official records.",
    sourceName: "SEBI Recognised Intermediaries",
    sourceUrl:
      "https://www.sebi.gov.in/sebiweb/other/OtherAction.do?doRecognised=yes"
  },

  social_media: {
    title: "Verify the person or channel",
    explanation:
      "Social-media messages are not proof that an investment service or person is authorised.",
    sourceName: "National Cyber Crime Portal",
    sourceUrl: "https://www.cybercrime.gov.in/"
  },

  credential_request: {
    title: "Protect your credentials",
    explanation:
      "Never share OTPs, passwords, PINs or login credentials in response to an unsolicited message.",
    sourceName: "National Cyber Crime Portal",
    sourceUrl: "https://www.cybercrime.gov.in/"
  },

  urgency: {
    title: "Pause and verify",
    explanation:
      "Urgency can pressure people into making decisions before they have independently checked the claim.",
    sourceName: "SEBI Investor",
    sourceUrl: "https://investor.sebi.gov.in/"
  }
};

function getEvidence(signals) {
  return signals
    .map((signal) => evidenceRules[signal.id])
    .filter(Boolean);
}

module.exports = {
  getEvidence
};