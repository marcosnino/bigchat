'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.addColumn("Users", "validated", {
      type: Sequelize.BOOLEAN,
      allowNull: false,
      defaultValue: false
    });
  },

  down: (queryInterface, Sequelize) => {
    return queryInterface.removeColumn("Users", "validated");
  }
};
