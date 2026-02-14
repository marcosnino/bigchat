import React, { memo } from "react";
import { Handle, Position } from "reactflow";
import { makeStyles } from "@material-ui/core/styles";
import { Typography, Paper } from "@material-ui/core";
import TimerIcon from "@material-ui/icons/Timer";

const useStyles = makeStyles((theme) => ({
  node: {
    padding: 12,
    borderRadius: 8,
    border: `2px solid #9c27b0`,
    background: theme.palette.type === "dark" ? "#2a1533" : "#f3e5f5",
    minWidth: 150,
    textAlign: "center",
  },
  header: {
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    gap: 6,
    marginBottom: 4,
    fontWeight: 600,
    color: "#7b1fa2",
  },
  icon: {
    fontSize: 18,
    color: "#9c27b0",
  },
  time: {
    fontSize: 14,
    fontWeight: 600,
    color: theme.palette.text.primary,
  },
}));

const formatDelay = (seconds) => {
  if (!seconds) return "0s";
  if (seconds < 60) return `${seconds}s`;
  if (seconds < 3600) return `${Math.floor(seconds / 60)}min`;
  return `${Math.floor(seconds / 3600)}h ${Math.floor((seconds % 3600) / 60)}min`;
};

const DelayNode = memo(({ data }) => {
  const classes = useStyles();
  return (
    <Paper className={classes.node} elevation={2}>
      <Handle type="target" position={Position.Top} />
      <div className={classes.header}>
        <TimerIcon className={classes.icon} />
        <Typography variant="subtitle2">Delay</Typography>
      </div>
      <Typography className={classes.time}>
        {formatDelay(data?.seconds)}
      </Typography>
      <Handle type="source" position={Position.Bottom} />
    </Paper>
  );
});

DelayNode.displayName = "DelayNode";
export default DelayNode;
