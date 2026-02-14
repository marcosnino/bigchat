import React, { memo } from "react";
import { Handle, Position } from "reactflow";
import { makeStyles } from "@material-ui/core/styles";
import { Typography, Paper } from "@material-ui/core";
import CallSplitIcon from "@material-ui/icons/CallSplit";

const useStyles = makeStyles((theme) => ({
  node: {
    padding: 12,
    borderRadius: 8,
    border: `2px solid #ff9800`,
    background: theme.palette.type === "dark" ? "#3e2723" : "#fff3e0",
    minWidth: 180,
  },
  header: {
    display: "flex",
    alignItems: "center",
    gap: 6,
    marginBottom: 6,
    fontWeight: 600,
    color: "#e65100",
  },
  icon: {
    fontSize: 18,
    color: "#ff9800",
  },
  condition: {
    fontSize: 12,
    padding: "4px 8px",
    background: theme.palette.type === "dark" ? "#263238" : "#fff",
    borderRadius: 4,
    border: "1px solid #ddd",
    marginBottom: 4,
  },
  outputs: {
    display: "flex",
    justifyContent: "space-between",
    marginTop: 8,
    fontSize: 11,
  },
  yesLabel: {
    color: theme.palette.success.main,
    fontWeight: 600,
  },
  noLabel: {
    color: theme.palette.error.main,
    fontWeight: 600,
  },
}));

const ConditionNode = memo(({ data }) => {
  const classes = useStyles();
  return (
    <Paper className={classes.node} elevation={2}>
      <Handle type="target" position={Position.Top} />
      <div className={classes.header}>
        <CallSplitIcon className={classes.icon} />
        <Typography variant="subtitle2">Condição</Typography>
      </div>
      <div className={classes.condition}>
        {data?.condition || "Clique para definir..."}
      </div>
      <div className={classes.outputs}>
        <span className={classes.yesLabel}>✓ Sim</span>
        <span className={classes.noLabel}>✗ Não</span>
      </div>
      <Handle
        type="source"
        position={Position.Bottom}
        id="yes"
        style={{ left: "30%" }}
      />
      <Handle
        type="source"
        position={Position.Bottom}
        id="no"
        style={{ left: "70%" }}
      />
    </Paper>
  );
});

ConditionNode.displayName = "ConditionNode";
export default ConditionNode;
