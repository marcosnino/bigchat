import { QueryInterface, DataTypes } from "sequelize";

module.exports = {
  up: (queryInterface: QueryInterface) => {
    return queryInterface.addColumn("Tickets", "closeReasonId", {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: { model: "CloseReasons", key: "id" },
      onUpdate: "SET NULL",
      onDelete: "SET NULL"
    });
  },

  down: (queryInterface: QueryInterface) => {
    return queryInterface.removeColumn("Tickets", "closeReasonId");
  }
};
