import React, { memo } from "react";
import { Handle, Position } from "reactflow";
import { makeStyles } from "@material-ui/core/styles";
import { Typography, Paper } from "@material-ui/core";

const useStyles = makeStyles((theme) => ({
  node: {
    padding: 12,
    borderRadius: 8,
    border: `2px solid #673ab7`,
    background: theme.palette.type === "dark" ? "#1a0e2e" : "#ede7f6",
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
    color: "#4527a0",
  },
  icon: {
    fontSize: 16,
    fontWeight: 700,
  },
  detail: {
    fontSize: 12,
    color: theme.palette.text.secondary,
  },
}));

const OpenAINode = memo(({ data }) => {
  const classes = useStyles();
  return (
    <Paper className={classes.node} elevation={2}>
      <Handle type="target" position={Position.Top} />
      <div className={classes.header}>
        <span className={classes.icon}>AI</span>
        <Typography variant="subtitle2">OpenAI</Typography>
      </div>
      <Typography className={classes.detail}>
        {data?.promptName || data?.prompt?.substring(0, 50) || "Configurar prompt"}
      </Typography>
      <Handle type="source" position={Position.Bottom} />
    </Paper>
  );
});

OpenAINode.displayName = "OpenAINode";
export default OpenAINode;
