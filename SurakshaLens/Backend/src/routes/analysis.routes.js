const express = require("express");
const multer = require("multer");

const {
  analyzeText
} = require("../controllers/analysis.controller");

const {
  analyzeImage
} = require("../controllers/image.controller");

const router = express.Router();

const upload = multer({
  dest: "uploads/"
});

router.post("/text", analyzeText);

router.post(
  "/image",
  upload.single("image"),
  analyzeImage
);

module.exports = router;