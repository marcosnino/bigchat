import React, { useState, useEffect, useCallback } from "react";
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Button,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Box,
  Alert,
  CircularProgress,
  Typography,
  Chip,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  IconButton,
  Tooltip,
  Switch
} from "@mui/material";
import {
  Delete as DeleteIcon,
  Edit as EditIcon,
  Add as AddIcon,
  Warning as WarningIcon
} from "@mui/icons-material";
import { toast } from "react-toastify";
import api from "../../services/api";

const UserWhatsappQueueModal = ({ open, onClose, userId, userName }) => {
  const [whatsapps, setWhatsapps] = useState([]);
  const [queues, setQueues] = useState([]);
  const [assignments, setAssignments] = useState([]);
  const [selectedWhatsapp, setSelectedWhatsapp] = useState("");
  const [selectedQueue, setSelectedQueue] = useState("");
  const [notes, setNotes] = useState("");
  const [loading, setLoading] = useState(false);
  const [editingId, setEditingId] = useState(null);
  const [errors, setErrors] = useState([]);
  const [availableUsers, setAvailableUsers] = useState([]);

  // Carregar dados iniciais
  const loadData = useCallback(async () => {
    try {
      setLoading(true);
      
      const [whatsappRes, queueRes, assignmentRes] = await Promise.all([
        api.get("/whatsapp?status=CONNECTED"),
        api.get("/queue"),
        api.get(`/user-whatsapp-queue?userId=${userId}`)
      ]);

      setWhatsapps(whatsappRes.data || []);
      setQueues(queueRes.data || []);
      setAssignments(assignmentRes.data.data || []);

    } catch (error) {
      console.error("Erro ao carregar dados:", error);
      toast.error("Erro ao carregar dados");
    } finally {
      setLoading(false);
    }
  }, [userId]);

  useEffect(() => {
    if (open && userId) {
      loadData();
      setErrors([]);
    }
  }, [open, userId, loadData]);

  // Buscar usuários disponíveis quando mudar whatsapp/fila
  useEffect(() => {
    const loadAvailableUsers = async () => {
      if (selectedWhatsapp && selectedQueue) {
        try {
          const response = await api.get(
            `/user-whatsapp-queue/available/${selectedWhatsapp}/${selectedQueue}`
          );
          setAvailableUsers(response.data.data || []);
        } catch (error) {
          console.error("Erro ao carregar usuários:", error);
        }
      }
    };

    loadAvailableUsers();
  }, [selectedWhatsapp, selectedQueue]);

  // Salvar atribuição
  const handleSave = async () => {
    const newErrors = [];

    if (!selectedWhatsapp) {
      newErrors.push("Número WhatsApp é obrigatório");
    }
    if (!selectedQueue) {
      newErrors.push("Fila é obrigatória");
    }

    if (newErrors.length > 0) {
      setErrors(newErrors);
      return;
    }

    try {
      setLoading(true);

      if (editingId) {
        // Atualizar
        await api.put(`/user-whatsapp-queue/${editingId}`, { notes });
        toast.success("Atribuição atualizada com sucesso");
      } else {
        // Criar
        await api.post("/user-whatsapp-queue", {
          userId,
          whatsappId: Number(selectedWhatsapp),
          queueId: Number(selectedQueue),
          notes
        });
        toast.success("Atribuição criada com sucesso");
      }

      // Resetar formulário
      setSelectedWhatsapp("");
      setSelectedQueue("");
      setNotes("");
      setEditingId(null);
      setErrors([]);

      // Recarregar lista
      await loadData();

    } catch (error) {
      const errorMsg = error.response?.data?.message || error.message;
      setErrors([errorMsg]);
      toast.error(errorMsg);
    } finally {
      setLoading(false);
    }
  };

  // Editar atribuição
  const handleEdit = (assignment) => {
    setSelectedWhatsapp(String(assignment.whatsappId));
    setSelectedQueue(String(assignment.queueId));
    setNotes(assignment.notes || "");
    setEditingId(assignment.id);
  };

  // Deletar atribuição
  const handleDelete = async (id) => {
    if (!window.confirm("Tem certeza que deseja remover esta atribuição?")) {
      return;
    }

    try {
      await api.delete(`/user-whatsapp-queue/${id}`);
      toast.success("Atribuição removida com sucesso");
      await loadData();
    } catch (error) {
      toast.error("Erro ao remover atribuição");
    }
  };

  // Limpar formulário
  const handleClear = () => {
    setSelectedWhatsapp("");
    setSelectedQueue("");
    setNotes("");
    setEditingId(null);
    setErrors([]);
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

  return (
    <Dialog open={open} onClose={onClose} maxWidth="md" fullWidth>
      <DialogTitle>
        ⚙️ Configurar Números e Filas - {userName}
      </DialogTitle>

      <DialogContent sx={{ minHeight: "400px" }}>
        {loading && (
          <Box display="flex" justifyContent="center" alignItems="center" minHeight="200px">
            <CircularProgress />
          </Box>
        )}

        {!loading && (
          <>
            {/* Erros */}
            {errors.length > 0 && (
              <Alert severity="error" sx={{ mb: 2 }}>
                <ul style={{ margin: 0, paddingLeft: 20 }}>
                  {errors.map((error, index) => (
                    <li key={index}>{error}</li>
                  ))}
                </ul>
              </Alert>
            )}

            {/* Avisos sobre números desconectados */}
            {assignments.some(a => {
              const wa = whatsapps.find(w => w.id === a.whatsappId);
              return wa && wa.status !== "CONNECTED";
            }) && (
              <Alert severity="warning" sx={{ mb: 2, display: "flex", alignItems: "center", gap: 1 }}>
                <WarningIcon />
                <div>
                  <strong>Aviso:</strong> Você tem atribuições em números desconectados.
                  Reative os números para continuar atendendo.
                </div>
              </Alert>
            )}

            {/* Formulário de adição/edição */}
            <Box sx={{ mb: 3, p: 2, border: "1px solid #ddd", borderRadius: 1 }}>
              <Typography variant="h6" gutterBottom>
                {editingId ? "✏️ Editar Atribuição" : "➕ Nova Atribuição"}
              </Typography>

              <Box sx={{ display: "flex", gap: 2, mb: 2, flexWrap: "wrap" }}>
                <FormControl sx={{ minWidth: 200 }}>
                  <InputLabel>Número WhatsApp</InputLabel>
                  <Select
                    value={selectedWhatsapp}
                    label="Número WhatsApp"
                    onChange={(e) => setSelectedWhatsapp(e.target.value)}
                    disabled={loading}
                  >
                    <MenuItem value="">
                      <em>Selecione um número...</em>
                    </MenuItem>
                    {whatsapps.map((wa) => (
                      <MenuItem key={wa.id} value={wa.id}>
                        {wa.name} {wa.status !== "CONNECTED" ? ` (${wa.status})` : ""}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>

                <FormControl sx={{ minWidth: 200 }}>
                  <InputLabel>Fila</InputLabel>
                  <Select
                    value={selectedQueue}
                    label="Fila"
                    onChange={(e) => setSelectedQueue(e.target.value)}
                    disabled={loading || !selectedWhatsapp}
                  >
                    <MenuItem value="">
                      <em>Selecione uma fila...</em>
                    </MenuItem>
                    {queues.map((q) => (
                      <MenuItem key={q.id} value={q.id}>
                        {q.name}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
              </Box>

              {/* Nota */}
              <Box sx={{ mb: 2 }}>
                <TextField
                  fullWidth
                  label="Notas (opcional)"
                  value={notes}
                  onChange={(e) => setNotes(e.target.value)}
                  placeholder="Ex: Atende apenas em horário comercial"
                  disabled={loading}
                />
              </Box>

              {/* Informação sobre usuários disponíveis */}
              {selectedWhatsapp && selectedQueue && availableUsers && (
                <Alert severity="info" sx={{ mb: 2 }}>
                  <strong>Usuários com acesso a esta fila:</strong> {availableUsers.length}
                  {availableUsers.filter(u => u.assigned).length > 0 && (
                    <span> ({availableUsers.filter(u => u.assigned).length} atribuído(s))</span>
                  )}
                </Alert>
              )}
            </Box>

            {/* Lista de atribuições */}
            <Box sx={{ mb: 2 }}>
              <Typography variant="h6" gutterBottom>
                📋 Suas Atribuições ({assignments.length})
              </Typography>

              {assignments.length === 0 ? (
                <Alert severity="info">
                  Você não possui atribuições configuradas. Adicione uma nova atribuição acima.
                </Alert>
              ) : (
                <TableContainer component={Paper}>
                  <Table size="small">
                    <TableHead>
                      <TableRow sx={{ backgroundColor: "#f5f5f5" }}>
                        <TableCell>Número</TableCell>
                        <TableCell>Fila</TableCell>
                        <TableCell>Status</TableCell>
                        <TableCell align="center">Ações</TableCell>
                      </TableRow>
                    </TableHead>
                    <TableBody>
                      {assignments.map((assignment) => {
                        const whatsappData = whatsapps.find(w => w.id === assignment.whatsappId);
                        const queueData = queues.find(q => q.id === assignment.queueId);

                        return (
                          <TableRow key={assignment.id}>
                            <TableCell>
                              <Box display="flex" alignItems="center" gap={1}>
                                <Typography variant="body2">
                                  {getWhatsappName(assignment.whatsappId)}
                                </Typography>
                                {whatsappData && whatsappData.status !== "CONNECTED" && (
                                  <Tooltip title={`Status: ${whatsappData.status}`}>
                                    <WarningIcon
                                      sx={{ fontSize: 16, color: "orange" }}
                                    />
                                  </Tooltip>
                                )}
                              </Box>
                            </TableCell>
                            <TableCell>
                              {queueData && (
                                <Chip
                                  label={getQueueName(assignment.queueId)}
                                  size="small"
                                  style={{
                                    backgroundColor: getQueueColor(assignment.queueId),
                                    color: "#fff"
                                  }}
                                />
                              )}
                            </TableCell>
                            <TableCell>
                              <Switch
                                checked={assignment.isActive}
                                onChange={async (e) => {
                                  try {
                                    await api.put(`/user-whatsapp-queue/${assignment.id}`, {
                                      isActive: e.target.checked
                                    });
                                    toast.success("Status atualizado");
                                    await loadData();
                                  } catch (error) {
                                    toast.error("Erro ao atualizar status");
                                  }
                                }}
                                disabled={loading}
                              />
                            </TableCell>
                            <TableCell align="center">
                              <Tooltip title="Editar">
                                <IconButton
                                  size="small"
                                  onClick={() => handleEdit(assignment)}
                                  disabled={loading}
                                >
                                  <EditIcon fontSize="small" />
                                </IconButton>
                              </Tooltip>
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
                      })}
                    </TableBody>
                  </Table>
                </TableContainer>
              )}
            </Box>
          </>
        )}
      </DialogContent>

      <DialogActions>
        <Button onClick={handleClear} disabled={loading}>
          Limpar
        </Button>
        <Button onClick={onClose} disabled={loading}>
          Fechar
        </Button>
        {(selectedWhatsapp || selectedQueue) && (
          <Button
            onClick={handleSave}
            variant="contained"
            color="primary"
            disabled={loading || !selectedWhatsapp || !selectedQueue}
          >
            {editingId ? "Atualizar" : "Adicionar"}
          </Button>
        )}
      </DialogActions>
    </Dialog>
  );
};

// Importar TextField
import { TextField } from "@mui/material";

export default UserWhatsappQueueModal;
