const express = require("express");
const User = require("../models/user");
const bcrypt = require("bcryptjs");
const authRouter = express.Router();
const jwt = require("jsonwebtoken");

// Sign Up
authRouter.post("/api/signup", async (req, res) => {
    try {
        const { name, email, password } = req.body

        // Check if user already exists
        const isUserExist = await User.findOne({ email })
        if (isUserExist) {
            return res.status(400).json({ message: "User already exists" })
        }

        // Hash password
        const salt = await bcrypt.genSalt(10)
        const hashedPassword = await bcrypt.hash(password, salt)

        // Create new user
        const user = new User({
            name,
            email,
            password: hashedPassword,
        })

        // Save user to database
        const savedUser = await user.save()
        res.status(201).json(savedUser)
    } catch (error) {
        res.status(500).json({ message: error.message })
    }
});

// Sign In
authRouter.post("/api/signin", async (req, res) => {
    try {
        const { email, password } = req.body

        // Check if user exists
        const user = await User.findOne({ email });
        if (!user) {
            return res.status(400).json({ message: "User does not exist" })
        }

        // Check if password is correct
        const isPasswordCorrect = await bcrypt.compare(password, user.password)
        if (!isPasswordCorrect) {
            return res.status(400).json({ message: "Invalid credentials" })
        }

        // Create and assign a token
        const token = jwt.sign({ _id: user._id }, process.env.TOKEN_SECRET)
        res.header("auth-token", token).json({ token, ...user._doc })
    } catch (error) {
        res.status(500).json({ message: error.message })
    }
})

module.exports = authRouter;