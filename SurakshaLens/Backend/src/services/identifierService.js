const UPI_HANDLES = [
  "upi", "ybl", "okhdfcbank", "okicici", "oksbi", "okaxis",
  "paytm", "apl", "ibl", "axl", "icici", "hdfcbank", "sbi",
  "kotak", "fbl", "okbizaxis"
];

function extractIdentifiers(message) {
  const found = [];

  const hints = {
    telegram: "Investment groups on Telegram are a common fraud vector. Verify independently.",
    whatsapp: "Unsolicited WhatsApp investment offers are a common scam pattern. Verify independently.",
    apk: "Never install APKs from unknown links. They can contain malware.",
    url: "Do not trust links from unverified messages. Check the domain carefully.",
    email: "Be cautious of investment emails from unknown addresses.",
    upi: "Never send money to an unverified UPI ID, even if it claims to be official.",
    phone: "Do not call back or share details with numbers from suspicious messages."
  };

  const add = (type, label, value) => {
    if (!found.some((f) => f.value === value)) {
      found.push({ type, label, value, riskHint: hints[type] || "" });
    }
  };

  const telegramLinks = message.match(/(?:https?:\/\/)?(?:t\.me|telegram\.me)\/[^\s]+/gi) || [];
  telegramLinks.forEach((v) => add("telegram", "Telegram link", v));

  const whatsappLinks = message.match(/(?:https?:\/\/)?(?:wa\.me|chat\.whatsapp\.com)\/[^\s]+/gi) || [];
  whatsappLinks.forEach((v) => add("whatsapp", "WhatsApp link", v));

  const apkLinks = message.match(/(?:https?:\/\/[^\s]+\.apk(?:\?[^\s]*)?)/gi) || [];
  apkLinks.forEach((v) => add("apk", "APK / download link", v));

  const urls = message.match(/https?:\/\/[^\s]+/gi) || [];
  urls.forEach((v) => {
    if (!telegramLinks.includes(v) && !whatsappLinks.includes(v) && !apkLinks.includes(v)) {
      if (/\.apk(\?|$)/i.test(v)) {
        add("apk", "APK / download link", v);
      } else {
        add("url", "Website / link", v);
      }
    }
  });

  const emails = message.match(/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/g) || [];
  emails.forEach((v) => add("email", "Email address", v));

  const upiCandidates = message.match(/[a-zA-Z0-9._-]{2,}@[a-zA-Z]{2,}/g) || [];
  upiCandidates.forEach((v) => {
    const handle = v.split("@")[1].toLowerCase();
    if (UPI_HANDLES.includes(handle) && !emails.includes(v)) {
      add("upi", "UPI ID", v);
    }
  });

  const phones = message.match(/(?:\+91[\s-]?|0)?[6-9]\d{9}/g) || [];
  phones.forEach((v) => add("phone", "Phone number", v.trim()));

  return found;
}

module.exports = {
  extractIdentifiers
};