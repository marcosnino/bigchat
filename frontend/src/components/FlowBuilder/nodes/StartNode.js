import React, { memo } from "react";
import { Handle, Position } from "reactflow";
import { makeStyles } from "@material-ui/core/styles";
import { Typography, Paper } from "@material-ui/core";
import PlayArrowIcon from "@material-ui/icons/PlayArrow";

const useStyles = makeStyles((theme) => ({
  node: {
    padding: 12,
    borderRadius: 8,
    border: `2px solid ${theme.palette.success.main}`,
    background: theme.palette.success.light || "#e8f5e9",
    minWidth: 140,
    textAlign: "center",
  },
  header: {
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    gap: 6,
    fontWeight: 600,
    color: theme.palette.success.dark,
  },
  icon: {
    fontSize: 20,
    color: theme.palette.success.main,
  },
}));

const StartNode = memo(({ data }) => {
  const classes = useStyles();
  return (
    <Paper className={classes.node} elevation={2}>
      <div className={classes.header}>
        <PlayArrowIcon className={classes.icon} />
        <Typography variant="subtitle2">Início</Typography>
      </div>
      {data?.label && (
        <Typography variant="caption" color="textSecondary">
          {data.label}
        </Typography>
      )}
      <Handle type="source" position={Position.Bottom} />
    </Paper>
  );
});

StartNode.displayName = "StartNode";
export default StartNode;
