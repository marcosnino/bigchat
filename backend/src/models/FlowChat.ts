import {
  Table,
  Column,
  CreatedAt,
  UpdatedAt,
  Model,
  PrimaryKey,
  AutoIncrement,
  ForeignKey,
  BelongsTo,
  DataType
} from "sequelize-typescript";
import Company from "./Company";

@Table({ tableName: "FlowChats" })
class FlowChat extends Model<FlowChat> {
  @PrimaryKey
  @AutoIncrement
  @Column
  id: number;

  @Column
  name: string;

  @Column({ defaultValue: "inactive" })
  status: string;

  @Column({ defaultValue: "keyword" })
  trigger: string;

  @Column(DataType.JSONB)
  triggerCondition: any;

  @Column(DataType.JSONB)
  nodes: any;

  @Column(DataType.JSONB)
  edges: any;

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

export default FlowChat;
