import React, { useState, useCallback, useRef, useEffect } from "react";
import { useParams, useHistory } from "react-router-dom";
import ReactFlow, {
  addEdge,
  useNodesState,
  useEdgesState,
  Controls,
  MiniMap,
  Background,
  MarkerType,
} from "reactflow";
import "reactflow/dist/style.css";
import { makeStyles } from "@material-ui/core/styles";
import {
  AppBar,
  Toolbar,
  Typography,
  Button,
  IconButton,
  TextField,
  Select,
  MenuItem,
  FormControl,
  InputLabel,
  Chip,
  CircularProgress,
} from "@material-ui/core";
import ArrowBackIcon from "@material-ui/icons/ArrowBack";
import SaveIcon from "@material-ui/icons/Save";
import PlayArrowIcon from "@material-ui/icons/PlayArrow";
import StopIcon from "@material-ui/icons/Stop";
import { nodeTypes } from "../../components/FlowBuilder/nodes";
import NodePalette from "../../components/FlowBuilder/NodePalette";
import NodePropertiesPanel from "../../components/FlowBuilder/NodePropertiesPanel";
import api from "../../services/api";
import { toast } from "react-toastify";
import toastError from "../../errors/toastError";

const useStyles = makeStyles((theme) => ({
  root: {
    display: "flex",
    flexDirection: "column",
    height: "100vh",
    width: "100%",
    overflow: "hidden",
  },
  appBar: {
    zIndex: theme.zIndex.drawer + 1,
  },
  toolbar: {
    display: "flex",
    justifyContent: "space-between",
    gap: 12,
  },
  titleSection: {
    display: "flex",
    alignItems: "center",
    gap: 12,
    flex: 1,
  },
  flowName: {
    "& .MuiInputBase-input": {
      color: "#fff",
      fontWeight: 600,
      fontSize: 16,
    },
    "& .MuiInput-underline:before": {
      borderBottomColor: "rgba(255,255,255,0.3)",
    },
    "& .MuiInput-underline:hover:before": {
      borderBottomColor: "rgba(255,255,255,0.6)",
    },
    "& .MuiInput-underline:after": {
      borderBottomColor: "#fff",
    },
    maxWidth: 250,
  },
  triggerSelect: {
    minWidth: 160,
    "& .MuiSelect-root": {
      color: "#fff",
    },
    "& .MuiInput-underline:before": {
      borderBottomColor: "rgba(255,255,255,0.3)",
    },
    "& .MuiInputLabel-root": {
      color: "rgba(255,255,255,0.7)",
    },
    "& .MuiSelect-icon": {
      color: "rgba(255,255,255,0.7)",
    },
  },
  actions: {
    display: "flex",
    alignItems: "center",
    gap: 8,
  },
  content: {
    display: "flex",
    flex: 1,
    overflow: "hidden",
  },
  flowArea: {
    flex: 1,
    height: "100%",
  },
  statusChip: {
    height: 24,
    fontWeight: 600,
  },
  saveBtn: {
    backgroundColor: "#4caf50",
    color: "#fff",
    "&:hover": {
      backgroundColor: "#388e3c",
    },
  },
}));

let nodeIdCounter = 1;
const getId = () => `node_${nodeIdCounter++}`;

const defaultEdgeOptions = {
  animated: true,
  style: { strokeWidth: 2 },
  markerEnd: { type: MarkerType.ArrowClosed },
};

