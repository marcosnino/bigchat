import { QueryInterface, DataTypes } from "sequelize";

module.exports = {
  up: async (queryInterface: QueryInterface) => {
    await queryInterface.createTable("FlowChats", {
      id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
        allowNull: false
      },
      name: {
        type: DataTypes.STRING,
        allowNull: false
      },
      status: {
        type: DataTypes.STRING,
        defaultValue: "inactive",
        allowNull: false
      },
      trigger: {
        type: DataTypes.STRING,
        defaultValue: "keyword",
        allowNull: false
      },
      triggerCondition: {
        type: DataTypes.JSONB,
        defaultValue: {}
      },
      nodes: {
        type: DataTypes.JSONB,
        defaultValue: []
      },
      edges: {
        type: DataTypes.JSONB,
        defaultValue: []
      },
      companyId: {
        type: DataTypes.INTEGER,
        references: { model: "Companies", key: "id" },
        onUpdate: "CASCADE",
        onDelete: "SET NULL"
      },
      createdAt: {
        type: DataTypes.DATE,
        allowNull: false
      },
      updatedAt: {
        type: DataTypes.DATE,
        allowNull: false
      }
    });
    await queryInterface.addIndex("FlowChats", ["companyId"]);
    await queryInterface.addIndex("FlowChats", ["status"]);
    await queryInterface.addIndex("FlowChats", ["trigger"]);
  },

  down: async (queryInterface: QueryInterface) => {
    await queryInterface.dropTable("FlowChats");
  }
};
