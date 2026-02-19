import sequelize from "../database";
import Queue from "../models/Queue";
import User from "../models/User";
import Ticket from "../models/Ticket";
import UserWhatsappQueue from "../models/UserWhatsappQueue";

const getNextQueueUser = async (
  queueId: number,
  whatsappId?: number
): Promise<number | null> => {
  return sequelize.transaction(async (transaction) => {
    const queue = await Queue.findByPk(queueId, {
      include: [
        {
          model: User,
          as: "users",
          attributes: ["id", "online", "profile"],
          through: { attributes: [] }
        }
      ],
      transaction
      // Removido lock: transaction.LOCK.UPDATE
      // FOR UPDATE não funciona com LEFT JOIN no PostgreSQL
    });

    if (!queue || !queue.users || queue.users.length === 0) {
      return null;
    }

    let users = [...queue.users]
      .filter(user => user.online && user.profile !== "admin")
      .sort((a, b) => a.id - b.id);

    if (whatsappId && users.length > 0) {
      const userWhatsappQueues = await UserWhatsappQueue.findAll({
        where: {
          queueId,
          whatsappId,
          isActive: true
        },
        transaction
      });

      if (userWhatsappQueues.length > 0) {
        const linkedUserIds = userWhatsappQueues.map(uwq => uwq.userId);
        const linkedUsers = users.filter(user => linkedUserIds.includes(user.id));
        if (linkedUsers.length > 0) {
          users = linkedUsers;
        }
      }
    }

    if (users.length === 0) {
      users = [...queue.users]
        .filter(user => user.online)
        .sort((a, b) => a.id - b.id);
    }

    if (users.length === 0) {
      return null;
    }

    let nextUser = users[0];

    if (queue.lastAssignedUserId) {
      const lastIndex = users.findIndex(
        (user) => user.id === queue.lastAssignedUserId
      );
      if (lastIndex >= 0) {
        nextUser = users[(lastIndex + 1) % users.length];
      }
    }

    const ticketCounts = await Promise.all(
      users.map(async (user) => {
        const count = await Ticket.count({
          where: {
            userId: user.id,
            status: "open"
          },
          transaction
        });
        return { userId: user.id, count };
      })
    );

    const minTickets = Math.min(...ticketCounts.map(tc => tc.count));
    const leastBusyUserIds = ticketCounts
      .filter(tc => tc.count === minTickets)
      .map(tc => tc.userId);

    if (!leastBusyUserIds.includes(nextUser.id)) {
      const leastBusyUser = users.find(u => leastBusyUserIds.includes(u.id));
      if (leastBusyUser) {
        nextUser = leastBusyUser;
      }
    }

    await queue.update(
      { lastAssignedUserId: nextUser.id },
      { transaction }
    );

    return nextUser.id;
  });
};

export default getNextQueueUser;
