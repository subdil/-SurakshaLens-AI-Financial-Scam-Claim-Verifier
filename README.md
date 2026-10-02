# 🛡️ SurakshaLens

**AI-powered financial scam & misinformation resilience assistant for Bharat.**

> *"Before you trust a financial message, let SurakshaLens explain what it claims, identify the warning signs, verify what can be verified, and tell you what to do next — in simple language."*

## 🔗 Links

- 🌐 **Live Web App:** https://surakshalens.vercel.app/
- ⚙️ **Backend API:** https://suraksha-lens-ai-financial-scam-claim-verifier-gkl9mxmzf.vercel.app/api/health
- 📱 **Android APK:** https://github.com/subdil/-SurakshaLens-AI-Financial-Scam-Claim-Verifier/releases/download/v1.0.0/app-release.apk
- 📊 **Presentation:** [SurakshaLens_Presentation.pptx](SurakshaLens_Presentation.pptx)

## ❓ Problem

Crores of Indians lose money daily to fake investment schemes, KYC phishing, loan traps, and Telegram/WhatsApp scams — and victims rarely have an easy way to check a suspicious message before paying.

## ✅ Solution

SurakshaLens lets you paste a message or upload its screenshot. It then:

1. Extracts the text (OCR)
2. Scores the risk (High / Medium / Low) with clear warning signs
3. Detects the type of scam claim (lottery, KYC, crypto, fake job, ...)
4. Extracts identifiers — UPI IDs, Telegram/WhatsApp links, phone numbers, APKs — with verification hints
5. Shows **Evidence & Verification** cards linked to official sources (SEBI, SCORES, National Cyber Crime Portal)
6. Gives safe next-step actions

## ✨ Features

- 📸 Screenshot → OCR → analysis
- 💬 Paste message analysis
- 🎤 Voice input (speak the message → analyze)
- 🔊 Voice output of results (EN / हिंदी / ਪੰਜਾਬੀ)
- 🇮🇳 Trilingual UI: English, Hindi, Punjabi
- 🧾 Scam claim detection (10 categories)
- 🔍 Smart identifier extraction + verification verdicts
- 🛡️ Official verification sources
- 🕘 On-device scan history (privacy-first — no data stored on servers)
- 🌙 Dark professional theme

## 🏗️ Tech Stack

| Layer | Tech |
|---|---|
| Frontend | Flutter (mobile + web), speech_to_text, flutter_tts |
| Backend | Node.js, Express, Multer, Tesseract.js |
| Deployment | Vercel (backend + web), GitHub Releases (APK) |

## 🚀 Run Locally

**Backend**
```bash
cd Backend
npm install
node src/server.js
```

**Frontend**
```bash
cd surakshalens
flutter pub get
flutter run -d chrome
```

## 📁 Project Structure

```
SurakshaLens/
├── Backend/
│   └── src/
│       ├── controllers/   # request handlers
│       ├── routes/        # express routes
│       └── services/      # risk engine, OCR, evidence, identifiers
└── surakshalens/
    └── lib/
        ├── pages/         # home, paste, shot, result, history
        ├── services/      # API, history
        └── util/          # strings, tts
```

## 👥 Team

**DevLab** — Team Lead: subdil goyal

## 📜 License

Built for SANGYAN Hackathon.
