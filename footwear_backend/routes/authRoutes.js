const express = require('express');
const {
  sendOtp,
  verifyOtp,
  resetPassword,
  login
} = require('../controllers/authController');

const router = express.Router();

// Route to send OTP to user's email (both employee and driver)
router.post('/send-otp', sendOtp);

// Route to verify OTP (both employee and driver)
router.post('/verify-otp', verifyOtp);

// Route to reset password (both employee and driver)
router.post('/reset-password', resetPassword);

// Route for login (both employee and driver)
router.post('/login', login);

module.exports = router;




