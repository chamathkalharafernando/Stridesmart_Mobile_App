module.exports = (sequelize, DataTypes) => {
  const Order = sequelize.define('Order', {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },
    status: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: false,
    },
    user_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'employee',  // Reference the employee table
        key: 'id',
      },
    },
    updatedAt: {  
      type: DataTypes.DATE,
      allowNull: true,
    },
  }, {
    tableName: 'Orders',  // Table name in the database
    timestamps: true,  // Enable timestamps to automatically manage `createdAt` and `updatedAt`
  });

  return Order;
};
