const bcrypt = require('bcrypt');
const { Employee } = require('../models');

// Function to check if an employee exists by user_id or email
async function findEmployeeByUserIdOrEmail(user_id, email) {
  const employeeByUserId = await Employee.findOne({ where: { user_id } });
  const employeeByEmail = await Employee.findOne({ where: { email } });
  return employeeByUserId || employeeByEmail;
}

// Function to add a new employee
exports.addEmployee = async (req, res) => {
  const { user_id, name, role, address, contact_number, email, password, image } = req.body;

  try {
    // Check if the employee with the same user_id or email already exists
    const existingEmployee = await findEmployeeByUserIdOrEmail(user_id, email);

    if (existingEmployee) {
      return res.status(400).json({ success: false, message: 'Employee with this user_id or email already exists' });
    }

    // Hash the password before saving
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create new employee
    const newEmployee = await Employee.create({
      user_id,
      name,
      role,
      address,
      contact_number,
      email,
      password: hashedPassword,
      image
    });

    // Return the newly created employee (without the hashed password for security)
    const { password: _, ...employeeWithoutPassword } = newEmployee.toJSON();

    res.status(201).json({
      success: true,
      message: 'Employee added successfully',
      employee: employeeWithoutPassword
    });
  } catch (err) {
    console.error('Error adding employee:', err);
    res.status(500).json({ success: false, message: 'Error adding employee', error: err });
  }
};
