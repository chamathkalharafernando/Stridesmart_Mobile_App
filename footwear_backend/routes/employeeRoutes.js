const express = require('express');
const { addEmployee, loginEmployee } = require('../controllers/employeeController');

const router = express.Router();

// Route to add a new employee
router.post('/add', addEmployee);

// Route for employee login
router.post('/login', loginEmployee);

module.exports = router;