const FlowBuilder = () => {
  const classes = useStyles();
  const { flowId } = useParams();
  const history = useHistory();
  const reactFlowWrapper = useRef(null);
  const [reactFlowInstance, setReactFlowInstance] = useState(null);

  const [nodes, setNodes, onNodesChange] = useNodesState([]);
  const [edges, setEdges, onEdgesChange] = useEdgesState([]);
  const [flowData, setFlowData] = useState(null);
  const [selectedNode, setSelectedNode] = useState(null);
  const [saving, setSaving] = useState(false);
  const [loading, setLoading] = useState(true);
  const [flowName, setFlowName] = useState("");
  const [trigger, setTrigger] = useState("keyword");
  const [triggerCondition, setTriggerCondition] = useState({ keywords: [] });
  const [status, setStatus] = useState("inactive");
  const [hasChanges, setHasChanges] = useState(false);

  // Load flow data
  useEffect(() => {
    const fetchFlow = async () => {
      try {
        const { data } = await api.get(`/flow-chats/${flowId}`);
        setFlowData(data);
        setFlowName(data.name);
        setTrigger(data.trigger || "keyword");
        setTriggerCondition(data.triggerCondition || { keywords: [] });
        setStatus(data.status);
        setNodes(data.nodes || []);
        setEdges(data.edges || []);

        // Set counter to avoid ID conflicts
        const maxId = (data.nodes || []).reduce((max, n) => {
          const num = parseInt(n.id.replace(/\D/g, "")) || 0;
          return Math.max(max, num);
        }, 0);
        nodeIdCounter = maxId + 1;
      } catch (err) {
        toastError(err);
        history.push("/flow-chats");
      }
      setLoading(false);
    };
    fetchFlow();
  }, [flowId, history, setNodes, setEdges]);

  // Track changes
  useEffect(() => {
    if (flowData) setHasChanges(true);
  }, [nodes, edges]);

  const onConnect = useCallback(
    (params) => {
      setEdges((eds) => addEdge({ ...params, ...defaultEdgeOptions }, eds));
    },
    [setEdges]
  );

  const onDragOver = useCallback((event) => {
    event.preventDefault();
    event.dataTransfer.dropEffect = "move";
  }, []);

  const onDrop = useCallback(
    (event) => {
      event.preventDefault();
      const type = event.dataTransfer.getData("application/reactflow");
      if (!type || !reactFlowInstance) return;

      const position = reactFlowInstance.screenToFlowPosition({
        x: event.clientX,
        y: event.clientY,
      });

      const defaultData = {};
      if (type === "message") defaultData.message = "";
      if (type === "menu")
        defaultData.options = [
          { key: "1", text: "Opção 1" },
          { key: "2", text: "Opção 2" },
        ];
      if (type === "delay") defaultData.seconds = 5;
      if (type === "condition") defaultData.condition = "";
      if (type === "waitInput") defaultData.timeout = 0;
      if (type === "webhook") {
        defaultData.method = "POST";
        defaultData.url = "";
      }
      if (type === "close") defaultData.farewellMessage = "";
      if (type === "openai") defaultData.prompt = "";

      const newNode = {
        id: getId(),
        type,
        position,
        data: defaultData,
      };

      setNodes((nds) => nds.concat(newNode));
    },
    [reactFlowInstance, setNodes]
  );

  const onNodeClick = useCallback((event, node) => {
    setSelectedNode(node);
  }, []);

  const onPaneClick = useCallback(() => {
    setSelectedNode(null);
  }, []);

  const handleUpdateNodeData = useCallback(
    (nodeId, newData) => {
      setNodes((nds) =>
        nds.map((n) => (n.id === nodeId ? { ...n, data: { ...newData } } : n))
      );
    },
    [setNodes]
  );

  const handleDeleteNode = useCallback(
    (nodeId) => {
      setNodes((nds) => nds.filter((n) => n.id !== nodeId));
      setEdges((eds) =>
        eds.filter((e) => e.source !== nodeId && e.target !== nodeId)
      );
      setSelectedNode(null);
    },
    [setNodes, setEdges]
  );

  const handleSave = async () => {
    setSaving(true);
    try {
      await api.put(`/flow-chats/${flowId}`, {
        name: flowName,
        trigger,
        triggerCondition,
        nodes,
        edges,
        status,
      });
      setHasChanges(false);
      toast.success("Fluxo salvo com sucesso!");
    } catch (err) {
      toastError(err);
    }
    setSaving(false);
  };

  const handleToggleStatus = async () => {
    const newStatus = status === "active" ? "inactive" : "active";
    try {
      await api.put(`/flow-chats/${flowId}`, {
        name: flowName,
        trigger,
        triggerCondition,
        nodes,
        edges,
        status: newStatus,
      });
      setStatus(newStatus);
      setHasChanges(false);
      toast.success(
        newStatus === "active" ? "Fluxo ativado!" : "Fluxo desativado!"
      );
    } catch (err) {
      toastError(err);
    }
  };

  if (loading) {
    return (
      <div
        style={{
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
          height: "100vh",
        }}
      >
        <CircularProgress />
      </div>
    );
  }

  return (
    <div className={classes.root}>
      <AppBar position="relative" className={classes.appBar}>
        <Toolbar variant="dense" className={classes.toolbar}>
          <div className={classes.titleSection}>
            <IconButton
              edge="start"
              color="inherit"
              onClick={() => history.push("/flow-chats")}
            >
              <ArrowBackIcon />
            </IconButton>
            <TextField
              className={classes.flowName}
              value={flowName}
              onChange={(e) => {
                setFlowName(e.target.value);
                setHasChanges(true);
              }}
              placeholder="Nome do fluxo"
            />
            <FormControl className={classes.triggerSelect}>
              <InputLabel>Gatilho</InputLabel>
              <Select
                value={trigger}
                onChange={(e) => {
                  setTrigger(e.target.value);
                  setHasChanges(true);
                }}
              >
                <MenuItem value="keyword">Palavra-chave</MenuItem>
                <MenuItem value="newConversation">Nova conversa</MenuItem>
                <MenuItem value="queueAssignment">Atribuição de fila</MenuItem>
                <MenuItem value="manual">Manual</MenuItem>
              </Select>
            </FormControl>
            <Chip
              size="small"
              label={status === "active" ? "ATIVO" : "INATIVO"}
              className={classes.statusChip}
              style={{
                backgroundColor:
                  status === "active" ? "#4caf50" : "#9e9e9e",
                color: "#fff",
              }}
            />
          </div>
          <div className={classes.actions}>
            {hasChanges && (
              <Typography
                variant="caption"
                style={{ color: "#ffeb3b", marginRight: 8 }}
              >
                Alterações não salvas
              </Typography>
            )}
            <Button
              size="small"
              variant={status === "active" ? "outlined" : "contained"}
              color={status === "active" ? "inherit" : "default"}
              startIcon={
                status === "active" ? <StopIcon /> : <PlayArrowIcon />
              }
              onClick={handleToggleStatus}
              style={
                status === "active"
                  ? { color: "#fff", borderColor: "rgba(255,255,255,0.5)" }
                  : {}
              }
            >
              {status === "active" ? "Desativar" : "Ativar"}
            </Button>
            <Button
              size="small"
              variant="contained"
              className={classes.saveBtn}
              startIcon={
                saving ? <CircularProgress size={16} /> : <SaveIcon />
              }
              onClick={handleSave}
              disabled={saving}
            >
              Salvar
            </Button>
          </div>
        </Toolbar>
      </AppBar>

      <div className={classes.content}>
        <NodePalette />
        <div className={classes.flowArea} ref={reactFlowWrapper}>
          <ReactFlow
            nodes={nodes}
            edges={edges}
            onNodesChange={onNodesChange}
            onEdgesChange={onEdgesChange}
            onConnect={onConnect}
            onInit={setReactFlowInstance}
            onDrop={onDrop}
            onDragOver={onDragOver}
            onNodeClick={onNodeClick}
            onPaneClick={onPaneClick}
            nodeTypes={nodeTypes}
            defaultEdgeOptions={defaultEdgeOptions}
            fitView
            snapToGrid
            snapGrid={[15, 15]}
            deleteKeyCode={["Backspace", "Delete"]}
          >
            <Controls />
            <MiniMap
              nodeStrokeWidth={3}
              zoomable
              pannable
              style={{ height: 100 }}
            />
            <Background variant="dots" gap={15} size={1} />
          </ReactFlow>
        </div>
        {selectedNode && (
          <NodePropertiesPanel
            node={selectedNode}
            onUpdate={handleUpdateNodeData}
            onDelete={handleDeleteNode}
            onClose={() => setSelectedNode(null)}
          />
        )}
      </div>
    </div>
  );
};

export default FlowBuilder;
