import {
  Table,
  Column,
  CreatedAt,
  UpdatedAt,
  Model,
  PrimaryKey,
  AutoIncrement,
  AllowNull,
  Default,
  ForeignKey,
  BelongsTo
} from "sequelize-typescript";
import Queue from "./Queue";
import Company from "./Company";

@Table
class CloseReason extends Model<CloseReason> {
  @PrimaryKey
  @AutoIncrement
  @Column
  id: number;

  @AllowNull(false)
  @Column
  name: string;

  @AllowNull(true)
  @Column
  description: string;

  @Default(true)
  @Column
  isActive: boolean;

  @ForeignKey(() => Queue)
  @AllowNull(true)
  @Column
  queueId: number | null;

  @BelongsTo(() => Queue)
  queue: Queue;

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

export default CloseReason;
