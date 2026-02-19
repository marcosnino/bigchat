import React, { useState, useEffect, useReducer, useContext, useCallback } from "react";
import { useHistory } from "react-router-dom";
import { makeStyles } from "@material-ui/core/styles";
import {
  Paper,
  Button,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  IconButton,
  Typography,
  TextField,
  InputAdornment,
  Chip,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Tooltip,
  Switch,
} from "@material-ui/core";
import AddIcon from "@material-ui/icons/Add";
import EditIcon from "@material-ui/icons/Edit";
import DeleteIcon from "@material-ui/icons/Delete";
import FileCopyIcon from "@material-ui/icons/FileCopy";
import SearchIcon from "@material-ui/icons/Search";
import AccountTreeIcon from "@material-ui/icons/AccountTree";
import MainContainer from "../../components/MainContainer";
import MainHeader from "../../components/MainHeader";
import MainHeaderButtonsWrapper from "../../components/MainHeaderButtonsWrapper";
import Title from "../../components/Title";
import api from "../../services/api";
import { toast } from "react-toastify";
import toastError from "../../errors/toastError";
import ConfirmationModal from "../../components/ConfirmationModal";
import TableRowSkeleton from "../../components/TableRowSkeleton";
import { SocketContext } from "../../context/Socket/SocketContext";
import { AuthContext } from "../../context/Auth/AuthContext";

const useStyles = makeStyles((theme) => ({
  mainPaper: {
    flex: 1,
    padding: theme.spacing(1),
    overflowY: "scroll",
    ...theme.scrollbarStyles,
  },
  customTableCell: {
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
  },
  headerIcon: {
    marginRight: theme.spacing(1),
    color: theme.palette.primary.main,
  },
  statusActive: {
    backgroundColor: "#4caf50",
    color: "#fff",
  },
  statusInactive: {
    backgroundColor: "#9e9e9e",
    color: "#fff",
  },
  triggerChip: {
    marginRight: 4,
  },
  emptyState: {
    textAlign: "center",
    padding: theme.spacing(6),
  },
  emptyIcon: {
    fontSize: 64,
    color: theme.palette.text.disabled,
    marginBottom: theme.spacing(2),
  },
}));

const reducer = (state, action) => {
  switch (action.type) {
    case "LOAD_FLOWS":
      return [...action.payload];
    case "UPDATE_FLOW": {
      const flow = action.payload;
      const idx = state.findIndex((f) => f.id === flow.id);
      if (idx !== -1) {
        state[idx] = flow;
        return [...state];
      }
      return [flow, ...state];
    }
    case "DELETE_FLOW": {
      return state.filter((f) => f.id !== action.payload);
    }
    case "RESET":
      return [];
    default:
      return state;
  }
};

const triggerLabels = {
  keyword: "Palavra-chave",
  newConversation: "Nova conversa",
  queueAssignment: "Atribuição de fila",
  manual: "Manual",
};

