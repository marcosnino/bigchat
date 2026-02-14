import { QueryInterface, DataTypes } from "sequelize";

module.exports = {
  up: async (queryInterface: QueryInterface) => {
    const tableDesc = await queryInterface.describeTable("Tickets");

    if (!tableDesc["lastClientMessageAt"]) {
      await queryInterface.addColumn("Tickets", "lastClientMessageAt", {
        type: DataTypes.DATE,
        allowNull: true,
      });
    }

    if (!tableDesc["lastAgentMessageAt"]) {
      await queryInterface.addColumn("Tickets", "lastAgentMessageAt", {
        type: DataTypes.DATE,
        allowNull: true,
      });
    }

    if (!tableDesc["pendingClientMessages"]) {
      await queryInterface.addColumn("Tickets", "pendingClientMessages", {
        type: DataTypes.INTEGER,
        allowNull: true,
        defaultValue: 0,
      });
    }
  },

  down: async (queryInterface: QueryInterface) => {
    await queryInterface.removeColumn("Tickets", "lastClientMessageAt");
    await queryInterface.removeColumn("Tickets", "lastAgentMessageAt");
    await queryInterface.removeColumn("Tickets", "pendingClientMessages");
  },
};
