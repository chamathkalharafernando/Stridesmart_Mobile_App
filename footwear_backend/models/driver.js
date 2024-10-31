module.exports = (sequelize, DataTypes) => {
  const Driver = sequelize.define('Driver', {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },
    user_id: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    address: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    contact_number: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    email: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    image: {  
      type: DataTypes.STRING,
      allowNull: false,
    },
    password: {  // Add this field
      type: DataTypes.STRING,
      allowNull: false,
    },
    otp: {  // Add this field to temporarily store OTP
      type: DataTypes.STRING,
      allowNull: true, // This can be null if not set
    }
  }, {
    tableName: 'driver',
    timestamps: false 
  });
  return Driver;
};
