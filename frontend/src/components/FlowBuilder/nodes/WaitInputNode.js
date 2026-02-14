import React, { memo } from "react";
import { Handle, Position } from "reactflow";
import { makeStyles } from "@material-ui/core/styles";
import { Typography, Paper } from "@material-ui/core";
import HourglassEmptyIcon from "@material-ui/icons/HourglassEmpty";

const useStyles = makeStyles((theme) => ({
  node: {
    padding: 12,
    borderRadius: 8,
    border: `2px solid #607d8b`,
    background: theme.palette.type === "dark" ? "#263238" : "#eceff1",
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
    color: "#37474f",
  },
  icon: {
    fontSize: 18,
    color: "#607d8b",
  },
  detail: {
    fontSize: 12,
    color: theme.palette.text.secondary,
  },
}));

const WaitInputNode = memo(({ data }) => {
  const classes = useStyles();
  return (
    <Paper className={classes.node} elevation={2}>
      <Handle type="target" position={Position.Top} />
      <div className={classes.header}>
        <HourglassEmptyIcon className={classes.icon} />
        <Typography variant="subtitle2">Aguardar Resposta</Typography>
      </div>
      <Typography className={classes.detail}>
        {data?.timeout ? `Timeout: ${data.timeout}s` : "Sem timeout"}
      </Typography>
      <Handle
        type="source"
        position={Position.Bottom}
        id="response"
        style={{ left: "30%" }}
      />
      <Handle
        type="source"
        position={Position.Bottom}
        id="timeout"
        style={{ left: "70%" }}
      />
    </Paper>
  );
});

WaitInputNode.displayName = "WaitInputNode";
export default WaitInputNode;
