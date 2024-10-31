module.exports = (sequelize, DataTypes) => {
    const Subordinate = sequelize.define('Subordinate', {
      id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
      },
      user_id: {  
        type: DataTypes.STRING,  
        allowNull: false,
        references: {
          model: 'employee',  
          key: 'user_id',     
        },
      },
      name: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      address: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      orderId: {
        type: DataTypes.INTEGER,
        allowNull: true,
        references: {
          model: 'Order',
          key: 'id',
        }
      },
    }, {
      tableName: 'subordinates',
      timestamps: true,
    });
  
    Subordinate.associate = models => {
      Subordinate.belongsTo(models.Employee, { foreignKey: 'user_id', targetKey: 'user_id' });
      Subordinate.belongsTo(models.Order, { foreignKey: 'orderId' });
    };
  
    return Subordinate;
  };
  