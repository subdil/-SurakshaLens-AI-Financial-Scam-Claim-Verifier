function verifyIdentifiers(identifiers) {
  return identifiers.map((item) => {
    let verdict = "unverified";
    let verdictNote = "Could not confirm this with an official source.";

    const value = (item.value || "").toLowerCase();

    switch (item.type) {
      case "telegram":
        verdict = "suspicious";
        verdictNote =
          "Telegram channels are not authorized by SEBI. Do not trust investment advice from them.";
        break;

      case "whatsapp":
        verdict = "suspicious";
        verdictNote =
          "WhatsApp groups are not regulated investment channels. Treat offers with caution.";
        break;

      case "apk":
        verdict = "suspicious";
        verdictNote =
          "APKs from unknown sources can install malware. Install only from official app stores.";
        break;

      case "url": {
        const isIp = /\d{1,3}(\.\d{1,3}){3}/.test(value);
        const isShortener =
          /(bit\.ly|tinyurl|t\.co|goo\.gl|cutt\.ly|rebrand\.ly)/.test(value);
        const isHttpOnly = value.startsWith("http://");

        if (isIp) {
          verdict = "suspicious";
          verdictNote =
            "Link uses a raw IP address instead of a domain name — a common red flag.";
        } else if (isShortener) {
          verdict = "suspicious";
          verdictNote =
            "Shortened links hide the real destination. Expand and check before clicking.";
        } else if (isHttpOnly) {
          verdict = "suspicious";
          verdictNote =
            "Link does not use HTTPS encryption — avoid entering any details.";
        } else {
          verdict = "unverified";
          verdictNote =
            "Cannot confirm legitimacy automatically. Check the domain and search SEBI's directory.";
        }
        break;
      }

      case "upi": {
        const handle = value.split("@")[1] || "";
        const known = [
          "upi", "ybl", "okhdfcbank", "okicici", "oksbi", "okaxis",
          "paytm", "apl", "ibl", "axl", "icici", "hdfcbank", "sbi",
          "kotak", "fbl", "okbizaxis"
        ];
        if (known.includes(handle)) {
          verdict = "unverified";
          verdictNote =
            "Known UPI handle format, but the receiver identity is still unverified. Never pay without confirming.";
        } else {
          verdict = "suspicious";
          verdictNote =
            "Unusual UPI handle. Double-check the receiver name in your UPI app before paying.";
        }
        break;
      }

      case "email":
        verdict = "unverified";
        verdictNote =
          "Do not reply or share details. Official SEBI communication comes from sebi.gov.in domains.";
        break;

      case "phone":
        verdict = "unverified";
        verdictNote =
          "Report/verify this number via the National Cyber Crime Portal before calling back.";
        break;

      default:
        break;
    }

    return {
      ...item,
      verdict,
      verdictNote
    };
  });
}

module.exports = {
  verifyIdentifiers
};
