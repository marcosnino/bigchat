import StartNode from "./StartNode";
import MessageNode from "./MessageNode";
import ConditionNode from "./ConditionNode";
import DelayNode from "./DelayNode";
import MenuNode from "./MenuNode";
import TransferNode from "./TransferNode";
import WaitInputNode from "./WaitInputNode";
import TagNode from "./TagNode";
import WebhookNode from "./WebhookNode";
import CloseNode from "./CloseNode";
import OpenAINode from "./OpenAINode";

export const nodeTypes = {
  start: StartNode,
  message: MessageNode,
  condition: ConditionNode,
  delay: DelayNode,
  menu: MenuNode,
  transfer: TransferNode,
  waitInput: WaitInputNode,
  tag: TagNode,
  webhook: WebhookNode,
  close: CloseNode,
  openai: OpenAINode,
};

export const nodeCategories = [
  {
    label: "Básico",
    nodes: [
      { type: "message", label: "Mensagem", icon: "ChatBubbleOutline", color: "#2196f3" },
      { type: "menu", label: "Menu de Opções", icon: "List", color: "#00bcd4" },
      { type: "waitInput", label: "Aguardar Resposta", icon: "HourglassEmpty", color: "#607d8b" },
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

export {
  StartNode,
  MessageNode,
  ConditionNode,
  DelayNode,
  MenuNode,
  TransferNode,
  WaitInputNode,
  TagNode,
  WebhookNode,
  CloseNode,
  OpenAINode,
};
