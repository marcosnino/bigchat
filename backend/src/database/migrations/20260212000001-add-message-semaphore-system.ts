import { DataTypes, QueryInterface } from "sequelize";

module.exports = {
  up: (queryInterface: QueryInterface) => {
    return Promise.all([
      queryInterface.addColumn("Messages", "messageStatus", {
        type: DataTypes.ENUM("new", "replied", "waiting"),
        allowNull: false,
        defaultValue: "new"
      }),
      queryInterface.addColumn("Messages", "responseTime", {
        type: DataTypes.DATE,
        allowNull: true
      }),
      queryInterface.addColumn("Tickets", "lastClientMessageAt", {
        type: DataTypes.DATE,
        allowNull: true
      }),
      queryInterface.addColumn("Tickets", "lastAgentMessageAt", {
        type: DataTypes.DATE,
        allowNull: true
      }),
      queryInterface.addColumn("Tickets", "pendingClientMessages", {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: 0
      })
    ]);
  },

  down: (queryInterface: QueryInterface) => {
    return Promise.all([
      queryInterface.removeColumn("Messages", "messageStatus"),
      queryInterface.removeColumn("Messages", "responseTime"), 
      queryInterface.removeColumn("Tickets", "lastClientMessageAt"),
      queryInterface.removeColumn("Tickets", "lastAgentMessageAt"),
      queryInterface.removeColumn("Tickets", "pendingClientMessages")
    ]);
  }
};