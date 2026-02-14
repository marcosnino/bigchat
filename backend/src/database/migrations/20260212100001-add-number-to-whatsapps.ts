import { QueryInterface, DataTypes } from "sequelize";

module.exports = {
  up: async (queryInterface: QueryInterface) => {
    const tableDesc = await queryInterface.describeTable("Whatsapps");

    if (!tableDesc["number"]) {
      await queryInterface.addColumn("Whatsapps", "number", {
        type: DataTypes.STRING,
        allowNull: true,
      });
    }
  },

  down: async (queryInterface: QueryInterface) => {
    await queryInterface.removeColumn("Whatsapps", "number");
  },
};
