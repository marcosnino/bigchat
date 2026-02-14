/**
 * ClosedTicketHistory Model
 * Rastreia o histórico de tickets/chats que foram fechados
 * Permite análise e filtragem de chats encerrados
 * 
 * @author BigChat Development Team
 * @version 1.0.0
 */

import {
  Table,
  Column,
  CreatedAt,
  UpdatedAt,
  Model,
  PrimaryKey,
  ForeignKey,
  BelongsTo,
  AutoIncrement,
  Default,
  DataType,
  AllowNull
} from "sequelize-typescript";
import Ticket from "./Ticket";
import User from "./User";
import Contact from "./Contact";
import Whatsapp from "./Whatsapp";
import Queue from "./Queue";
import Company from "./Company";

@Table
class ClosedTicketHistory extends Model<ClosedTicketHistory> {
  @PrimaryKey
  @AutoIncrement
  @Column
  id: number;

  @ForeignKey(() => Ticket)
  @Column
  ticketId: number;

  @BelongsTo(() => Ticket)
  ticket: Ticket;

  @ForeignKey(() => User)
  @Column
  userId: number;

  @BelongsTo(() => User)
  user: User;

  @ForeignKey(() => Contact)
  @Column
  contactId: number;

  @BelongsTo(() => Contact)
  contact: Contact;

  @ForeignKey(() => Whatsapp)
  @Column
  whatsappId: number;

  @BelongsTo(() => Whatsapp)
  whatsapp: Whatsapp;

  @ForeignKey(() => Queue)
  @Column
  queueId: number;

  @BelongsTo(() => Queue)
  queue: Queue;

  // Data de abertura (snapshot do createdAt do ticket)
  @Column(DataType.DATE)
  ticketOpenedAt: Date;

  // Data de fechamento
  @Column(DataType.DATE)
  ticketClosedAt: Date;

  // Tempo total em segundos
  @Default(0)
  @Column
  durationSeconds: number;

  // Status final do ticket
  @Column
  finalStatus: string;

  // Motivo do fechamento (opcional)
  @AllowNull
  @Column(DataType.TEXT)
  closureReason: string;

  // Mensagens trocadas
  @Default(0)
  @Column
  totalMessages: number;

  // Classificação/Rating (se houver)
  @AllowNull
  @Column
  rating: number;

  // Feedback (se houver)
  @AllowNull
  @Column(DataType.TEXT)
  feedback: string;

  // Tags associadas
  @AllowNull
  @Column(DataType.JSON)
  tags: string[];

  // Quem fechou (user que encerrou)
  @AllowNull
  @Column
  closedByUserId: number;

  // Dados de semáforo (se houver)
  @AllowNull
  @Column(DataType.JSON)
  semaphoreData: {
    totalNewMessages: number;
    totalWaitingMessages: number;
    totalRepliedMessages: number;
  };

  @ForeignKey(() => Company)
  @Column
  companyId: number;

  @BelongsTo(() => Company)
  company: Company;

  @CreatedAt
  createdAt: Date;

  @UpdatedAt
  updatedAt: Date;
}

export default ClosedTicketHistory;
