const bcrypt = require('bcrypt');
const { Driver } = require('../models');

// Function to check if a driver exists by user_id or email
async function findDriverByUserIdOrEmail(user_id, email) {
  const driverByUserId = await Driver.findOne({ where: { user_id } });
  const driverByEmail = await Driver.findOne({ where: { email } });
  return driverByUserId || driverByEmail;
}

// Function to add a new driver
exports.addDriver = async (req, res) => {
  const { user_id, name, role, address, contact_number, email, password, image } = req.body;

  try {
    // Check if the driver with the same user_id or email already exists
    const existingDriver = await findDriverByUserIdOrEmail(user_id, email);

    if (existingDriver) {
      return res.status(400).json({ success: false, message: 'Driver with this user_id or email already exists' });
    }

    // Hash the password before saving
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create new driver
    const newDriver = await Driver.create({
      user_id,
      name,
      role,
      address,
      contact_number,
      email,
      password: hashedPassword,
      image
    });

    // Return the newly created driver (without the hashed password for security)
    const { password: _, ...driverWithoutPassword } = newDriver.toJSON();

    res.status(201).json({
      success: true,
      message: 'Driver added successfully',
      driver: driverWithoutPassword
    });
  } catch (err) {
    console.error('Error adding driver:', err);
    res.status(500).json({ success: false, message: 'Error adding driver', error: err });
  }
};
