const express = require("express");
const cors = require("cors");
require("dotenv").config();

const analysisRoutes = require("./routes/analysis.routes");

const app = express();

const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.json({
    success: true,
    message: "SurakshaLens backend is running"
  });
});

app.get("/api/health", (req, res) => {
  res.json({
    success: true,
    message: "SurakshaLens API is healthy"
  });
});

app.use("/api/analyze", analysisRoutes);

app.listen(PORT, () => {
  console.log(`SurakshaLens server running on port ${PORT}`);
});