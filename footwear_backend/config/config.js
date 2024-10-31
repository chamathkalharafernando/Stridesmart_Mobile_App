require('dotenv').config();

module.exports = {
  development: {
    username: process.env.DB_USER,      // Reference to DB user from .env
    password: process.env.DB_PASSWORD,  // Reference to DB password from .env
    database: process.env.DB_NAME,      // Reference to DB name from .env
    host: process.env.DB_HOST,          // Reference to DB host from .env
    dialect: 'mysql',                   // DB dialect, static as 'mysql'
  }
};