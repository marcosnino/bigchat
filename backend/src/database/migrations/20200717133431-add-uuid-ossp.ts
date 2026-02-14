import { QueryInterface, DataTypes, Sequelize } from "sequelize";

module.exports = {
  up: (queryInterface: QueryInterface) => {
    const dialect = queryInterface.sequelize.getDialect();
    if (dialect === "postgres") {
      return queryInterface.sequelize.query('CREATE EXTENSION IF NOT EXISTS "uuid-ossp"');
    }
    // SQLite não precisa de extensão UUID
    return Promise.resolve();
  },

  down: (queryInterface: QueryInterface) => {
    const dialect = queryInterface.sequelize.getDialect();
    if (dialect === "postgres") {
      return queryInterface.sequelize.query('DROP EXTENSION IF EXISTS "uuid-ossp"');
    }
    return Promise.resolve();
  }
};
