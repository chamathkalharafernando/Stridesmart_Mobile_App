const express = require('express');
const { updateOrderStatus } = require('../controllers/orderController');
const router = express.Router();

// Route to update order status
router.post('/update-status/:orderId', updateOrderStatus);

module.exports = router;
