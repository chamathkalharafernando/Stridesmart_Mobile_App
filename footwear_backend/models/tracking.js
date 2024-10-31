module.exports = (sequelize, DataTypes) => {
    const Tracking = sequelize.define('Tracking', {
      id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
      },
      latitude: {
        type: DataTypes.FLOAT,
        allowNull: false,
      },
      longitude: {
        type: DataTypes.FLOAT,
        allowNull: false,
      },
      driverId: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
          model: 'Driver',
          key: 'id'
        }
      }
    });
    return Tracking;
  };
  