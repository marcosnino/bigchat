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
  BelongsTo,
  HasMany
} from "sequelize-typescript";
import Company from "./Company";
import Call from "./Call";

@Table
class Asterisk extends Model<Asterisk> {
  @PrimaryKey
  @AutoIncrement
  @Column
  id: number;

  @AllowNull(false)
  @Column(DataType.STRING)
  name: string;

  @AllowNull(false)
  @Column(DataType.STRING)
  host: string;

  @Default(8088)
  @Column(DataType.INTEGER)
  ariPort: number;

  @Default(5060)
  @Column(DataType.INTEGER)
  sipPort: number;

  @Default(8089)
  @Column(DataType.INTEGER)
  wsPort: number;

  @AllowNull(false)
  @Column(DataType.STRING)
  ariUser: string;

  @AllowNull(false)
  @Column(DataType.STRING)
  ariPassword: string;

  @AllowNull
  @Column(DataType.STRING)
  ariApplication: string;

  @Default("DISCONNECTED")
  @Column(DataType.STRING)
  status: string;

  @Default(false)
  @Column(DataType.BOOLEAN)
  isActive: boolean;

  @Default(false)
  @Column(DataType.BOOLEAN)
  useSSL: boolean;

  @AllowNull
  @Column(DataType.STRING)
  sipDomain: string;

  @AllowNull
  @Column(DataType.STRING)
  outboundContext: string;

  @Default("from-internal")
  @Column(DataType.STRING)
  inboundContext: string;

  @AllowNull
  @Column(DataType.TEXT)
  notes: string;

  @ForeignKey(() => Company)
  @Column
  companyId: number;

  @BelongsTo(() => Company)
  company: Company;

  @HasMany(() => Call)
  calls: Call[];

  @CreatedAt
  createdAt: Date;

  @UpdatedAt
  updatedAt: Date;
}

export default Asterisk;
