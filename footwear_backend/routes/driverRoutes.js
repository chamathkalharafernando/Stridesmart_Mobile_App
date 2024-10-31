const express = require('express');
const { addDriver } = require('../controllers/driverController');

const router = express.Router();

// Route to add a new driver
router.post('/add', addDriver);

// Route for employee login
router.post('/login', loginDriver);

module.exports = router;
