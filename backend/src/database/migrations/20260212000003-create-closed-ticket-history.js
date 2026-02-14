'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Criar tabela ClosedTicketHistory
    await queryInterface.createTable('ClosedTicketHistories', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER,
      },
      ticketId: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'Tickets',
          key: 'id',
        },
        onUpdate: 'CASCADE',
        onDelete: 'SET NULL',
      },
      userId: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'Users',
          key: 'id',
        },
        onUpdate: 'CASCADE',
        onDelete: 'SET NULL',
      },
      contactId: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'Contacts',
          key: 'id',
        },
        onUpdate: 'CASCADE',
        onDelete: 'SET NULL',
      },
      whatsappId: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'Whatsapps',
          key: 'id',
        },
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE',
      },
      queueId: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'Queues',
          key: 'id',
        },
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE',
      },
      ticketOpenedAt: {
        type: Sequelize.DATE,
        allowNull: false,
      },
      ticketClosedAt: {
        type: Sequelize.DATE,
        allowNull: false,
      },
      durationSeconds: {
        type: Sequelize.INTEGER,
        defaultValue: 0,
      },
      finalStatus: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      closureReason: {
        type: Sequelize.TEXT,
        allowNull: true,
      },
      totalMessages: {
        type: Sequelize.INTEGER,
        defaultValue: 0,
      },
      rating: {
        type: Sequelize.INTEGER,
        allowNull: true,
      },
      feedback: {
        type: Sequelize.TEXT,
        allowNull: true,
      },
      tags: {
        type: Sequelize.JSON,
        allowNull: true,
      },
      closedByUserId: {
        type: Sequelize.INTEGER,
        allowNull: true,
      },
      semaphoreData: {
        type: Sequelize.JSON,
        allowNull: true,
      },
      companyId: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'Companies',
          key: 'id',
        },
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE',
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE,
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE,
      },
    });

    // Criar índices para melhorar performance
    await queryInterface.addIndex('ClosedTicketHistories', {
      fields: ['companyId', 'ticketClosedAt'],
      name: 'idx_closed_ticket_company_closed_at',
    });

    await queryInterface.addIndex('ClosedTicketHistories', {
      fields: ['companyId', 'ticketOpenedAt'],
      name: 'idx_closed_ticket_company_opened_at',
    });

    await queryInterface.addIndex('ClosedTicketHistories', {
      fields: ['whatsappId'],
      name: 'idx_closed_ticket_whatsapp_id',
    });

    await queryInterface.addIndex('ClosedTicketHistories', {
      fields: ['queueId'],
      name: 'idx_closed_ticket_queue_id',
    });

    await queryInterface.addIndex('ClosedTicketHistories', {
      fields: ['userId'],
      name: 'idx_closed_ticket_user_id',
    });

    await queryInterface.addIndex('ClosedTicketHistories', {
      fields: ['ticketClosedAt'],
      name: 'idx_closed_ticket_closed_at',
    });

    await queryInterface.addIndex('ClosedTicketHistories', {
      fields: ['ticketOpenedAt'],
      name: 'idx_closed_ticket_opened_at',
    });
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.dropTable('ClosedTicketHistories');
  }
};
