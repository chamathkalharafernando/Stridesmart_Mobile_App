const bcrypt = require('bcrypt');

// The password you want to hash
const password = 'Malshan!';  // Change this to your desired password

// Hashing the password
bcrypt.hash(password, 10, (err, hash) => {
  if (err) {
    console.error('Error hashing the password:', err);
  } else {
    console.log('Hashed Password:', hash);
  }
});
