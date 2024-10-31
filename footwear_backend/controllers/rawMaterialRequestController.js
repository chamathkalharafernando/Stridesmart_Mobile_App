const { RawMaterialRequest, Employee } = require('../models');

exports.createRawMaterialRequest = async (req, res) => {
  console.log("Received Request Body: ", req.body);
  const { employeeId, materialType, quantity, requiredDate, requiredLocation } = req.body;

  try {
    // Check if the employee exists
    const employee = await Employee.findByPk(employeeId);
    if (!employee) {
      return res.status(404).json({ message: 'Employee not found' });
    }

    // Create the raw material request
    const request = await RawMaterialRequest.create({
      employeeId,
      materialType,
      quantity,
      requiredDate,
      requiredLocation,
    });

    res.status(201).json({ message: 'Raw material request created successfully', request });
  } catch (error) {
    console.error('Error creating raw material request:', error);
    res.status(500).json({ message: 'Error creating raw material request', error: error.message });
  }
};

exports.getRawMaterialRequests = async (req, res) => {
  try {
    const requests = await RawMaterialRequest.findAll({
      include: [{ model: Employee, attributes: ['name', 'user_id'] }],
    });
    res.json(requests);
  } catch (error) {
    console.error('Error fetching raw material requests:', error);
    res.status(500).json({ message: 'Error fetching raw material requests', error: error.message });
  }
};

exports.updateRawMaterialRequestStatus = async (req, res) => {
  const { id } = req.params;
  const { status } = req.body;

  try {
    const request = await RawMaterialRequest.findByPk(id);
    if (!request) {
      return res.status(404).json({ message: 'Raw material request not found' });
    }

    request.status = status;
    await request.save();

    res.json({ message: 'Raw material request status updated successfully', request });
  } catch (error) {
    console.error('Error updating raw material request status:', error);
    res.status(500).json({ message: 'Error updating raw material request status', error: error.message });
  }
};