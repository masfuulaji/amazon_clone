const jwt = require("jsonwebtoken");

const auth = async (req, res, next) => {
    try {
        const token = req.header("x-auth-token");
        if (!token) {
            return res.status(401).json({ message: "No authentication token, authorization denied." });
        }

        const verified = jwt.verify(token, process.env.TOKEN_SECRET);
        if (!verified) {
            return res.status(401).json({ message: "Token verification failed, authorization denied." });
        }
        req.user = verified._id;
        req.token = token;
        next();
    } catch (error) {
        res.status(401).send({ error: "Please authenticate." });
    }
}

module.exports = auth;