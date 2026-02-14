/**
 * UserWhatsappQueue Model
 * Relacionamento ternário entre Usuário, Número WhatsApp e Fila
 * Permite designar qual usuário atende qual fila em qual número
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
  ForeignKey,
  BelongsTo,
  Default,
  DataType,
  AllowNull
} from "sequelize-typescript";
import User from "./User";
import Whatsapp from "./Whatsapp";
import Queue from "./Queue";

@Table
class UserWhatsappQueue extends Model<UserWhatsappQueue> {
  @ForeignKey(() => User)
  @Column
  userId: number;

  @BelongsTo(() => User)
  user: User;

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

  @Default(true)
  @Column
  isActive: boolean;

  @AllowNull
  @Column(DataType.TEXT)
  notes: string;

  @CreatedAt
  createdAt: Date;

  @UpdatedAt
  updatedAt: Date;
}

export default UserWhatsappQueue;
