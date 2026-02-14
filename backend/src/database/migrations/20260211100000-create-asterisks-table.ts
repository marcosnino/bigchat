import { QueryInterface, DataTypes } from "sequelize";

module.exports = {
  up: async (queryInterface: QueryInterface) => {
    await queryInterface.createTable("Asterisks", {
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
      host: {
        type: DataTypes.STRING,
        allowNull: false
      },
      ariPort: {
        type: DataTypes.INTEGER,
        defaultValue: 8088
      },
      sipPort: {
        type: DataTypes.INTEGER,
        defaultValue: 5060
      },
      wsPort: {
        type: DataTypes.INTEGER,
        defaultValue: 8089
      },
      ariUser: {
        type: DataTypes.STRING,
        allowNull: false
      },
      ariPassword: {
        type: DataTypes.STRING,
        allowNull: false
      },
      ariApplication: {
        type: DataTypes.STRING,
        allowNull: true
      },
      status: {
        type: DataTypes.STRING,
        defaultValue: "DISCONNECTED"
      },
      isActive: {
        type: DataTypes.BOOLEAN,
        defaultValue: false
      },
      useSSL: {
        type: DataTypes.BOOLEAN,
        defaultValue: false
      },
      sipDomain: {
        type: DataTypes.STRING,
        allowNull: true
      },
      outboundContext: {
        type: DataTypes.STRING,
        allowNull: true
      },
      inboundContext: {
        type: DataTypes.STRING,
        defaultValue: "from-internal"
      },
      notes: {
        type: DataTypes.TEXT,
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

    await queryInterface.addIndex("Asterisks", ["companyId"]);
  },

  down: async (queryInterface: QueryInterface) => {
    await queryInterface.dropTable("Asterisks");
  }
};
