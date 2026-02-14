import { QueryInterface, DataTypes } from "sequelize";

module.exports = {
  up: async (queryInterface: QueryInterface) => {
    await queryInterface.createTable("Extensions", {
      id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
        allowNull: false
      },
      exten: {
        type: DataTypes.STRING,
        allowNull: false
      },
      name: {
        type: DataTypes.STRING,
        allowNull: true
      },
      password: {
        type: DataTypes.STRING,
        allowNull: true
      },
      callerIdName: {
        type: DataTypes.STRING,
        allowNull: true
      },
      callerIdNumber: {
        type: DataTypes.STRING,
        allowNull: true
      },
      status: {
        type: DataTypes.ENUM("available", "busy", "ringing", "unavailable", "dnd"),
        defaultValue: "available"
      },
      isActive: {
        type: DataTypes.BOOLEAN,
        defaultValue: true
      },
      canRecord: {
        type: DataTypes.BOOLEAN,
        defaultValue: false
      },
      webrtcEnabled: {
        type: DataTypes.BOOLEAN,
        defaultValue: true
      },
      transport: {
        type: DataTypes.STRING,
        allowNull: true
      },
      context: {
        type: DataTypes.STRING,
        allowNull: true
      },
      codecs: {
        type: DataTypes.JSONB,
        allowNull: true
      },
      notes: {
        type: DataTypes.TEXT,
        allowNull: true
      },
      asteriskId: {
        type: DataTypes.INTEGER,
        references: { model: "Asterisks", key: "id" },
        onUpdate: "CASCADE",
        onDelete: "CASCADE"
      },
      userId: {
        type: DataTypes.INTEGER,
        references: { model: "Users", key: "id" },
        onUpdate: "CASCADE",
        onDelete: "SET NULL",
        allowNull: true
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

    await queryInterface.addIndex("Extensions", ["companyId"]);
    await queryInterface.addIndex("Extensions", ["asteriskId"]);
    await queryInterface.addIndex("Extensions", ["userId"]);
    await queryInterface.addIndex("Extensions", ["exten"]);
  },

  down: async (queryInterface: QueryInterface) => {
    await queryInterface.dropTable("Extensions");
  }
};
