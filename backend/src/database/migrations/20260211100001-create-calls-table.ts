import { QueryInterface, DataTypes } from "sequelize";

module.exports = {
  up: async (queryInterface: QueryInterface) => {
    await queryInterface.createTable("Calls", {
      id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
        allowNull: false
      },
      uniqueId: {
        type: DataTypes.STRING,
        allowNull: false
      },
      caller: {
        type: DataTypes.STRING,
        allowNull: false
      },
      called: {
        type: DataTypes.STRING,
        allowNull: false
      },
      callerName: {
        type: DataTypes.STRING,
        allowNull: true
      },
      calledName: {
        type: DataTypes.STRING,
        allowNull: true
      },
      direction: {
        type: DataTypes.ENUM("inbound", "outbound"),
        defaultValue: "inbound"
      },
      status: {
        type: DataTypes.ENUM(
          "ringing",
          "answered",
          "busy",
          "no-answer",
          "failed",
          "canceled",
          "completed"
        ),
        defaultValue: "ringing"
      },
      startedAt: {
        type: DataTypes.DATE,
        allowNull: true
      },
      answeredAt: {
        type: DataTypes.DATE,
        allowNull: true
      },
      endedAt: {
        type: DataTypes.DATE,
        allowNull: true
      },
      duration: {
        type: DataTypes.INTEGER,
        defaultValue: 0
      },
      billableSeconds: {
        type: DataTypes.INTEGER,
        defaultValue: 0
      },
      hangupCause: {
        type: DataTypes.STRING,
        allowNull: true
      },
      hangupCode: {
        type: DataTypes.INTEGER,
        allowNull: true
      },
      recordingPath: {
        type: DataTypes.STRING,
        allowNull: true
      },
      recordingUrl: {
        type: DataTypes.STRING,
        allowNull: true
      },
      extension: {
        type: DataTypes.STRING,
        allowNull: true
      },
      queue: {
        type: DataTypes.STRING,
        allowNull: true
      },
      channel: {
        type: DataTypes.STRING,
        allowNull: true
      },
      linkedChannel: {
        type: DataTypes.STRING,
        allowNull: true
      },
      metadata: {
        type: DataTypes.JSONB,
        allowNull: true
      },
      companyId: {
        type: DataTypes.INTEGER,
        references: { model: "Companies", key: "id" },
        onUpdate: "CASCADE",
        onDelete: "SET NULL"
      },
      userId: {
        type: DataTypes.INTEGER,
        references: { model: "Users", key: "id" },
        onUpdate: "CASCADE",
        onDelete: "SET NULL",
        allowNull: true
      },
      contactId: {
        type: DataTypes.INTEGER,
        references: { model: "Contacts", key: "id" },
        onUpdate: "CASCADE",
        onDelete: "SET NULL",
        allowNull: true
      },
      ticketId: {
        type: DataTypes.INTEGER,
        references: { model: "Tickets", key: "id" },
        onUpdate: "CASCADE",
        onDelete: "SET NULL",
        allowNull: true
      },
      asteriskId: {
        type: DataTypes.INTEGER,
        references: { model: "Asterisks", key: "id" },
        onUpdate: "CASCADE",
        onDelete: "CASCADE"
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

    await queryInterface.addIndex("Calls", ["companyId"]);
    await queryInterface.addIndex("Calls", ["userId"]);
    await queryInterface.addIndex("Calls", ["contactId"]);
    await queryInterface.addIndex("Calls", ["asteriskId"]);
    await queryInterface.addIndex("Calls", ["uniqueId"]);
    await queryInterface.addIndex("Calls", ["status"]);
    await queryInterface.addIndex("Calls", ["startedAt"]);
  },

  down: async (queryInterface: QueryInterface) => {
    await queryInterface.dropTable("Calls");
  }
};