const FlowChats = () => {
  const classes = useStyles();
  const history = useHistory();
  const { user } = useContext(AuthContext);
  const socketManager = useContext(SocketContext);

  const [flows, dispatch] = useReducer(reducer, []);
  const [loading, setLoading] = useState(false);
  const [searchParam, setSearchParam] = useState("");
  const [pageNumber, setPageNumber] = useState(1);
  const [hasMore, setHasMore] = useState(false);
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [selectedFlow, setSelectedFlow] = useState(null);
  const [nameDialogOpen, setNameDialogOpen] = useState(false);
  const [newFlowName, setNewFlowName] = useState("");

  const fetchFlows = useCallback(async () => {
    setLoading(true);
    try {
      const { data } = await api.get("/flow-chats", {
        params: { searchParam, pageNumber },
      });
      dispatch({ type: "LOAD_FLOWS", payload: data.records });
      setHasMore(data.hasMore);
    } catch (err) {
      toastError(err);
    }
    setLoading(false);
  }, [searchParam, pageNumber]);

  useEffect(() => {
    fetchFlows();
  }, [fetchFlows]);

  useEffect(() => {
    const companyId = user.companyId;
    const socket = socketManager.getSocket(companyId);

    socket.on(`company-${companyId}-flow`, (data) => {
      if (data.action === "create" || data.action === "update") {
        dispatch({ type: "UPDATE_FLOW", payload: data.record });
      }
      if (data.action === "delete") {
        dispatch({ type: "DELETE_FLOW", payload: data.id });
      }
    });

    return () => {
      socket.disconnect();
    };
  }, [socketManager, user]);

  const handleSearch = (e) => {
    setSearchParam(e.target.value.toLowerCase());
    setPageNumber(1);
  };

  const handleCreateFlow = async () => {
    if (!newFlowName.trim()) return;
    try {
      const { data } = await api.post("/flow-chats", {
        name: newFlowName,
        status: "inactive",
        trigger: "keyword",
        triggerCondition: { keywords: [] },
        nodes: [
          {
            id: "start-1",
            type: "start",
            position: { x: 300, y: 50 },
            data: { label: "Início" },
          },
        ],
        edges: [],
      });
      setNameDialogOpen(false);
      setNewFlowName("");
      toast.success("Fluxo criado com sucesso!");
      history.push(`/flow-builder/${data.id}`);
    } catch (err) {
      toastError(err);
    }
  };

  const handleToggleStatus = async (flow) => {
    try {
      const newStatus = flow.status === "active" ? "inactive" : "active";
      await api.put(`/flow-chats/${flow.id}`, { status: newStatus });
      toast.success(
        newStatus === "active" ? "Fluxo ativado!" : "Fluxo desativado!"
      );
    } catch (err) {
      toastError(err);
    }
  };

  const handleDuplicate = async (flow) => {
    try {
      await api.post(`/flow-chats/${flow.id}/duplicate`);
      toast.success("Fluxo duplicado com sucesso!");
    } catch (err) {
      toastError(err);
    }
  };

  const handleDeleteFlow = async () => {
    if (!selectedFlow) return;
    try {
      await api.delete(`/flow-chats/${selectedFlow.id}`);
      toast.success("Fluxo excluído com sucesso!");
      setDeleteDialogOpen(false);
      setSelectedFlow(null);
    } catch (err) {
      toastError(err);
    }
  };

  const loadMore = () => {
    setPageNumber((prev) => prev + 1);
  };

  return (
    <MainContainer>
      <MainHeader>
        <div style={{ display: "flex", alignItems: "center" }}>
          <AccountTreeIcon className={classes.headerIcon} />
          <Title>Fluxos de Automação</Title>
        </div>
        <MainHeaderButtonsWrapper>
          <TextField
            placeholder="Pesquisar..."
            type="search"
            value={searchParam}
            onChange={handleSearch}
            size="small"
            InputProps={{
              startAdornment: (
                <InputAdornment position="start">
                  <SearchIcon style={{ color: "gray" }} />
                </InputAdornment>
              ),
            }}
          />
          <Button
            variant="contained"
            color="primary"
            startIcon={<AddIcon />}
            onClick={() => setNameDialogOpen(true)}
          >
            Novo Fluxo
          </Button>
        </MainHeaderButtonsWrapper>
      </MainHeader>

      <Paper className={classes.mainPaper} variant="outlined">
        {flows.length === 0 && !loading ? (
          <div className={classes.emptyState}>
            <AccountTreeIcon className={classes.emptyIcon} />
            <Typography variant="h6" color="textSecondary">
              Nenhum fluxo de automação
            </Typography>
            <Typography variant="body2" color="textSecondary" gutterBottom>
              Crie seu primeiro fluxo para automatizar as conversas
            </Typography>
            <Button
              variant="contained"
              color="primary"
              startIcon={<AddIcon />}
              onClick={() => setNameDialogOpen(true)}
              style={{ marginTop: 16 }}
            >
              Criar Fluxo
            </Button>
          </div>
        ) : (
          <>
            <TableContainer>
              <Table size="small">
                <TableHead>
                  <TableRow>
                    <TableCell>Nome</TableCell>
                    <TableCell align="center">Status</TableCell>
                    <TableCell align="center">Gatilho</TableCell>
                    <TableCell align="center">Nodes</TableCell>
                    <TableCell align="center">Ativo</TableCell>
                    <TableCell align="center">Ações</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {loading ? (
                    <TableRowSkeleton columns={6} />
                  ) : (
                    flows.map((flow) => (
                      <TableRow key={flow.id}>
                        <TableCell>
                          <Typography variant="body2" style={{ fontWeight: 500 }}>
                            {flow.name}
                          </Typography>
                        </TableCell>
                        <TableCell align="center">
                          <Chip
                            size="small"
                            label={
                              flow.status === "active" ? "Ativo" : "Inativo"
                            }
                            className={
                              flow.status === "active"
                                ? classes.statusActive
                                : classes.statusInactive
                            }
                          />
                        </TableCell>
                        <TableCell align="center">
                          <Chip
                            size="small"
                            label={
                              triggerLabels[flow.trigger] || flow.trigger
                            }
                            className={classes.triggerChip}
                            variant="outlined"
                          />
                        </TableCell>
                        <TableCell align="center">
                          {(flow.nodes || []).length}
                        </TableCell>
                        <TableCell align="center">
                          <Switch
                            size="small"
                            checked={flow.status === "active"}
                            onChange={() => handleToggleStatus(flow)}
                            color="primary"
                          />
                        </TableCell>
                        <TableCell align="center">
                          <Tooltip title="Editar fluxo">
                            <IconButton
                              size="small"
                              onClick={() =>
                                history.push(`/flow-builder/${flow.id}`)
                              }
                            >
                              <EditIcon fontSize="small" />
                            </IconButton>
                          </Tooltip>
                          <Tooltip title="Duplicar">
                            <IconButton
                              size="small"
                              onClick={() => handleDuplicate(flow)}
                            >
                              <FileCopyIcon fontSize="small" />
                            </IconButton>
                          </Tooltip>
                          <Tooltip title="Excluir">
                            <IconButton
                              size="small"
                              onClick={() => {
                                setSelectedFlow(flow);
                                setDeleteDialogOpen(true);
                              }}
                            >
                              <DeleteIcon fontSize="small" color="secondary" />
                            </IconButton>
                          </Tooltip>
                        </TableCell>
                      </TableRow>
                    ))
                  )}
                </TableBody>
              </Table>
            </TableContainer>
            {hasMore && (
              <div style={{ textAlign: "center", padding: 16 }}>
                <Button onClick={loadMore} disabled={loading}>
                  Carregar mais
                </Button>
              </div>
            )}
          </>
        )}
      </Paper>

      {/* Create Dialog */}
      <Dialog
        open={nameDialogOpen}
        onClose={() => setNameDialogOpen(false)}
        maxWidth="xs"
        fullWidth
      >
        <DialogTitle>Novo Fluxo de Automação</DialogTitle>
        <DialogContent>
          <TextField
            autoFocus
            label="Nome do Fluxo"
            fullWidth
            value={newFlowName}
            onChange={(e) => setNewFlowName(e.target.value)}
            variant="outlined"
            margin="dense"
            placeholder="Ex: Boas-vindas, Suporte, Vendas..."
            onKeyPress={(e) => e.key === "Enter" && handleCreateFlow()}
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setNameDialogOpen(false)}>Cancelar</Button>
          <Button
            onClick={handleCreateFlow}
            color="primary"
            variant="contained"
            disabled={!newFlowName.trim()}
          >
            Criar
          </Button>
        </DialogActions>
      </Dialog>

      {/* Delete Confirmation */}
      <ConfirmationModal
        title="Excluir Fluxo"
        open={deleteDialogOpen}
        onClose={() => setDeleteDialogOpen(false)}
        onConfirm={handleDeleteFlow}
      >
        Tem certeza que deseja excluir o fluxo "{selectedFlow?.name}"?
      </ConfirmationModal>
    </MainContainer>
  );
};

export default FlowChats;
