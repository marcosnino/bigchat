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
import Asterisk from "./Asterisk";

export type ExtensionStatus =
  | "available"
  | "busy"
  | "ringing"
  | "unavailable"
  | "dnd"
  | "CONNECTED"
  | "DISCONNECTED";

@Table
class Extension extends Model<Extension> {
  @PrimaryKey
  @AutoIncrement
  @Column
  id: number;

  @AllowNull(false)
  @Column(DataType.STRING)
  exten: string;

  @AllowNull
  @Column(DataType.STRING)
  name: string;

  @AllowNull
  @Column(DataType.STRING)
  password: string;

  @AllowNull
  @Column(DataType.STRING)
  callerIdName: string;

  @AllowNull
  @Column(DataType.STRING)
  callerIdNumber: string;

  @Default("DISCONNECTED")
  @Column(DataType.STRING)
  status: string;

  @Default(true)
  @Column(DataType.BOOLEAN)
  isActive: boolean;

  @Default(false)
  @Column(DataType.BOOLEAN)
  canRecord: boolean;

  @Default(true)
  @Column(DataType.BOOLEAN)
  webrtcEnabled: boolean;

  @AllowNull
  @Column(DataType.STRING)
  transport: string;

  @AllowNull
  @Column(DataType.STRING)
  context: string;

  @AllowNull
  @Column(DataType.STRING)
  codecs: string;

  @Default(1)
  @Column(DataType.INTEGER)
  maxContacts: number;

  @AllowNull
  @Column(DataType.TEXT)
  notes: string;

  @ForeignKey(() => Asterisk)
  @Column
  asteriskId: number;

  @BelongsTo(() => Asterisk)
  asterisk: Asterisk;

  @ForeignKey(() => User)
  @AllowNull
  @Column
  userId: number;

  @BelongsTo(() => User)
  user: User;

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

export default Extension;
