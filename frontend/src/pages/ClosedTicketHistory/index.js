/**
 * ClosedTicketHistory.js
 * Componente para visualizar histórico de chats/tickets fechados
 * Com filtros avançados, estatísticas e exportação
 * 
 * @author BigChat Development Team
 * @version 1.0.0
 */

import React, { useState, useEffect, useCallback } from "react";
import {
  Container,
  Paper,
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableRow,
  TextField,
  Button,
  Box,
  Grid,
  Card,
  CardContent,
  Typography,
  CircularProgress,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Chip,
  TablePagination,
  Select,
  MenuItem,
  FormControl,
  InputLabel,
  IconButton,
  Tooltip
} from "@material-ui/core";
import {
  GetApp as GetAppIcon,
  Visibility as VisibilityIcon,
  Close as CloseIcon
} from "@material-ui/icons";
import { makeStyles } from "@material-ui/core/styles";
import api from "../../services/api";
import toastError from "../../errors/toastError";
import { format, formatDistance } from "date-fns";
import ptBR from "date-fns/locale/pt-BR";

const useStyles = makeStyles(theme => ({
  root: {
    padding: theme.spacing(3),
  },
  filterBox: {
    marginBottom: theme.spacing(3),
    padding: theme.spacing(2),
    backgroundColor: "#f5f5f5",
    borderRadius: theme.spacing(1),
  },
  statsContainer: {
    marginBottom: theme.spacing(3),
  },
  statCard: {
    textAlign: "center",
    padding: theme.spacing(2),
  },
  statValue: {
    fontSize: "2rem",
    fontWeight: "bold",
    color: theme.palette.primary.main,
  },
  statLabel: {
    color: "#666",
    marginTop: theme.spacing(1),
  },
  tableContainer: {
    marginTop: theme.spacing(2),
  },
  tableHead: {
    backgroundColor: "#f5f5f5",
  },
  statusCell: {
    display: "flex",
    justifyContent: "center",
  },
  actionButtons: {
    display: "flex",
    gap: theme.spacing(1),
    justifyContent: "center",
  },
  detailsDialog: {
    minWidth: "500px",
  },
  detailField: {
    marginBottom: theme.spacing(1),
  },
}));

