import { QueryInterface, DataTypes } from "sequelize";

export default {
  up: async (queryInterface: QueryInterface) => {
    await queryInterface.createTable("ClosedTicketHistories", {
      id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
        allowNull: false
      },
      ticketId: {
        type: DataTypes.INTEGER,
        references: { model: "Tickets", key: "id" },
        onUpdate: "CASCADE",
        onDelete: "SET NULL",
        allowNull: true
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
      whatsappId: {
        type: DataTypes.INTEGER,
        references: { model: "Whatsapps", key: "id" },
        onUpdate: "CASCADE",
        onDelete: "SET NULL",
        allowNull: true
      },
      queueId: {
        type: DataTypes.INTEGER,
        references: { model: "Queues", key: "id" },
        onUpdate: "CASCADE",
        onDelete: "SET NULL",
        allowNull: true
      },
      ticketOpenedAt: {
        type: DataTypes.DATE,
        allowNull: true
      },
      ticketClosedAt: {
        type: DataTypes.DATE,
        allowNull: true
      },
      durationSeconds: {
        type: DataTypes.INTEGER,
        defaultValue: 0
      },
      finalStatus: {
        type: DataTypes.STRING,
        allowNull: true
      },
      closureReason: {
        type: DataTypes.TEXT,
        allowNull: true
      },
      totalMessages: {
        type: DataTypes.INTEGER,
        defaultValue: 0
      },
      rating: {
        type: DataTypes.INTEGER,
        allowNull: true
      },
      feedback: {
        type: DataTypes.TEXT,
        allowNull: true
      },
      tags: {
        type: DataTypes.JSON,
        allowNull: true
      },
      closedByUserId: {
        type: DataTypes.INTEGER,
        allowNull: true
      },
      semaphoreData: {
        type: DataTypes.JSON,
        allowNull: true
      },
      companyId: {
        type: DataTypes.INTEGER,
        references: { model: "Companies", key: "id" },
        onUpdate: "CASCADE",
        onDelete: "CASCADE",
        allowNull: false
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

    // Indexes for common queries
    await queryInterface.addIndex("ClosedTicketHistories", ["companyId"]);
    await queryInterface.addIndex("ClosedTicketHistories", ["contactId"]);
    await queryInterface.addIndex("ClosedTicketHistories", ["ticketId"]);
    await queryInterface.addIndex("ClosedTicketHistories", ["ticketClosedAt"]);
    await queryInterface.addIndex("ClosedTicketHistories", ["userId"]);
  },

  down: async (queryInterface: QueryInterface) => {
    await queryInterface.dropTable("ClosedTicketHistories");
  }
};
