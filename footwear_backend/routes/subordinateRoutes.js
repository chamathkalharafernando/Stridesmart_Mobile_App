const express = require('express');
const { createSubordinate, updateSubordinate, getSubordinates } = require('../controllers/subordinateController');
const router = express.Router();

// Create a new subordinate
router.post('/create', createSubordinate);

// Update subordinate information
router.put('/update/:id', updateSubordinate);

// Get all subordinates of an employee by user_id
router.get('/:user_id', getSubordinates);

module.exports = router;
