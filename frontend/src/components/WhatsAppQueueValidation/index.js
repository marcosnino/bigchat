import React, { useState, useEffect, useCallback } from "react";
import {
  Box,
  Card,
  CardContent,
  Typography,
  Button,
  Alert,
  Grid,
  Chip,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  Accordion,
  AccordionSummary,
  AccordionDetails,
  Tooltip,
  IconButton,
  CircularProgress,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions
} from "@mui/material";
import {
  ExpandMore as ExpandMoreIcon,
  Warning as WarningIcon,
  CheckCircle as CheckCircleIcon,
  Error as ErrorIcon,
  Refresh as RefreshIcon,
  Build as BuildIcon,
  Delete as DeleteIcon
} from "@mui/icons-material";
import { toast } from "react-toastify";
import api from "../../services/api";
import { i18n } from "../../translate/i18n";

const WhatsAppQueueValidation = () => {
  const [validation, setValidation] = useState(null);
  const [whatsAppReport, setWhatsAppReport] = useState([]);
  const [queueReport, setQueueReport] = useState([]);
  const [loading, setLoading] = useState(false);
  const [autoFixLoading, setAutoFixLoading] = useState(false);
  const [cleanupLoading, setCleanupLoading] = useState(false);
  const [confirmDialog, setConfirmDialog] = useState({
    open: false,
    action: null,
    title: "",
    message: ""
  });

  // Carregar validação
  const loadValidation = useCallback(async () => {
    try {
      setLoading(true);
      
      const [validationRes, whatsAppRes, queueRes] = await Promise.all([
        api.get("/validation/whatsapp-queue"),
        api.get("/validation/whatsapp-queue/report/whatsapps"),
        api.get("/validation/whatsapp-queue/report/queues")
      ]);

      setValidation(validationRes.data.data);
      setWhatsAppReport(whatsAppRes.data.data);
      setQueueReport(queueRes.data.data);

    } catch (error) {
      console.error("Erro ao carregar validação:", error);
      toast.error("Erro ao carregar dados de validação");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadValidation();
  }, [loadValidation]);

  // Correção automática
  const handleAutoFix = async () => {
    try {
      setAutoFixLoading(true);
      const response = await api.post("/validation/whatsapp-queue/autofix");
      
      toast.success(response.data.message);
      
      // Recarregar dados
      await loadValidation();
      
    } catch (error) {
      console.error("Erro na correção automática:", error);
      toast.error("Erro na correção automática");
    } finally {
      setAutoFixLoading(false);
      setConfirmDialog({ open: false, action: null, title: "", message: "" });
    }
  };

  // Limpeza de vinculações órfãs
  const handleCleanup = async () => {
    try {
      setCleanupLoading(true);
      const response = await api.delete("/validation/whatsapp-queue/cleanup");
      
      toast.success(response.data.message);
      
      // Recarregar dados
      await loadValidation();
      
    } catch (error) {
      console.error("Erro na limpeza:", error);
      toast.error("Erro na limpeza de vinculações");
    } finally {
      setCleanupLoading(false);
      setConfirmDialog({ open: false, action: null, title: "", message: "" });
    }
  };

  // Confirmar ação
  const confirmAction = (action, title, message, handler) => {
    setConfirmDialog({
      open: true,
      action: handler,
      title,
      message
    });
  };

  if (loading) {
    return (
      <Box display="flex" justifyContent="center" alignItems="center" minHeight="200px">
        <CircularProgress />
        <Typography variant="body1" sx={{ ml: 2 }}>
          Carregando validações...
        </Typography>
      </Box>
    );
  }

  if (!validation) {
    return (
      <Alert severity="error">
        Erro ao carregar dados de validação
      </Alert>
    );
  }

  return (
    <Box p={3}>
      <Typography variant="h5" gutterBottom>
        🔗 Validação WhatsApp ↔ Filas
      </Typography>
      <Typography variant="body2" color="textSecondary" gutterBottom>
        Verificação das vinculações entre números WhatsApp e filas de atendimento
      </Typography>

      {/* Status Geral */}
      <Card sx={{ mb: 3 }}>
        <CardContent>
          <Box display="flex" alignItems="center" gap={2} mb={2}>
            {validation.isValid ? (
              <CheckCircleIcon color="success" sx={{ fontSize: 40 }} />
            ) : (
              <ErrorIcon color="error" sx={{ fontSize: 40 }} />
            )}
            <Box>
              <Typography variant="h6">
                Status: {validation.isValid ? "✅ Válido" : "❌ Problemas encontrados"}
              </Typography>
              <Typography variant="body2" color="textSecondary">
                {validation.isValid 
                  ? "Todas as vinculações estão configuradas corretamente" 
                  : `${validation.errors.length} erro(s) encontrado(s)`
                }
              </Typography>
            </Box>
          </Box>

          {/* Estatísticas */}
          <Grid container spacing={2} sx={{ mb: 2 }}>
            <Grid item xs={6} md={3}>
              <Box textAlign="center" p={1} border={1} borderColor="divider" borderRadius={1}>
                <Typography variant="h4" color="primary">
                  {validation.statistics.totalWhatsApps}
                </Typography>
                <Typography variant="caption">
                  WhatsApps
                </Typography>
              </Box>
            </Grid>
            <Grid item xs={6} md={3}>
              <Box textAlign="center" p={1} border={1} borderColor="divider" borderRadius={1}>
                <Typography variant="h4" color="primary">
                  {validation.statistics.totalQueues}
                </Typography>
                <Typography variant="caption">
                  Filas
                </Typography>
              </Box>
            </Grid>
            <Grid item xs={6} md={3}>
              <Box textAlign="center" p={1} border={1} borderColor="divider" borderRadius={1}>
                <Typography variant="h4" color="success.main">
                  {validation.statistics.validConnections}
                </Typography>
                <Typography variant="caption">
                  Vinculações
                </Typography>
              </Box>
            </Grid>
            <Grid item xs={6} md={3}>
              <Box textAlign="center" p={1} border={1} borderColor="divider" borderRadius={1}>
                <Typography variant="h4" color="error.main">
                  {validation.statistics.whatsAppsWithoutQueues + validation.statistics.queuesWithoutWhatsApps}
                </Typography>
                <Typography variant="caption">
                  Problemas
                </Typography>
              </Box>
            </Grid>
          </Grid>

          {/* Ações */}
          <Box display="flex" gap={1} flexWrap="wrap">
            <Tooltip title="Atualizar dados">
              <IconButton onClick={loadValidation} disabled={loading}>
                <RefreshIcon />
              </IconButton>
            </Tooltip>
            
            {validation.statistics.whatsAppsWithoutQueues > 0 && (
              <Button
                variant="contained"
                color="warning"
                startIcon={<BuildIcon />}
                onClick={() => confirmAction(
                  'autofix',
                  "Correção Automática",
                  "Isso vai associar WhatsApps sem filas à primeira fila disponível. Deseja continuar?",
                  handleAutoFix
                )}
                disabled={autoFixLoading}
              >
                {autoFixLoading ? "Corrigindo..." : "Corrigir Automaticamente"}
              </Button>
            )}
            
            <Button
              variant="outlined"
              color="error" 
              startIcon={<DeleteIcon />}
              onClick={() => confirmAction(
                'cleanup',
                "Limpeza de Órfãos",
                "Isso vai remover vinculações inválidas do banco de dados. Deseja continuar?",
                handleCleanup
              )}
              disabled={cleanupLoading}
            >
              {cleanupLoading ? "Limpando..." : "Limpar Órfãos"}
            </Button>
          </Box>
        </CardContent>
      </Card>

      {/* Erros */}
      {validation.errors.length > 0 && (
        <Alert severity="error" sx={{ mb: 2 }}>
          <Typography variant="subtitle2" gutterBottom>
            Problemas encontrados:
          </Typography>
          <ul style={{ margin: 0, paddingLeft: 20 }}>
            {validation.errors.map((error, index) => (
              <li key={index}>{error}</li>
            ))}
          </ul>
        </Alert>
      )}

      {/* Warnings */}
      {validation.warnings.length > 0 && (
        <Alert severity="warning" sx={{ mb: 2 }}>
          <Typography variant="subtitle2" gutterBottom>
            Avisos:
          </Typography>
          <ul style={{ margin: 0, paddingLeft: 20 }}>
            {validation.warnings.map((warning, index) => (
              <li key={index}>{warning}</li>
            ))}
          </ul>
        </Alert>
      )}

      {/* Relatório WhatsApps */}
      <Accordion sx={{ mb: 2 }}>
        <AccordionSummary expandIcon={<ExpandMoreIcon />}>
          <Typography variant="h6">
            📱 WhatsApps e suas Filas ({whatsAppReport.length})
          </Typography>
        </AccordionSummary>
        <AccordionDetails>
          <TableContainer component={Paper}>
            <Table size="small">
              <TableHead>
                <TableRow>
                  <TableCell>WhatsApp</TableCell>
                  <TableCell>Status</TableCell>
                  <TableCell>Filas Vinculadas</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {whatsAppReport.map((wa) => (
                  <TableRow key={wa.whatsAppId}>
                    <TableCell>{wa.whatsAppName}</TableCell>
                    <TableCell>
                      <Chip
                        label={wa.status}
                        color={wa.status === "CONNECTED" ? "success" : "default"}
                        size="small"
                      />
                    </TableCell>
                    <TableCell>
                      {wa.queues.length === 0 ? (
                        <Chip label="Nenhuma fila" color="error" size="small" />
                      ) : (
                        <Box display="flex" gap={0.5} flexWrap="wrap">
                          {wa.queues.map((queue) => (
                            <Chip
                              key={queue.id}
                              label={queue.name}
                              size="small"
                              style={{ 
                                backgroundColor: queue.color,
                                color: '#fff'
                              }}
                            />
                          ))}
                        </Box>
                      )}
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </TableContainer>
        </AccordionDetails>
      </Accordion>

      {/* Relatório Filas */}
      <Accordion>
        <AccordionSummary expandIcon={<ExpandMoreIcon />}>
          <Typography variant="h6">
            📋 Filas e seus WhatsApps ({queueReport.length})
          </Typography>
        </AccordionSummary>
        <AccordionDetails>
          <TableContainer component={Paper}>
            <Table size="small">
              <TableHead>
                <TableRow>
                  <TableCell>Fila</TableCell>
                  <TableCell>WhatsApps Vinculados</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {queueReport.map((queue) => (
                  <TableRow key={queue.queueId}>
                    <TableCell>
                      <Chip
                        label={queue.queueName}
                        style={{ 
                          backgroundColor: queue.color,
                          color: '#fff'
                        }}
                      />
                    </TableCell>
                    <TableCell>
                      {queue.whatsApps.length === 0 ? (
                        <Chip label="Nenhum WhatsApp" color="error" size="small" />
                      ) : (
                        <Box display="flex" gap={0.5} flexWrap="wrap">
                          {queue.whatsApps.map((wa) => (
                            <Box key={wa.id} display="flex" alignItems="center" gap={0.5}>
                              <Typography variant="caption">{wa.name}</Typography>
                              <Chip
                                label={wa.status}
                                color={wa.status === "CONNECTED" ? "success" : "default"}
                                size="small"
                              />
                            </Box>
                          ))}
                        </Box>
                      )}
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </TableContainer>
        </AccordionDetails>
      </Accordion>

      {/* Dialog de confirmação */}
      <Dialog open={confirmDialog.open} onClose={() => setConfirmDialog({ open: false, action: null, title: "", message: "" })}>
        <DialogTitle>{confirmDialog.title}</DialogTitle>
        <DialogContent>
          <Typography>{confirmDialog.message}</Typography>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setConfirmDialog({ open: false, action: null, title: "", message: "" })}>
            Cancelar
          </Button>
          <Button 
            onClick={confirmDialog.action} 
            color="primary" 
            variant="contained"
            disabled={autoFixLoading || cleanupLoading}
          >
            Confirmar
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default WhatsAppQueueValidation;