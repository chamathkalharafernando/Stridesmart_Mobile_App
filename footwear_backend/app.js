const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql');
const bcrypt = require('bcrypt');
const nodemailer = require('nodemailer');
const cors = require('cors');
require('dotenv').config();
const moment = require('moment');

const app = express();
const port = 3000;

// Enable CORS for cross-origin requests
app.use(cors());

// Middleware to parse JSON request bodies
app.use(bodyParser.json());

// MySQL connection setup (using environment variables for security)
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

connection.connect((err) => {
  if (err) {
    console.error('Error connecting to MySQL:', err);
    return;
  }
  console.log('Connected to MySQL');
});

// Nodemailer configuration (for sending OTP emails)
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASSWORD,
  },
});

// *************** LOGIN FUNCTIONALITY ***************
app.post('/login', async (req, res) => {
  const { user_id, password } = req.body;

  const employeeQuery = 'SELECT * FROM employee WHERE user_id = ?';
  connection.query(employeeQuery, [user_id], async (err, employeeResult) => {
    if (err) {
      console.error('Error querying employee:', err);
      return res.status(500).json({ success: false, message: 'Internal server error' });
    }

    if (employeeResult.length > 0) {
      const employee = employeeResult[0];
      const isMatch = await bcrypt.compare(password, employee.password);
      if (isMatch) {
        return res.json({ success: true, role: 'employee', user: employee });
      }
    }

    const driverQuery = 'SELECT * FROM driver WHERE user_id = ?';
    connection.query(driverQuery, [user_id], async (err, driverResult) => {
      if (err) {
        console.error('Error querying driver:', err);
        return res.status(500).json({ success: false, message: 'Internal server error' });
      }

      if (driverResult.length > 0) {
        const driver = driverResult[0];
        const isMatch = await bcrypt.compare(password, driver.password);
        if (isMatch) {
          return res.json({ success: true, role: 'driver', user: driver });
        }
      }

      return res.status(401).json({ success: false, message: 'Invalid credentials' });
    });
  });
});

