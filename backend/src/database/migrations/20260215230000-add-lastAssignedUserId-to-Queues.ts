import { QueryInterface, DataTypes } from "sequelize";

module.exports = {
  up: (queryInterface: QueryInterface) => {
    return queryInterface.addColumn("Queues", "lastAssignedUserId", {
      type: DataTypes.INTEGER,
      allowNull: true
    });
  },

  down: (queryInterface: QueryInterface) => {
    return queryInterface.removeColumn("Queues", "lastAssignedUserId");
  }
};
