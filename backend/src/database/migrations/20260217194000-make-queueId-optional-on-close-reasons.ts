import { QueryInterface, DataTypes } from "sequelize";

module.exports = {
  up: async (queryInterface: QueryInterface) => {
    await queryInterface.sequelize.query(
      'ALTER TABLE "CloseReasons" DROP CONSTRAINT IF EXISTS "CloseReasons_queueId_fkey";'
    );

    await queryInterface.changeColumn("CloseReasons", "queueId", {
      type: DataTypes.INTEGER,
      allowNull: true
    });

    await queryInterface.sequelize.query(
      'ALTER TABLE "CloseReasons" ADD CONSTRAINT "CloseReasons_queueId_fkey" FOREIGN KEY ("queueId") REFERENCES "Queues" (id) ON UPDATE CASCADE ON DELETE SET NULL;'
    );

    await queryInterface.sequelize.query(
      'UPDATE "CloseReasons" SET "queueId" = NULL;'
    );
  },

  down: async (queryInterface: QueryInterface) => {
    await queryInterface.sequelize.query(
      'ALTER TABLE "CloseReasons" DROP CONSTRAINT IF EXISTS "CloseReasons_queueId_fkey";'
    );

    await queryInterface.sequelize.query(`
      UPDATE "CloseReasons" cr
      SET "queueId" = q.id
      FROM (
        SELECT q1."companyId", MIN(q1.id) AS id
        FROM "Queues" q1
        GROUP BY q1."companyId"
      ) q
      WHERE cr."queueId" IS NULL
        AND q."companyId" = cr."companyId";
    `);

    await queryInterface.changeColumn("CloseReasons", "queueId", {
      type: DataTypes.INTEGER,
      allowNull: false
    });

    await queryInterface.sequelize.query(
      'ALTER TABLE "CloseReasons" ADD CONSTRAINT "CloseReasons_queueId_fkey" FOREIGN KEY ("queueId") REFERENCES "Queues" (id) ON UPDATE CASCADE ON DELETE CASCADE;'
    );
  }
};
