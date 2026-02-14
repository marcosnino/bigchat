import React, { memo } from "react";
import { Handle, Position } from "reactflow";
import { makeStyles } from "@material-ui/core/styles";
import { Typography, Paper } from "@material-ui/core";
import ChatBubbleOutlineIcon from "@material-ui/icons/ChatBubbleOutline";

const useStyles = makeStyles((theme) => ({
  node: {
    padding: 12,
    borderRadius: 8,
    border: `2px solid ${theme.palette.primary.main}`,
    background: theme.palette.type === "dark" ? "#1e3a5f" : "#e3f2fd",
    minWidth: 180,
    maxWidth: 260,
  },
  header: {
    display: "flex",
    alignItems: "center",
    gap: 6,
    marginBottom: 6,
    fontWeight: 600,
    color: theme.palette.primary.main,
  },
  icon: {
    fontSize: 18,
    color: theme.palette.primary.main,
  },
  messageText: {
    fontSize: 12,
    padding: "6px 8px",
    background: theme.palette.type === "dark" ? "#263238" : "#fff",
    borderRadius: 6,
    border: "1px solid #ddd",
    wordBreak: "break-word",
    whiteSpace: "pre-wrap",
    maxHeight: 80,
    overflow: "hidden",
  },
}));

const MessageNode = memo(({ data }) => {
  const classes = useStyles();
  return (
    <Paper className={classes.node} elevation={2}>
      <Handle type="target" position={Position.Top} />
      <div className={classes.header}>
        <ChatBubbleOutlineIcon className={classes.icon} />
        <Typography variant="subtitle2">Mensagem</Typography>
      </div>
      <div className={classes.messageText}>
        {data?.message || "Clique para editar..."}
      </div>
      <Handle type="source" position={Position.Bottom} />
    </Paper>
  );
});

MessageNode.displayName = "MessageNode";
export default MessageNode;
