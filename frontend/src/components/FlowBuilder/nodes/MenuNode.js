import React, { memo } from "react";
import { Handle, Position } from "reactflow";
import { makeStyles } from "@material-ui/core/styles";
import { Typography, Paper } from "@material-ui/core";
import ListIcon from "@material-ui/icons/List";

const useStyles = makeStyles((theme) => ({
  node: {
    padding: 12,
    borderRadius: 8,
    border: `2px solid #00bcd4`,
    background: theme.palette.type === "dark" ? "#1a3336" : "#e0f7fa",
    minWidth: 180,
  },
  header: {
    display: "flex",
    alignItems: "center",
    gap: 6,
    marginBottom: 6,
    fontWeight: 600,
    color: "#00838f",
  },
  icon: {
    fontSize: 18,
    color: "#00bcd4",
  },
  option: {
    fontSize: 12,
    padding: "3px 8px",
    margin: "2px 0",
    background: theme.palette.type === "dark" ? "#263238" : "#fff",
    borderRadius: 4,
    border: "1px solid #ddd",
    display: "flex",
    justifyContent: "space-between",
    alignItems: "center",
  },
  optionKey: {
    fontWeight: 600,
    color: "#00bcd4",
    marginRight: 8,
  },
}));

const MenuNode = memo(({ data }) => {
  const classes = useStyles();
  const options = data?.options || [
    { key: "1", text: "Opção 1" },
    { key: "2", text: "Opção 2" },
  ];

  return (
    <Paper className={classes.node} elevation={2}>
      <Handle type="target" position={Position.Top} />
      <div className={classes.header}>
        <ListIcon className={classes.icon} />
        <Typography variant="subtitle2">Menu</Typography>
      </div>
      {data?.title && (
        <Typography variant="caption" style={{ marginBottom: 4, display: "block" }}>
          {data.title}
        </Typography>
      )}
      {options.map((opt, idx) => (
        <div key={idx} className={classes.option}>
          <span>
            <span className={classes.optionKey}>{opt.key}</span>
            {opt.text}
          </span>
        </div>
      ))}
      {options.map((opt, idx) => (
        <Handle
          key={idx}
          type="source"
          position={Position.Bottom}
          id={`opt-${opt.key}`}
          style={{ left: `${((idx + 1) / (options.length + 1)) * 100}%` }}
        />
      ))}
    </Paper>
  );
});

MenuNode.displayName = "MenuNode";
export default MenuNode;
