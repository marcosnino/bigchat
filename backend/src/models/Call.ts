import {
  Table,
  Column,
  CreatedAt,
  UpdatedAt,
  Model,
  DataType,
  PrimaryKey,
  AutoIncrement,
  Default,
  AllowNull,
  ForeignKey,
  BelongsTo
} from "sequelize-typescript";
import Company from "./Company";
import User from "./User";
import Contact from "./Contact";
import Ticket from "./Ticket";
import Asterisk from "./Asterisk";

export type CallStatus =
  | "ringing"
  | "answered"
  | "busy"
  | "no-answer"
  | "failed"
  | "canceled"
  | "completed";

export type CallDirection = "inbound" | "outbound";

@Table
class Call extends Model<Call> {
  @PrimaryKey
  @AutoIncrement
  @Column
  id: number;

  @AllowNull(false)
  @Column(DataType.STRING)
  uniqueId: string;

  @AllowNull(false)
  @Column(DataType.STRING)
  caller: string;

  @AllowNull(false)
  @Column(DataType.STRING)
  called: string;

  @AllowNull
  @Column(DataType.STRING)
  callerName: string;

  @AllowNull
  @Column(DataType.STRING)
  calledName: string;

  @Default("inbound")
  @Column(DataType.ENUM("inbound", "outbound"))
  direction: CallDirection;

  @Default("ringing")
  @Column(
    DataType.ENUM(
      "ringing",
      "answered",
      "busy",
      "no-answer",
      "failed",
      "canceled",
      "completed"
    )
  )
  status: CallStatus;

  @AllowNull
  @Column(DataType.DATE)
  startedAt: Date;

  @AllowNull
  @Column(DataType.DATE)
  answeredAt: Date;

  @AllowNull
  @Column(DataType.DATE)
  endedAt: Date;

  @Default(0)
  @Column(DataType.INTEGER)
  duration: number;

  @Default(0)
  @Column(DataType.INTEGER)
  billableSeconds: number;

  @AllowNull
  @Column(DataType.STRING)
  hangupCause: string;

  @AllowNull
  @Column(DataType.INTEGER)
  hangupCode: number;

  @AllowNull
  @Column(DataType.STRING)
  recordingPath: string;

  @AllowNull
  @Column(DataType.STRING)
  recordingUrl: string;

  @AllowNull
  @Column(DataType.STRING)
  extension: string;

  @AllowNull
  @Column(DataType.STRING)
  queue: string;

  @AllowNull
  @Column(DataType.STRING)
  channel: string;

  @AllowNull
  @Column(DataType.STRING)
  linkedChannel: string;

  @AllowNull
  @Column(DataType.JSONB)
  metadata: Record<string, unknown>;

  @ForeignKey(() => Company)
  @Column
  companyId: number;

  @BelongsTo(() => Company)
  company: Company;

  @ForeignKey(() => User)
  @AllowNull
  @Column
  userId: number;

  @BelongsTo(() => User)
  user: User;

  @ForeignKey(() => Contact)
  @AllowNull
  @Column
  contactId: number;

  @BelongsTo(() => Contact)
  contact: Contact;

  @ForeignKey(() => Ticket)
  @AllowNull
  @Column
  ticketId: number;

  @BelongsTo(() => Ticket)
  ticket: Ticket;

  @ForeignKey(() => Asterisk)
  @Column
  asteriskId: number;

  @BelongsTo(() => Asterisk)
  asterisk: Asterisk;

  @CreatedAt
  createdAt: Date;

  @UpdatedAt
  updatedAt: Date;
}

export default Call;