// *************** OTP FUNCTIONALITY ***************
app.post('/send-otp', async (req, res) => {
  const { email } = req.body;
  const otp = Math.floor(100000 + Math.random() * 900000).toString();

  try {
    const employeeQuery = 'SELECT * FROM employee WHERE email = ?';
    const driverQuery = 'SELECT * FROM driver WHERE email = ?';

    connection.query(employeeQuery, [email], (err, employeeResult) => {
      if (err) {
        return res.status(500).json({ success: false, message: 'Error checking email', err });
      }

      if (employeeResult.length > 0) {
        connection.query(`UPDATE employee SET otp = ? WHERE email = ?`, [otp, email], (err) => {
          if (err) {
            return res.status(500).json({ success: false, message: 'Error updating OTP for employee', err });
          }
        });
      } else {
        connection.query(driverQuery, [email], (err, driverResult) => {
          if (err) {
            return res.status(500).json({ success: false, message: 'Error checking email', err });
          }

          if (driverResult.length > 0) {
            connection.query(`UPDATE driver SET otp = ? WHERE email = ?`, [otp, email], (err) => {
              if (err) {
                return res.status(500).json({ success: false, message: 'Error updating OTP for driver', err });
              }
            });
          } else {
            return res.status(404).json({ success: false, message: 'Email not found' });
          }
        });
      }

      transporter.sendMail({
        from: process.env.EMAIL_USER,
        to: email,
        subject: 'Your OTP for Password Reset',
        text: `Your OTP is ${otp}`,
      }, (err) => {
        if (err) {
          return res.status(500).json({ success: false, message: 'Error sending OTP email' });
        }
        return res.status(200).json({ success: true, message: 'OTP sent to your email' });
      });
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error sending OTP', error });
  }
});

// Verify OTP
app.post('/verify-otp', (req, res) => {
  const { email, otp } = req.body;

  const employeeQuery = 'SELECT * FROM employee WHERE email = ? AND otp = ?';
  const driverQuery = 'SELECT * FROM driver WHERE email = ? AND otp = ?';

  connection.query(employeeQuery, [email, otp], (err, employeeResult) => {
    if (err) {
      return res.status(500).json({ success: false, message: 'Error verifying OTP', err });
    }

    if (employeeResult.length > 0) {
      return res.status(200).json({ success: true, message: 'OTP verified', userType: 'employee' });
    } else {
      connection.query(driverQuery, [email, otp], (err, driverResult) => {
        if (err) {
          return res.status(500).json({ success: false, message: 'Error verifying OTP', err });
        }

        if (driverResult.length > 0) {
          return res.status(200).json({ success: true, message: 'OTP verified', userType: 'driver' });
        } else {
          return res.status(400).json({ success: false, message: 'Invalid OTP' });
        }
      });
    }
  });
});

// Reset Password
app.post('/reset-password', async (req, res) => {
  const { email, newPassword } = req.body;

  try {
    const hashedPassword = await bcrypt.hash(newPassword, 10);

    const employeeQuery = 'UPDATE employee SET password = ?, otp = NULL WHERE email = ?';
    const driverQuery = 'UPDATE driver SET password = ?, otp = NULL WHERE email = ?';

    connection.query(employeeQuery, [hashedPassword, email], (err, result) => {
      if (err) {
        return res.status(500).json({ success: false, message: 'Error resetting password', err });
      }

      if (result.affectedRows > 0) {
        return res.status(200).json({ success: true, message: 'Password reset successfully' });
      } else {
        connection.query(driverQuery, [hashedPassword, email], (err, result) => {
          if (err) {
            return res.status(500).json({ success: false, message: 'Error resetting password', err });
          }

          if (result.affectedRows > 0) {
            return res.status(200).json({ success: true, message: 'Password reset successfully' });
          } else {
            return res.status(404).json({ success: false, message: 'User not found' });
          }
        });
      }
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error resetting password', error });
  }
});

// *************** CHANGE PASSWORD FUNCTIONALITY ***************
app.post('/change-password', async (req, res) => {
  const { user_id, oldPassword, newPassword } = req.body;

  const query = 'SELECT password FROM employee WHERE user_id = ?';
  connection.query(query, [user_id], (err, results) => {
    if (err) {
      return res.status(500).json({ success: false, message: 'Database error', err });
    }

    if (results.length > 0) {
      const storedPassword = results[0].password;
      bcrypt.compare(oldPassword, storedPassword, async (err, isMatch) => {
        if (err) {
          return res.status(500).json({ success: false, message: 'Error comparing passwords', err });
        }

        if (!isMatch) {
          return res.status(401).json({ success: false, message: 'Current password is incorrect' });
        }

        // Hash the new password before saving
        const hashedPassword = await bcrypt.hash(newPassword, 10);
        connection.query('UPDATE employee SET password = ? WHERE user_id = ?', [hashedPassword, user_id], (err) => {
          if (err) {
            return res.status(500).json({ success: false, message: 'Failed to update password', err });
          }
          res.json({ success: true, message: 'Password changed successfully' });
        });
      });
    } else {
      res.status(404).json({ success: false, message: 'User not found' });
    }
  });
});

// *************** SUBORDINATES CRUD FUNCTIONALITY ***************
// Retrieve all subordinates
app.get('/get-subordinates', (req, res) => {
  const query = 'SELECT * FROM subordinates';
  connection.query(query, (err, results) => {
    if (err) {
      console.error('Database error:', err);
      return res.status(500).json({ success: false, message: 'Database error', error: err.message });
    }
    res.json({ success: true, subordinates: results });
  });
});

// Add a new subordinate
app.post('/add-subordinate', (req, res) => {
  const { name, address, contactNumber, gender } = req.body;

  const query = 'INSERT INTO subordinates (name, address, contactNumber, gender) VALUES (?, ?, ?, ?)';
  connection.query(query, [name, address, contactNumber, gender], (err, results) => {
    if (err) {
      console.error('Error adding subordinate:', err);
      return res.status(500).json({ success: false, message: 'Error adding subordinate', error: err.message });
    }
    res.json({ success: true, message: 'Subordinate added successfully', insertedId: results.insertId });
  });
});

// Update a subordinate by ID
app.post('/update-subordinate/:id', (req, res) => {
  const { id } = req.params;
  const { name, address, contactNumber, gender } = req.body;

  const query = 'UPDATE subordinates SET name = ?, address = ?, contactNumber = ?, gender = ? WHERE id = ?';
  connection.query(query, [name, address, contactNumber, gender, id], (err, results) => {
    if (err) {
      console.error('Error updating subordinate:', err);
      return res.status(500).json({ success: false, message: 'Error updating subordinate', error: err.message });
    }
    if (results.affectedRows === 0) {
      return res.status(404).json({ success: false, message: 'Subordinate not found' });
    }
    res.json({ success: true, message: 'Subordinate updated successfully' });
  });
});

// app.post('/update-subordinate', (req, res) => {
//   const { id, name, address, contactNumber, gender } = req.body;

//   const query = 'UPDATE subordinates SET name = ?, address = ?, contactNumber = ?, gender = ? WHERE id = ?';
  
//   connection.query(query, [name, address, contactNumber, gender, id], (err, results) => {
//     if (err) {
//       console.error('Error updating subordinate:', err);
//       return res.status(500).json({ success: false, message: 'Error updating subordinate', error: err.message });
//     }
//     if (results.affectedRows === 0) {
//       return res.status(404).json({ success: false, message: 'Subordinate not found' });
//     }
//     res.json({ success: true, message: 'Subordinate updated successfully' });
//   });
// });



// Delete a subordinate by ID
app.delete('/delete-subordinate/:id', (req, res) => {
  const { id } = req.params;

  const query = 'DELETE FROM subordinates WHERE id = ?';
  connection.query(query, [id], (err, results) => {
    if (err) {
      console.error('Error deleting subordinate:', err);
      return res.status(500).json({ success: false, message: 'Error deleting subordinate', error: err.message });
    }
    if (results.affectedRows === 0) {
      return res.status(404).json({ success: false, message: 'Subordinate not found' });
    }
    res.json({ success: true, message: 'Subordinate deleted successfully' });
  });
});


// *************** EMPLOYEE UPDATE FUNCTIONALITY ***************
app.post('/update-employee', (req, res) => {
  const { name, address, contact_number, email } = req.body;

  const query = 'UPDATE employee SET name = ?, email = ? WHERE user_id = ?';
  connection.query(query, [name, address, contact_number, email], (err) => {
    if (err) {
      return res.status(500).json({ success: false, message: 'Database error', err });
    }
    res.json({ success: true, message: 'Employee updated successfully' });
  });
});

// Endpoint to handle order submission
app.post('/submit-order', (req, res) => {
  const { current_status, amount_completed, quantity_to_be_finished, projected_timeline } = req.body;

  const query = `INSERT INTO status (current_status, amount_completed, quantity_to_be_finished, projected_timeline)
                 VALUES (?, ?, ?, ?)`;

  const values = [
    current_status,
    current_status === 'Not Completed Yet' ? amount_completed : null,
    current_status === 'Not Completed Yet' ? quantity_to_be_finished : null,
    current_status === 'Not Completed Yet' ? projected_timeline : null,
  ];

  connection.query(query, values, (err, result) => {
    if (err) {
      console.error('Error inserting order into database:', err);
      res.status(500).json({ message: 'Failed to submit order' });
      return;
    }
    console.log('Order inserted successfully:', result);
    res.status(200).json({ message: 'Order submitted successfully' });
  });
});


// *************** Apply Leave endpoint ***************

app.post('/apply-leave', (req, res) => {
  const { user_id, user_role, leave_type, from_date, to_date, reason } = req.body;

  // Check for empty fields
  if (!user_id || !user_role || !leave_type || !from_date || !to_date || !reason) {
    return res.status(400).json({ 
      success: false, 
      message: 'All fields are required.' 
    });
  }

 

  // Insert leave application into database
  const query = `INSERT INTO leave_applications (user_id, user_role, leave_type, from_date, to_date, reason) 
                 VALUES (?, ?, ?, ?, ?, ?)`;

  const values = [user_id, user_role, leave_type, from_date, to_date, reason];

  connection.query(query, values, (err, result) => {
    if (err) {
      console.error('Error applying leave:', err);
      return res.status(500).json({ success: false, message: 'Error applying leave' });
    }
    res.status(200).json({ success: true, message: 'Leave applied successfully' });
  });
});

// Start the server
app.listen(port, () => {
  console.log(`Server running at http://10.0.2.2:${port}`);
});
