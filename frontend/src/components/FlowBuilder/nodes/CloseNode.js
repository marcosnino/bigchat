import React, { memo } from "react";
import { Handle, Position } from "reactflow";
import { makeStyles } from "@material-ui/core/styles";
import { Typography, Paper } from "@material-ui/core";
import StopIcon from "@material-ui/icons/Stop";

const useStyles = makeStyles((theme) => ({
  node: {
    padding: 12,
    borderRadius: 8,
    border: `2px solid ${theme.palette.error.main}`,
    background: theme.palette.type === "dark" ? "#3b1515" : "#ffebee",
    minWidth: 140,
    textAlign: "center",
  },
  header: {
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    gap: 6,
    fontWeight: 600,
    color: theme.palette.error.dark,
  },
  icon: {
    fontSize: 20,
    color: theme.palette.error.main,
  },
  message: {
    fontSize: 12,
    marginTop: 4,
    color: theme.palette.text.secondary,
    fontStyle: "italic",
  },
}));

const CloseNode = memo(({ data }) => {
  const classes = useStyles();
  return (
    <Paper className={classes.node} elevation={2}>
      <Handle type="target" position={Position.Top} />
      <div className={classes.header}>
        <StopIcon className={classes.icon} />
        <Typography variant="subtitle2">Encerrar</Typography>
      </div>
      {data?.farewellMessage && (
        <Typography className={classes.message}>
          {data.farewellMessage}
        </Typography>
      )}
    </Paper>
  );
});

CloseNode.displayName = "CloseNode";
export default CloseNode;
