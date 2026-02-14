import { QueryInterface, DataTypes } from "sequelize";

module.exports = {
  up: async (queryInterface: QueryInterface) => {
    // Adicionar campo phoneNumberId (ID do número na Meta)
    await queryInterface.addColumn("Whatsapps", "phoneNumberId", {
      type: DataTypes.STRING,
      allowNull: true,
    });

    // Adicionar campo businessAccountId (WABA ID)
    await queryInterface.addColumn("Whatsapps", "businessAccountId", {
      type: DataTypes.STRING,
      allowNull: true,
    });

    // Adicionar campo accessToken (Token permanente da Meta)
    await queryInterface.addColumn("Whatsapps", "accessToken", {
      type: DataTypes.TEXT,
      allowNull: true,
    });

    // Adicionar campo webhookVerifyToken (Token para verificar webhooks)
    await queryInterface.addColumn("Whatsapps", "webhookVerifyToken", {
      type: DataTypes.STRING,
      allowNull: true,
    });

    // Adicionar campo apiVersion (versão da API Meta)
    await queryInterface.addColumn("Whatsapps", "metaApiVersion", {
      type: DataTypes.STRING,
      allowNull: true,
      defaultValue: "v18.0",
    });
  },

  down: async (queryInterface: QueryInterface) => {
    await queryInterface.removeColumn("Whatsapps", "phoneNumberId");
    await queryInterface.removeColumn("Whatsapps", "businessAccountId");
    await queryInterface.removeColumn("Whatsapps", "accessToken");
    await queryInterface.removeColumn("Whatsapps", "webhookVerifyToken");
    await queryInterface.removeColumn("Whatsapps", "metaApiVersion");
  },
};
