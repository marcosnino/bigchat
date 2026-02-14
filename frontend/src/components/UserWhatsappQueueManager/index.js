import React, { useState, useEffect } from "react";
import {
  Box,
  Button,
  Card,
  CardContent,
  Chip,
  CircularProgress,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  Grid,
  IconButton,
  Paper,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Tooltip,
  Typography,
  Alert,
  FormControl,
  InputLabel,
  Select,
  MenuItem
} from "@mui/material";
import {
  Add as AddIcon,
  Delete as DeleteIcon,
  Edit as EditIcon,
  Warning as WarningIcon,
  CheckCircle as CheckCircleIcon,
  Info as InfoIcon
} from "@mui/icons-material";
import { toast } from "react-toastify";
import api from "../../services/api";

const UserWhatsappQueueManager = () => {
  const [assignments, setAssignments] = useState([]);
  const [statistics, setStatistics] = useState(null);
  const [warnings, setWarnings] = useState([]);
  const [loading, setLoading] = useState(false);
  const [users, setUsers] = useState([]);
  const [whatsapps, setWhatsapps] = useState([]);
  const [queues, setQueues] = useState([]);
  const [filterUserId, setFilterUserId] = useState("");
  const [filterWhatsappId, setFilterWhatsappId] = useState("");
  const [filterQueueId, setFilterQueueId] = useState("");
  const [addDialogOpen, setAddDialogOpen] = useState(false);
  const [selectedUser, setSelectedUser] = useState("");
  const [selectedWhatsapp, setSelectedWhatsapp] = useState("");
  const [selectedQueue, setSelectedQueue] = useState("");

  // Carregar dados iniciais
  const loadData = async () => {
    try {
      setLoading(true);

      const [
        usersRes,
        whatsappsRes,
        queuesRes,
        assignmentsRes,
        statsRes,
        warningsRes
      ] = await Promise.all([
        api.get("/users"),
        api.get("/whatsapp"),
        api.get("/queue"),
        api.get("/user-whatsapp-queue"),
        api.get("/user-whatsapp-queue/statistics"),
        api.get("/user-whatsapp-queue/warnings")
      ]);

      setUsers(usersRes.data || []);
      setWhatsapps(whatsappsRes.data || []);
      setQueues(queuesRes.data || []);
      setAssignments(assignmentsRes.data.data || []);
      setStatistics(statsRes.data.data || null);
      setWarnings(warningsRes.data.data || []);

    } catch (error) {
      console.error("Erro ao carregar dados:", error);
      toast.error("Erro ao carregar dados");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadData();
  }, []);

  // Aplicar filtros
  const filteredAssignments = assignments.filter(a => {
    if (filterUserId && a.userId !== Number(filterUserId)) return false;
    if (filterWhatsappId && a.whatsappId !== Number(filterWhatsappId)) return false;
    if (filterQueueId && a.queueId !== Number(filterQueueId)) return false;
    return true;
  });

  // Adicionar nova atribuição
  const handleAddAssignment = async () => {
    if (!selectedUser || !selectedWhatsapp || !selectedQueue) {
      toast.error("Selecione usuário, número e fila");
      return;
    }

    try {
      setLoading(true);
      await api.post("/user-whatsapp-queue", {
        userId: Number(selectedUser),
        whatsappId: Number(selectedWhatsapp),
        queueId: Number(selectedQueue)
      });

      toast.success("Atribuição criada com sucesso");
      setAddDialogOpen(false);
      setSelectedUser("");
      setSelectedWhatsapp("");
      setSelectedQueue("");
      await loadData();

    } catch (error) {
      const msg = error.response?.data?.message || error.message;
      toast.error(msg);
    } finally {
      setLoading(false);
    }
  };

  // Deletar atribuição
  const handleDelete = async (id) => {
    if (!window.confirm("Tem certeza que deseja remover esta atribuição?")) {
      return;
    }

    try {
      setLoading(true);
      await api.delete(`/user-whatsapp-queue/${id}`);
      toast.success("Atribuição removida");
      await loadData();
    } catch (error) {
      toast.error("Erro ao remover atribuição");
    } finally {
      setLoading(false);
    }
  };

  const getUserName = (id) => {
    const u = users.find(u => u.id === id);
    return u ? u.name : "N/A";
  };

  const getWhatsappName = (id) => {
    const wa = whatsapps.find(w => w.id === id);
    return wa ? wa.name : "N/A";
  };

  const getQueueName = (id) => {
    const q = queues.find(q => q.id === id);
    return q ? q.name : "N/A";
  };

  const getQueueColor = (id) => {
    const q = queues.find(q => q.id === id);
    return q ? q.color : "#999";
  };

  const getWhatsappStatus = (id) => {
    const wa = whatsapps.find(w => w.id === id);
    return wa ? wa.status : "UNKNOWN";
  };

  return (
    <Box p={3}>
      <Typography variant="h5" gutterBottom>
        🔗 Gerenciador de Atribuições Usuário-Número-Fila
      </Typography>
      <Typography variant="body2" color="textSecondary" gutterBottom>
        Configure quais usuários podem atender em quais números e filas
      </Typography>

      {/* Estatísticas */}
      {statistics && (
        <Grid container spacing={2} sx={{ mb: 3 }}>
          <Grid item xs={6} md={3}>
            <Card>
              <CardContent>
                <Typography color="textSecondary" gutterBottom>
                  Total Atribuído
                </Typography>
                <Typography variant="h4">{statistics.totalLinks}</Typography>
              </CardContent>
            </Card>
          </Grid>
          <Grid item xs={6} md={3}>
            <Card>
              <CardContent>
                <Typography color="textSecondary" gutterBottom>
                  Ativas
                </Typography>
                <Typography variant="h4" color="success.main">
                  {statistics.activeLinks}
                </Typography>
              </CardContent>
            </Card>
          </Grid>
          <Grid item xs={6} md={3}>
            <Card>
              <CardContent>
                <Typography color="textSecondary" gutterBottom>
                  Inativas
                </Typography>
                <Typography variant="h4" color="warning.main">
                  {statistics.inactiveLinks}
                </Typography>
              </CardContent>
            </Card>
          </Grid>
          <Grid item xs={6} md={3}>
            <Card>
              <CardContent>
                <Typography color="textSecondary" gutterBottom>
                  Usuários Atribuídos
                </Typography>
                <Typography variant="h4">{statistics.usersWithAssignments}</Typography>
              </CardContent>
            </Card>
          </Grid>
        </Grid>
      )}

      {/* Avisos */}
      {warnings.length > 0 && (
        <Alert severity="warning" sx={{ mb: 2, display: "flex", alignItems: "center", gap: 1 }}>
          <WarningIcon />
          <div>
            <strong>{warnings.length} aviso(s):</strong> Há usuários atribuídos a
            números desconectados. Reconecte-os ou remova as atribuições.
          </div>
        </Alert>
      )}

      {/* Botão adicionar */}
      <Box sx={{ mb: 2 }}>
        <Button
          variant="contained"
          color="primary"
          startIcon={<AddIcon />}
          onClick={() => setAddDialogOpen(true)}
          disabled={loading}
        >
          Nova Atribuição
        </Button>
      </Box>

      {/* Filtros */}
      <Paper sx={{ p: 2, mb: 2 }}>
        <Typography variant="subtitle2" gutterBottom>
          Filtros
        </Typography>
        <Box sx={{ display: "flex", gap: 2, flexWrap: "wrap" }}>
          <FormControl sx={{ minWidth: 150 }}>
            <InputLabel>Usuário</InputLabel>
            <Select
              value={filterUserId}
              label="Usuário"
              onChange={(e) => setFilterUserId(e.target.value)}
            >
              <MenuItem value="">Todos</MenuItem>
              {users.map((u) => (
                <MenuItem key={u.id} value={u.id}>
                  {u.name}
                </MenuItem>
              ))}
            </Select>
          </FormControl>

          <FormControl sx={{ minWidth: 150 }}>
            <InputLabel>Número</InputLabel>
            <Select
              value={filterWhatsappId}
              label="Número"
              onChange={(e) => setFilterWhatsappId(e.target.value)}
            >
              <MenuItem value="">Todos</MenuItem>
              {whatsapps.map((w) => (
                <MenuItem key={w.id} value={w.id}>
                  {w.name}
                </MenuItem>
              ))}
            </Select>
          </FormControl>

          <FormControl sx={{ minWidth: 150 }}>
            <InputLabel>Fila</InputLabel>
            <Select
              value={filterQueueId}
              label="Fila"
              onChange={(e) => setFilterQueueId(e.target.value)}
            >
              <MenuItem value="">Todos</MenuItem>
              {queues.map((q) => (
                <MenuItem key={q.id} value={q.id}>
                  {q.name}
                </MenuItem>
              ))}
            </Select>
          </FormControl>

          {(filterUserId || filterWhatsappId || filterQueueId) && (
            <Button
              variant="outlined"
              onClick={() => {
                setFilterUserId("");
                setFilterWhatsappId("");
                setFilterQueueId("");
              }}
            >
              Limpar Filtros
            </Button>
          )}
        </Box>
      </Paper>

      {/* Tabela de atribuições */}
      {loading ? (
        <Box display="flex" justifyContent="center" alignItems="center" minHeight="300px">
          <CircularProgress />
        </Box>
      ) : (
        <TableContainer component={Paper}>
          <Table size="small">
            <TableHead>
              <TableRow sx={{ backgroundColor: "#f5f5f5" }}>
                <TableCell>Usuário</TableCell>
                <TableCell>Número</TableCell>
                <TableCell>Fila</TableCell>
                <TableCell>Status Número</TableCell>
                <TableCell>Ativa</TableCell>
                <TableCell align="center">Ações</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {filteredAssignments.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={6} align="center" sx={{ py: 4 }}>
                    <InfoIcon sx={{ mr: 1, verticalAlign: "middle" }} />
                    Nenhuma atribuição encontrada
                  </TableCell>
                </TableRow>
              ) : (
                filteredAssignments.map((assignment) => {
                  const whatsappStatus = getWhatsappStatus(assignment.whatsappId);
                  const isDisconnected = whatsappStatus !== "CONNECTED";

                  return (
                    <TableRow
                      key={assignment.id}
                      sx={{
                        backgroundColor: isDisconnected ? "#fff3cd" : "inherit"
                      }}
                    >
                      <TableCell>
                        <strong>{getUserName(assignment.userId)}</strong>
                      </TableCell>
                      <TableCell>
                        <Box display="flex" alignItems="center" gap={1}>
                          {getWhatsappName(assignment.whatsappId)}
                          {isDisconnected && (
                            <Tooltip title={`Status: ${whatsappStatus}`}>
                              <WarningIcon
                                sx={{ fontSize: 18, color: "orange" }}
                              />
                            </Tooltip>
                          )}
                        </Box>
                      </TableCell>
                      <TableCell>
                        <Chip
                          label={getQueueName(assignment.queueId)}
                          size="small"
                          style={{
                            backgroundColor: getQueueColor(assignment.queueId),
                            color: "#fff"
                          }}
                        />
                      </TableCell>
                      <TableCell>
                        <Chip
                          icon={
                            whatsappStatus === "CONNECTED" ? (
                              <CheckCircleIcon />
                            ) : undefined
                          }
                          label={whatsappStatus}
                          color={whatsappStatus === "CONNECTED" ? "success" : "warning"}
                          size="small"
                        />
                      </TableCell>
                      <TableCell>
                        {assignment.isActive ? (
                          <CheckCircleIcon color="success" />
                        ) : (
                          <Typography variant="caption">Inativa</Typography>
                        )}
                      </TableCell>
                      <TableCell align="center">
                        <Tooltip title="Remover">
                          <IconButton
                            size="small"
                            color="error"
                            onClick={() => handleDelete(assignment.id)}
                            disabled={loading}
                          >
                            <DeleteIcon fontSize="small" />
                          </IconButton>
                        </Tooltip>
                      </TableCell>
                    </TableRow>
                  );
                })
              )}
            </TableBody>
          </Table>
        </TableContainer>
      )}

      {/* Dialog para nova atribuição */}
      <Dialog open={addDialogOpen} onClose={() => setAddDialogOpen(false)} maxWidth="sm" fullWidth>
        <DialogTitle>➕ Nova Atribuição</DialogTitle>
        <DialogContent sx={{ pt: 2 }}>
          <FormControl fullWidth sx={{ mb: 2 }}>
            <InputLabel>Usuário</InputLabel>
            <Select
              value={selectedUser}
              label="Usuário"
              onChange={(e) => setSelectedUser(e.target.value)}
            >
              <MenuItem value="">Selecione...</MenuItem>
              {users.map((u) => (
                <MenuItem key={u.id} value={u.id}>
                  {u.name} ({u.email})
                </MenuItem>
              ))}
            </Select>
          </FormControl>

          <FormControl fullWidth sx={{ mb: 2 }}>
            <InputLabel>Número WhatsApp</InputLabel>
            <Select
              value={selectedWhatsapp}
              label="Número WhatsApp"
              onChange={(e) => setSelectedWhatsapp(e.target.value)}
            >
              <MenuItem value="">Selecione...</MenuItem>
              {whatsapps.map((w) => (
                <MenuItem key={w.id} value={w.id}>
                  {w.name} ({w.status})
                </MenuItem>
              ))}
            </Select>
          </FormControl>

          <FormControl fullWidth>
            <InputLabel>Fila</InputLabel>
            <Select
              value={selectedQueue}
              label="Fila"
              onChange={(e) => setSelectedQueue(e.target.value)}
            >
              <MenuItem value="">Selecione...</MenuItem>
              {queues.map((q) => (
                <MenuItem key={q.id} value={q.id}>
                  {q.name}
                </MenuItem>
              ))}
            </Select>
          </FormControl>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setAddDialogOpen(false)}>Cancelar</Button>
          <Button
            onClick={handleAddAssignment}
            variant="contained"
            color="primary"
            disabled={loading || !selectedUser || !selectedWhatsapp || !selectedQueue}
          >
            Adicionar
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default UserWhatsappQueueManager;
