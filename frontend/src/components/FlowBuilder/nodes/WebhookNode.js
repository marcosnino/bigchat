import React, { memo } from "react";
import { Handle, Position } from "reactflow";
import { makeStyles } from "@material-ui/core/styles";
import { Typography, Paper } from "@material-ui/core";
import HttpIcon from "@material-ui/icons/Http";

const useStyles = makeStyles((theme) => ({
  node: {
    padding: 12,
    borderRadius: 8,
    border: `2px solid #795548`,
    background: theme.palette.type === "dark" ? "#3e2723" : "#efebe9",
    minWidth: 180,
  },
  header: {
    display: "flex",
    alignItems: "center",
    gap: 6,
    marginBottom: 4,
    fontWeight: 600,
    color: "#4e342e",
  },
  icon: {
    fontSize: 18,
    color: "#795548",
  },
  detail: {
    fontSize: 11,
    padding: "3px 6px",
    background: theme.palette.type === "dark" ? "#263238" : "#fff",
    borderRadius: 4,
    border: "1px solid #ddd",
    fontFamily: "monospace",
    wordBreak: "break-all",
  },
  method: {
    fontSize: 11,
    fontWeight: 700,
    color: "#ff5722",
    marginRight: 4,
  },
}));

const WebhookNode = memo(({ data }) => {
  const classes = useStyles();
  return (
    <Paper className={classes.node} elevation={2}>
      <Handle type="target" position={Position.Top} />
      <div className={classes.header}>
        <HttpIcon className={classes.icon} />
        <Typography variant="subtitle2">Webhook</Typography>
      </div>
      <div className={classes.detail}>
        <span className={classes.method}>{data?.method || "POST"}</span>
        {data?.url || "https://..."}
      </div>
      <Handle type="source" position={Position.Bottom} />
    </Paper>
  );
});

WebhookNode.displayName = "WebhookNode";
export default WebhookNode;
