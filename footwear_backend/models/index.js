const { Sequelize, DataTypes } = require('sequelize');
const config = require('../config/config').development;

const sequelize = new Sequelize(config.database, config.username, config.password, {
  host: config.host,
  dialect: config.dialect
});

// Test the database connection
sequelize.authenticate()
  .then(() => {
    console.log('Database connection has been established successfully.');
  })
  .catch(err => {
    console.error('Unable to connect to the database:', err);
  });

// Import models
const Driver = require('./driver')(sequelize, DataTypes);
const Employee = require('./employee')(sequelize, DataTypes);
const Order = require('./order')(sequelize, DataTypes);
const Tracking = require('./tracking')(sequelize, DataTypes);
const RawMaterialRequest = require('./rawMaterialRequest')(sequelize, DataTypes); 

// Define associations
Employee.hasMany(RawMaterialRequest, { foreignKey: 'employeeId' });
RawMaterialRequest.belongsTo(Employee, { foreignKey: 'employeeId' });
Employee.hasMany(Order, { foreignKey: 'user_id', sourceKey: 'user_id' });
Order.belongsTo(Employee, { foreignKey: 'user_id', targetKey: 'user_id' });

// Export the models and sequelize instance
module.exports = { sequelize, Driver, Employee, Order, Tracking, RawMaterialRequest };
