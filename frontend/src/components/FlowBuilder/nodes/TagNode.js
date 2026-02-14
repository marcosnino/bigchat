import React, { memo } from "react";
import { Handle, Position } from "reactflow";
import { makeStyles } from "@material-ui/core/styles";
import { Typography, Paper } from "@material-ui/core";
import LocalOfferIcon from "@material-ui/icons/LocalOffer";

const useStyles = makeStyles((theme) => ({
  node: {
    padding: 12,
    borderRadius: 8,
    border: `2px solid #4caf50`,
    background: theme.palette.type === "dark" ? "#1b3a1d" : "#e8f5e9",
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
    color: "#2e7d32",
  },
  icon: {
    fontSize: 18,
    color: "#4caf50",
  },
  tagName: {
    fontSize: 12,
    fontWeight: 500,
    color: theme.palette.text.primary,
    padding: "2px 8px",
    borderRadius: 12,
    background: theme.palette.type === "dark" ? "#263238" : "#c8e6c9",
    display: "inline-block",
  },
}));

const TagNode = memo(({ data }) => {
  const classes = useStyles();
  return (
    <Paper className={classes.node} elevation={2}>
      <Handle type="target" position={Position.Top} />
      <div className={classes.header}>
        <LocalOfferIcon className={classes.icon} />
        <Typography variant="subtitle2">Tag</Typography>
      </div>
      <span className={classes.tagName}>
        {data?.tagName || "Selecionar tag"}
      </span>
      <Handle type="source" position={Position.Bottom} />
    </Paper>
  );
});

TagNode.displayName = "TagNode";
export default TagNode;
