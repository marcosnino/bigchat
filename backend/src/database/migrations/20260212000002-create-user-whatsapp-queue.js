'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Criar tabela UserWhatsappQueue
    await queryInterface.createTable('UserWhatsappQueues', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER,
      },
      userId: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'Users',
          key: 'id',
        },
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE',
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
      isActive: {
        type: Sequelize.BOOLEAN,
        allowNull: false,
        defaultValue: true,
      },
      notes: {
        type: Sequelize.TEXT,
        allowNull: true,
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
    await queryInterface.addIndex('UserWhatsappQueues', {
      fields: ['userId', 'whatsappId', 'queueId'],
      unique: true,
      name: 'unique_user_whatsapp_queue',
    });

    await queryInterface.addIndex('UserWhatsappQueues', {
      fields: ['userId'],
      name: 'idx_user_whatsapp_queue_user_id',
    });

    await queryInterface.addIndex('UserWhatsappQueues', {
      fields: ['whatsappId'],
      name: 'idx_user_whatsapp_queue_whatsapp_id',
    });

    await queryInterface.addIndex('UserWhatsappQueues', {
      fields: ['queueId'],
      name: 'idx_user_whatsapp_queue_queue_id',
    });

    await queryInterface.addIndex('UserWhatsappQueues', {
      fields: ['isActive'],
      name: 'idx_user_whatsapp_queue_active',
    });
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.dropTable('UserWhatsappQueues');
  }
};