const ClosedTicketHistory = () => {
  const classes = useStyles();

  // Estado dos filtros
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");
  const [startOpenDate, setStartOpenDate] = useState("");
  const [endOpenDate, setEndOpenDate] = useState("");
  const [whatsappId, setWhatsappId] = useState("");
  const [queueId, setQueueId] = useState("");
  const [userId, setUserId] = useState("");
  const [rating, setRating] = useState("");

  // Estado dos dados
  const [tickets, setTickets] = useState([]);
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(false);
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(50);
  const [total, setTotal] = useState(0);

  // Estado de diálogo
  const [openDetails, setOpenDetails] = useState(false);
  const [selectedTicket, setSelectedTicket] = useState(null);

  // Listas de filtros
  const [whatsapps, setWhatsapps] = useState([]);
  const [queues, setQueues] = useState([]);
  const [users, setUsers] = useState([]);

  // Carregar listas de filtros
  useEffect(() => {
    loadFilterOptions();
  }, []);

  const loadFilterOptions = async () => {
    try {
      const [whatsappRes, queueRes, userRes] = await Promise.all([
        api.get("/whatsapp"),
        api.get("/queue"),
        api.get("/users")
      ]);

      if (whatsappRes.data.whatsapps) {
        setWhatsapps(whatsappRes.data.whatsapps);
      }
      if (queueRes.data.queues) {
        setQueues(queueRes.data.queues);
      }
      if (userRes.data.users) {
        setUsers(userRes.data.users);
      }
    } catch (error) {
      toastError(error);
    }
  };

  // Buscar histórico e estatísticas
  const loadData = useCallback(async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();

      if (startDate) params.append("startDate", startDate);
      if (endDate) params.append("endDate", endDate);
      if (startOpenDate) params.append("startOpenDate", startOpenDate);
      if (endOpenDate) params.append("endOpenDate", endOpenDate);
      if (whatsappId) params.append("whatsappId", whatsappId);
      if (queueId) params.append("queueId", queueId);
      if (userId) params.append("userId", userId);
      if (rating) params.append("rating", rating);
      
      params.append("page", page + 1);
      params.append("limit", rowsPerPage);

      const [historyRes, statsRes] = await Promise.all([
        api.get(`/closed-tickets/history?${params.toString()}`),
        api.get(`/closed-tickets/stats?${params.toString()}`)
      ]);

      if (historyRes.data.data) {
        setTickets(historyRes.data.data);
        setTotal(historyRes.data.pagination.total);
      }

      if (statsRes.data.data) {
        setStats(statsRes.data.data);
      }
    } catch (error) {
      toastError(error);
    } finally {
      setLoading(false);
    }
  }, [page, rowsPerPage, startDate, endDate, startOpenDate, endOpenDate, whatsappId, queueId, userId, rating]);

  // Carregar dados ao montar e quando filtros mudarem
  useEffect(() => {
    setPage(0);
  }, [startDate, endDate, startOpenDate, endOpenDate, whatsappId, queueId, userId, rating]);

  useEffect(() => {
    loadData();
  }, [loadData]);

  const handleExportCSV = async () => {
    try {
      const params = new URLSearchParams();

      if (startDate) params.append("startDate", startDate);
      if (endDate) params.append("endDate", endDate);
      if (startOpenDate) params.append("startOpenDate", startOpenDate);
      if (endOpenDate) params.append("endOpenDate", endOpenDate);
      if (whatsappId) params.append("whatsappId", whatsappId);
      if (queueId) params.append("queueId", queueId);
      if (userId) params.append("userId", userId);
      if (rating) params.append("rating", rating);

      const response = await api.get(`/closed-tickets/export/csv?${params.toString()}`, {
        responseType: "blob"
      });

      const url = window.URL.createObjectURL(new Blob([response.data]));
      const link = document.createElement("a");
      link.href = url;
      link.setAttribute("download", `closed-tickets-${new Date().toISOString().split("T")[0]}.csv`);
      document.body.appendChild(link);
      link.click();
      link.parentNode.removeChild(link);
    } catch (error) {
      toastError(error);
    }
  };

  const handleViewDetails = (ticket) => {
    setSelectedTicket(ticket);
    setOpenDetails(true);
  };

  const handleCloseDetails = () => {
    setOpenDetails(false);
    setSelectedTicket(null);
  };

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };

  const formatDuration = (seconds) => {
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    const secs = seconds % 60;

    if (hours > 0) {
      return `${hours}h ${minutes}m`;
    }
    if (minutes > 0) {
      return `${minutes}m ${secs}s`;
    }
    return `${secs}s`;
  };

  const formatDate = (date) => {
    return format(new Date(date), "dd/MM/yyyy HH:mm:ss", { locale: ptBR });
  };

  return (
    <Container maxWidth="lg" className={classes.root}>
      <Typography variant="h4" gutterBottom>
        📊 Histórico de Chats Fechados
      </Typography>

      {/* Filtros */}
      <Paper className={classes.filterBox}>
        <Typography variant="h6" gutterBottom>
          🔍 Filtros Avançados
        </Typography>
        <Grid container spacing={2}>
          <Grid item xs={12} sm={6} md={3}>
            <TextField
              label="Data de Fechamento - Início"
              type="datetime-local"
              value={startDate}
              onChange={(e) => setStartDate(e.target.value)}
              fullWidth
              InputLabelProps={{ shrink: true }}
            />
          </Grid>
          <Grid item xs={12} sm={6} md={3}>
            <TextField
              label="Data de Fechamento - Fim"
              type="datetime-local"
              value={endDate}
              onChange={(e) => setEndDate(e.target.value)}
              fullWidth
              InputLabelProps={{ shrink: true }}
            />
          </Grid>
          <Grid item xs={12} sm={6} md={3}>
            <TextField
              label="Data de Abertura - Início"
              type="datetime-local"
              value={startOpenDate}
              onChange={(e) => setStartOpenDate(e.target.value)}
              fullWidth
              InputLabelProps={{ shrink: true }}
            />
          </Grid>
          <Grid item xs={12} sm={6} md={3}>
            <TextField
              label="Data de Abertura - Fim"
              type="datetime-local"
              value={endOpenDate}
              onChange={(e) => setEndOpenDate(e.target.value)}
              fullWidth
              InputLabelProps={{ shrink: true }}
            />
          </Grid>

          <Grid item xs={12} sm={6} md={3}>
            <FormControl fullWidth>
              <InputLabel>Número WhatsApp</InputLabel>
              <Select
                value={whatsappId}
                onChange={(e) => setWhatsappId(e.target.value)}
              >
                <MenuItem value="">Todos</MenuItem>
                {whatsapps.map(wa => (
                  <MenuItem key={wa.id} value={wa.id}>{wa.name}</MenuItem>
                ))}
              </Select>
            </FormControl>
          </Grid>

          <Grid item xs={12} sm={6} md={3}>
            <FormControl fullWidth>
              <InputLabel>Fila</InputLabel>
              <Select
                value={queueId}
                onChange={(e) => setQueueId(e.target.value)}
              >
                <MenuItem value="">Todas</MenuItem>
                {queues.map(q => (
                  <MenuItem key={q.id} value={q.id}>{q.name}</MenuItem>
                ))}
              </Select>
            </FormControl>
          </Grid>

          <Grid item xs={12} sm={6} md={3}>
            <FormControl fullWidth>
              <InputLabel>Agente</InputLabel>
              <Select
                value={userId}
                onChange={(e) => setUserId(e.target.value)}
              >
                <MenuItem value="">Todos</MenuItem>
                {users.map(u => (
                  <MenuItem key={u.id} value={u.id}>{u.name}</MenuItem>
                ))}
              </Select>
            </FormControl>
          </Grid>

          <Grid item xs={12} sm={6} md={3}>
            <FormControl fullWidth>
              <InputLabel>Rating</InputLabel>
              <Select
                value={rating}
                onChange={(e) => setRating(e.target.value)}
              >
                <MenuItem value="">Todos</MenuItem>
                <MenuItem value="1">⭐ Insatisfeito</MenuItem>
                <MenuItem value="2">⭐⭐ Satisfeito</MenuItem>
                <MenuItem value="3">⭐⭐⭐ Muito Satisfeito</MenuItem>
              </Select>
            </FormControl>
          </Grid>

          <Grid item xs={12}>
            <Box display="flex" gap={2}>
              <Button
                variant="contained"
                color="primary"
                onClick={loadData}
                disabled={loading}
              >
                {loading ? <CircularProgress size={24} /> : "🔄 Buscar"}
              </Button>
              <Button
                variant="outlined"
                color="primary"
                startIcon={<GetAppIcon />}
                onClick={handleExportCSV}
                disabled={loading}
              >
                📥 Exportar CSV
              </Button>
            </Box>
          </Grid>
        </Grid>
      </Paper>

      {/* Estatísticas */}
      {stats && (
        <Grid container spacing={2} className={classes.statsContainer}>
          <Grid item xs={12} sm={6} md={3}>
            <Card>
              <CardContent className={classes.statCard}>
                <Typography color="textSecondary" gutterBottom>
                  Total Fechados
                </Typography>
                <div className={classes.statValue}>{stats.totalClosed}</div>
              </CardContent>
            </Card>
          </Grid>

          <Grid item xs={12} sm={6} md={3}>
            <Card>
              <CardContent className={classes.statCard}>
                <Typography color="textSecondary" gutterBottom>
                  Tempo Médio
                </Typography>
                <div className={classes.statValue}>
                  {formatDuration(stats.averageTime)}
                </div>
              </CardContent>
            </Card>
          </Grid>

          <Grid item xs={12} sm={6} md={3}>
            <Card>
              <CardContent className={classes.statCard}>
                <Typography color="textSecondary" gutterBottom>
                  Total Mensagens
                </Typography>
                <div className={classes.statValue}>{stats.totalMessages}</div>
              </CardContent>
            </Card>
          </Grid>

          <Grid item xs={12} sm={6} md={3}>
            <Card>
              <CardContent className={classes.statCard}>
                <Typography color="textSecondary" gutterBottom>
                  Rating Médio
                </Typography>
                <div className={classes.statValue}>
                  {stats.averageRating.toFixed(1)} ⭐
                </div>
              </CardContent>
            </Card>
          </Grid>
        </Grid>
      )}

      {/* Tabela */}
      <Paper className={classes.tableContainer}>
        <Table>
          <TableHead className={classes.tableHead}>
            <TableRow>
              <TableCell>Número</TableCell>
              <TableCell>Contato</TableCell>
              <TableCell>Fila</TableCell>
              <TableCell>Agente</TableCell>
              <TableCell align="center">Duração</TableCell>
              <TableCell align="center">Mensagens</TableCell>
              <TableCell align="center">Rating</TableCell>
              <TableCell align="center">Data Fechamento</TableCell>
              <TableCell align="center">Ações</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {loading ? (
              <TableRow>
                <TableCell colSpan={9} align="center">
                  <CircularProgress />
                </TableCell>
              </TableRow>
            ) : tickets.length > 0 ? (
              tickets.map(ticket => (
                <TableRow key={ticket.id}>
                  <TableCell>{ticket.whatsapp?.name || "-"}</TableCell>
                  <TableCell>{ticket.contact?.name || "-"}</TableCell>
                  <TableCell>{ticket.queue?.name || "-"}</TableCell>
                  <TableCell>{ticket.user?.name || "-"}</TableCell>
                  <TableCell align="center">
                    {formatDuration(ticket.durationSeconds)}
                  </TableCell>
                  <TableCell align="center">{ticket.totalMessages}</TableCell>
                  <TableCell align="center">
                    {ticket.rating ? (
                      <Chip
                        label={`${ticket.rating} ⭐`}
                        color={ticket.rating >= 3 ? "primary" : ticket.rating === 2 ? "default" : "secondary"}
                        size="small"
                      />
                    ) : (
                      "-"
                    )}
                  </TableCell>
                  <TableCell align="center">
                    {formatDate(ticket.ticketClosedAt)}
                  </TableCell>
                  <TableCell align="center" className={classes.actionButtons}>
                    <Tooltip title="Ver Detalhes">
                      <IconButton
                        size="small"
                        onClick={() => handleViewDetails(ticket)}
                      >
                        <VisibilityIcon />
                      </IconButton>
                    </Tooltip>
                  </TableCell>
                </TableRow>
              ))
            ) : (
              <TableRow>
                <TableCell colSpan={9} align="center">
                  Nenhum registro encontrado
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>

        <TablePagination
          rowsPerPageOptions={[25, 50, 100]}
          component="div"
          count={total}
          rowsPerPage={rowsPerPage}
          page={page}
          onChangePage={handleChangePage}
          onChangeRowsPerPage={handleChangeRowsPerPage}
          labelRowsPerPage="Linhas por página:"
          labelDisplayedRows={({ from, to, count }) =>
            `${from}-${to} de ${count} (total)`
          }
        />
      </Paper>

      {/* Dialog de Detalhes */}
      <Dialog
        open={openDetails}
        onClose={handleCloseDetails}
        maxWidth="sm"
        fullWidth
      >
        <DialogTitle>
          Detalhes do Ticket Fechado
          <IconButton
            aria-label="close"
            onClick={handleCloseDetails}
            style={{ float: "right" }}
          >
            <CloseIcon />
          </IconButton>
        </DialogTitle>
        <DialogContent>
          {selectedTicket && (
            <Box>
              <Paper style={{ padding: 16, marginBottom: 16 }} elevation={0}>
                <Typography variant="h6">ID: #{selectedTicket.ticketId}</Typography>
                <Typography variant="body2" color="textSecondary">
                  Contato: {selectedTicket.contact?.name} ({selectedTicket.contact?.number})
                </Typography>
              </Paper>

              <Typography variant="subtitle2" gutterBottom className={classes.detailField}>
                <strong>Número WhatsApp:</strong> {selectedTicket.whatsapp?.name}
              </Typography>

              <Typography variant="subtitle2" gutterBottom className={classes.detailField}>
                <strong>Fila:</strong> {selectedTicket.queue?.name}
              </Typography>

              <Typography variant="subtitle2" gutterBottom className={classes.detailField}>
                <strong>Agente:</strong> {selectedTicket.user?.name}
              </Typography>

              <Typography variant="subtitle2" gutterBottom className={classes.detailField}>
                <strong>Data de Abertura:</strong>{" "}
                {formatDate(selectedTicket.ticketOpenedAt)}
              </Typography>

              <Typography variant="subtitle2" gutterBottom className={classes.detailField}>
                <strong>Data de Fechamento:</strong>{" "}
                {formatDate(selectedTicket.ticketClosedAt)}
              </Typography>

              <Typography variant="subtitle2" gutterBottom className={classes.detailField}>
                <strong>Duração:</strong>{" "}
                {formatDuration(selectedTicket.durationSeconds)}
              </Typography>

              <Typography variant="subtitle2" gutterBottom className={classes.detailField}>
                <strong>Total de Mensagens:</strong> {selectedTicket.totalMessages}
              </Typography>

              <Typography variant="subtitle2" gutterBottom className={classes.detailField}>
                <strong>Rating:</strong>{" "}
                {selectedTicket.rating ? `${selectedTicket.rating} ⭐` : "Não avaliado"}
              </Typography>

              <Typography variant="subtitle2" gutterBottom className={classes.detailField}>
                <strong>Feedback:</strong>{" "}
                {selectedTicket.feedback || "Sem feedback"}
              </Typography>

              <Typography variant="subtitle2" gutterBottom className={classes.detailField}>
                <strong>Status Final:</strong> {selectedTicket.finalStatus}
              </Typography>

              {selectedTicket.tags && selectedTicket.tags.length > 0 && (
                <Typography variant="subtitle2" gutterBottom className={classes.detailField}>
                  <strong>Tags:</strong>
                  <Box mt={1} display="flex" gap={1} flexWrap="wrap">
                    {selectedTicket.tags.map((tag, idx) => (
                      <Chip key={idx} label={tag} size="small" />
                    ))}
                  </Box>
                </Typography>
              )}
            </Box>
          )}
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDetails} color="primary">
            Fechar
          </Button>
        </DialogActions>
      </Dialog>
    </Container>
  );
};

export default ClosedTicketHistory;
