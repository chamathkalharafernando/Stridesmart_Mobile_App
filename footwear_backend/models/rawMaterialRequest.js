module.exports = (sequelize, DataTypes) => {
  const RawMaterialRequest = sequelize.define('RawMaterialRequest', {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },
    employeeId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'employee',
        key: 'id',
      },
    },
    materialType: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    quantity: {
      type: DataTypes.FLOAT,
      allowNull: false,
    },
    requiredDate: {
      type: DataTypes.DATE,
      allowNull: false,
    },
    requiredLocation: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    status: {
      type: DataTypes.ENUM('pending', 'approved', 'rejected'),
      defaultValue: 'pending',
    },
  }, {
    tableName: 'raw_material_requests',
    timestamps: true,
  });

  return RawMaterialRequest;
};
