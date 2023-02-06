const express = require("express");
const mongoose = require("mongoose");
require("dotenv").config();
const authRouter = require("./routes/auth");

const PORT = process.env.PORT || 3000;
const DB_URL = process.env.DB_URL;
const app = express();

app.use(express.json());
app.use(authRouter);

mongoose.set('strictQuery', false)
mongoose
    .connect(DB_URL, { useNewUrlParser: true, useUnifiedTopology: true })
    .then(() => {
        console.log("Connected to database");
    })
    .catch((err) => {
        console.log(err);
    });

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
