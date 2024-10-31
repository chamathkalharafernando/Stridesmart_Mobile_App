const { Order } = require('../models');

// Update Order Status with Error Handling
exports.updateOrderStatus = async (req, res) => {
  const { orderId } = req.params;
  const { status } = req.body;  // New status for the order

  try {
    // Log the received orderId and status for debugging
    console.log('Received Order ID:', orderId);
    console.log('New Status:', status);

    // Find the order by ID
    const order = await Order.findByPk(orderId);
    
    if (!order) {
      // Log and return if the order is not found
      console.log('Order not found');
      return res.status(404).json({ message: 'Order not found' });
    }

    // Update the order's status
    order.status = status;
    await order.save();  // Save changes to the database

    // Log success and return the updated order
    console.log('Order status updated successfully');
    res.json({ message: 'Order status updated successfully', order });

  } catch (error) {
    // Log the full error for debugging
    console.error('Error updating order status:', error);

    // Return a 500 error with a message and the error details
    res.status(500).json({ message: 'Error updating order status', error: error.message });
  }
};
