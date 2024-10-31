const { Employee, Driver } = require('../models');
const nodemailer = require('nodemailer');
require('dotenv').config();  // This will load the .env file variables
const bcrypt = require('bcrypt');

console.log("Email User:", process.env.EMAIL_USER);
console.log("Email Password:", process.env.EMAIL_PASSWORD);

// Configure Nodemailer
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASSWORD,
  },
  tls: {
    rejectUnauthorized: false,
  },
});


// Send OTP to user's email
exports.sendOtp = async (req, res) => {
  const { email } = req.body;

  try {
    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    const employee = await Employee.findOne({ where: { email } });
    const driver = await Driver.findOne({ where: { email } });

    if (!employee && !driver) {
      return res.status(404).json({ message: 'Email not found' });
    }

    // Store the OTP in the appropriate model
    if (employee) {
      employee.otp = otp;
      await employee.save();
    } else if (driver) {
      driver.otp = otp;
      await driver.save();
    }

    const mailOptions = {
      from: process.env.EMAIL_USER,
      to: email,
      subject: 'Your OTP for Password Reset',
      text: `Your OTP is ${otp}. Please use it to reset your password.`,
    };

    await transporter.sendMail(mailOptions);
    res.status(200).json({ message: 'OTP sent to your email.' });
  } catch (error) {
    console.error('Error sending OTP:', error);
    res.status(500).json({ message: 'Error sending OTP', error });
  }
};

// Verify OTP
exports.verifyOtp = async (req, res) => {
  const { email, otp } = req.body;

  try {
    const employee = await Employee.findOne({ where: { email } });
    const driver = await Driver.findOne({ where: { email } });

    if (employee && employee.otp === otp) {
      return res.status(200).json({ message: 'OTP verified', userType: 'employee' });
    }
    if (driver && driver.otp === otp) {
      return res.status(200).json({ message: 'OTP verified', userType: 'driver' });
    }

    res.status(400).json({ message: 'Invalid OTP' });
  } catch (error) {
    console.error('Error verifying OTP:', error);
    res.status(500).json({ message: 'Error verifying OTP', error });
  }
};

// Reset Password
exports.resetPassword = async (req, res) => {
  const { email, newPassword } = req.body;

  try {
    const employee = await Employee.findOne({ where: { email } });
    const driver = await Driver.findOne({ where: { email } });

    let user = employee || driver;

    if (!user) {
      return res.status(404).json({ message: 'Email not found' });
    }

    user.password = await bcrypt.hash(newPassword, 10);
    user.otp = null;
    await user.save();

    await transporter.sendMail({
      from: process.env.EMAIL_USER,
      to: email,
      subject: 'Password Reset Successful',
      text: `Hi ${user.name},\n\nYour password has been successfully reset. If this wasn't you, please contact support immediately.\n\nThank you.`,
    });

    res.status(200).json({ message: 'Password has been reset successfully and email notification sent.' });
  } catch (error) {
    console.error('Error resetting password:', error);
    res.status(500).json({ message: 'Error resetting password', error });
  }
};
