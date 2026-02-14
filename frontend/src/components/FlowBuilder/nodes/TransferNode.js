import React, { memo } from "react";
import { Handle, Position } from "reactflow";
import { makeStyles } from "@material-ui/core/styles";
import { Typography, Paper } from "@material-ui/core";
import SwapHorizIcon from "@material-ui/icons/SwapHoriz";

const useStyles = makeStyles((theme) => ({
  node: {
    padding: 12,
    borderRadius: 8,
    border: `2px solid #2196f3`,
    background: theme.palette.type === "dark" ? "#0d2137" : "#e3f2fd",
    minWidth: 160,
    textAlign: "center",
  },
  header: {
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    gap: 6,
    marginBottom: 4,
    fontWeight: 600,
    color: "#1565c0",
  },
  icon: {
    fontSize: 18,
    color: "#2196f3",
  },
  detail: {
    fontSize: 12,
    color: theme.palette.text.secondary,
  },
}));

const TransferNode = memo(({ data }) => {
  const classes = useStyles();
  return (
    <Paper className={classes.node} elevation={2}>
      <Handle type="target" position={Position.Top} />
      <div className={classes.header}>
        <SwapHorizIcon className={classes.icon} />
        <Typography variant="subtitle2">Transferir</Typography>
      </div>
      <Typography className={classes.detail}>
        {data?.queueName || data?.userName || "Fila/Atendente"}
      </Typography>
      <Handle type="source" position={Position.Bottom} />
    </Paper>
  );
});

TransferNode.displayName = "TransferNode";
export default TransferNode;
