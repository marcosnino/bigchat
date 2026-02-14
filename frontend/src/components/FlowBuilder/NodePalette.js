import React from "react";
import { makeStyles } from "@material-ui/core/styles";
import { Typography, Paper, Divider } from "@material-ui/core";
import ChatBubbleOutlineIcon from "@material-ui/icons/ChatBubbleOutline";
import ListIcon from "@material-ui/icons/List";
import HourglassEmptyIcon from "@material-ui/icons/HourglassEmpty";
import TimerIcon from "@material-ui/icons/Timer";
import CallSplitIcon from "@material-ui/icons/CallSplit";
import LocalOfferIcon from "@material-ui/icons/LocalOffer";
import SwapHorizIcon from "@material-ui/icons/SwapHoriz";
import StopIcon from "@material-ui/icons/Stop";
import HttpIcon from "@material-ui/icons/Http";

const useStyles = makeStyles((theme) => ({
  palette: {
    width: 200,
    padding: theme.spacing(1),
    borderRight: `1px solid ${theme.palette.divider}`,
    background: theme.palette.background.paper,
    overflow: "auto",
    height: "100%",
  },
  title: {
    fontWeight: 600,
    fontSize: 13,
    padding: "8px 8px 4px",
    color: theme.palette.text.secondary,
    textTransform: "uppercase",
    letterSpacing: 0.5,
  },
  nodeItem: {
    display: "flex",
    alignItems: "center",
    gap: 8,
    padding: "8px 10px",
    margin: "3px 4px",
    borderRadius: 6,
    cursor: "grab",
    fontSize: 13,
    transition: "all 0.15s",
    border: "1px solid transparent",
    "&:hover": {
      background: theme.palette.action.hover,
      border: `1px solid ${theme.palette.divider}`,
    },
    "&:active": {
      cursor: "grabbing",
    },
  },
  iconWrap: {
    width: 28,
    height: 28,
    borderRadius: 6,
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    flexShrink: 0,
  },
  icon: {
    fontSize: 16,
    color: "#fff",
  },
  aiIcon: {
    fontSize: 12,
    fontWeight: 700,
    color: "#fff",
  },
}));

const iconMap = {
  ChatBubbleOutline: ChatBubbleOutlineIcon,
  List: ListIcon,
  HourglassEmpty: HourglassEmptyIcon,
  Timer: TimerIcon,
  CallSplit: CallSplitIcon,
  LocalOffer: LocalOfferIcon,
  SwapHoriz: SwapHorizIcon,
  Stop: StopIcon,
  Http: HttpIcon,
};

const categories = [
  {
    label: "Básico",
    nodes: [
      { type: "message", label: "Mensagem", icon: "ChatBubbleOutline", color: "#2196f3" },
      { type: "menu", label: "Menu Opções", icon: "List", color: "#00bcd4" },
      { type: "waitInput", label: "Aguardar Resp.", icon: "HourglassEmpty", color: "#607d8b" },
      { type: "delay", label: "Delay", icon: "Timer", color: "#9c27b0" },
    ],
  },
  {
    label: "Lógica",
    nodes: [
      { type: "condition", label: "Condição", icon: "CallSplit", color: "#ff9800" },
      { type: "tag", label: "Aplicar Tag", icon: "LocalOffer", color: "#4caf50" },
    ],
  },
  {
    label: "Ações",
    nodes: [
      { type: "transfer", label: "Transferir", icon: "SwapHoriz", color: "#2196f3" },
      { type: "close", label: "Encerrar", icon: "Stop", color: "#f44336" },
    ],
  },
  {
    label: "Integrações",
    nodes: [
      { type: "webhook", label: "Webhook", icon: "Http", color: "#795548" },
      { type: "openai", label: "OpenAI", icon: "AI", color: "#673ab7" },
    ],
  },
];

const NodePalette = () => {
  const classes = useStyles();

  const onDragStart = (event, nodeType) => {
    event.dataTransfer.setData("application/reactflow", nodeType);
    event.dataTransfer.effectAllowed = "move";
  };

  return (
    <div className={classes.palette}>
      <Typography
        variant="subtitle2"
        style={{ padding: "12px 8px 8px", fontWeight: 700 }}
      >
        Componentes
      </Typography>
      <Divider style={{ marginBottom: 4 }} />
      {categories.map((cat, catIdx) => (
        <div key={catIdx}>
          <Typography className={classes.title}>{cat.label}</Typography>
          {cat.nodes.map((node) => {
            const IconComponent = iconMap[node.icon];
            return (
              <Paper
                key={node.type}
                className={classes.nodeItem}
                elevation={0}
                draggable
                onDragStart={(e) => onDragStart(e, node.type)}
              >
                <div
                  className={classes.iconWrap}
                  style={{ background: node.color }}
                >
                  {IconComponent ? (
                    <IconComponent className={classes.icon} />
                  ) : (
                    <span className={classes.aiIcon}>{node.icon}</span>
                  )}
                </div>
                <span>{node.label}</span>
              </Paper>
            );
          })}
        </div>
      ))}
    </div>
  );
};

export default NodePalette;
