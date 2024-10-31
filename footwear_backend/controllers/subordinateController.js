const { Subordinate, Employee, Order } = require('../models');

// Create Subordinate
exports.createSubordinate = async (req, res) => {
  const { user_id, name, address, orderId } = req.body;

  try {
    // Check if the employee exists by user_id
    const employee = await Employee.findOne({ where: { user_id } });
    if (!employee) {
      return res.status(404).json({ message: 'Employee not found' });
    }

    // Create the subordinate under the employee
    const subordinate = await Subordinate.create({
      user_id,
      name,
      address,
      orderId,
    });

    res.status(201).json({ message: 'Subordinate created successfully', subordinate });
  } catch (error) {
    console.error('Error creating subordinate:', error);
    res.status(500).json({ message: 'Error creating subordinate', error: error.message });
  }
};

// Update Subordinate Information
exports.updateSubordinate = async (req, res) => {
  const { id } = req.params;
  const { name, address, orderId } = req.body;

  try {
    const subordinate = await Subordinate.findByPk(id);
    if (!subordinate) {
      return res.status(404).json({ message: 'Subordinate not found' });
    }

    subordinate.name = name || subordinate.name;
    subordinate.address = address || subordinate.address;
    subordinate.orderId = orderId || subordinate.orderId;

    await subordinate.save();

    res.json({ message: 'Subordinate updated successfully', subordinate });
  } catch (error) {
    console.error('Error updating subordinate:', error);
    res.status(500).json({ message: 'Error updating subordinate', error: error.message });
  }
};

// Get Subordinates of an Employee by user_id
exports.getSubordinates = async (req, res) => {
  const { user_id } = req.params;

  try {
    const subordinates = await Subordinate.findAll({
      where: { user_id },
      include: [{ model: Order, attributes: ['status', 'description'] }]
    });

    res.json(subordinates);
  } catch (error) {
    console.error('Error fetching subordinates:', error);
    res.status(500).json({ message: 'Error fetching subordinates', error: error.message });
  }
};
