import React, { useState, useCallback, useEffect, useReducer, useContext } from "react";
import { toast } from "react-toastify";

import { makeStyles } from "@material-ui/core/styles";
import { green, red, orange, grey, blue } from "@material-ui/core/colors";
import {
  Button,
  TableBody,
  TableRow,
  TableCell,
  IconButton,
  Table,
  TableHead,
  Paper,
  Tooltip,
  Typography,
  CircularProgress,
  Chip,
  Tabs,
  Tab,
  Box,
  TextField,
  InputAdornment,
  Grid,
  Card,
  CardContent,
} from "@material-ui/core";
import {
  Edit,
  DeleteOutline,
  Phone,
  CheckCircle,
  Error,
  Warning,
  Link as LinkIcon,
  LinkOff,
  Search,
  PhoneCallback,
  PhoneForwarded,
  PhoneMissed,
  Timer,
  Today,
  PersonAdd,
  Settings,
  Refresh,
  PlayArrow,
} from "@material-ui/icons";

import MainContainer from "../../components/MainContainer";
import MainHeader from "../../components/MainHeader";
import MainHeaderButtonsWrapper from "../../components/MainHeaderButtonsWrapper";
import Title from "../../components/Title";
import TableRowSkeleton from "../../components/TableRowSkeleton";
import AsteriskModal from "../../components/AsteriskModal";
import ExtensionModal from "../../components/ExtensionModal";
import ConfirmationModal from "../../components/ConfirmationModal";

import api from "../../services/api";
import { i18n } from "../../translate/i18n";
import toastError from "../../errors/toastError";
import { SocketContext } from "../../context/Socket/SocketContext";
import { format, parseISO } from "date-fns";
import ptBR from "date-fns/locale/pt-BR";

// TabPanel component
function TabPanel(props) {
  const { children, value, index, ...other } = props;
  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`voip-tabpanel-${index}`}
      aria-labelledby={`voip-tab-${index}`}
      {...other}
    >
      {value === index && <Box p={2}>{children}</Box>}
    </div>
  );
}

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
  tooltip: {
    backgroundColor: "#f5f5f9",
    color: "rgba(0, 0, 0, 0.87)",
    fontSize: theme.typography.pxToRem(14),
    border: "1px solid #dadde9",
    maxWidth: 450,
  },
  tooltipPopper: {
    textAlign: "center",
  },
  buttonProgress: {
    color: green[500],
  },
  chip: {
    margin: theme.spacing(0.5),
  },
  connected: {
    backgroundColor: green[500],
    color: "#fff",
  },
  disconnected: {
    backgroundColor: grey[500],
    color: "#fff",
  },
  error: {
    backgroundColor: red[500],
    color: "#fff",
  },
  reconnecting: {
    backgroundColor: orange[500],
    color: "#fff",
  },
  tabs: {
    marginBottom: theme.spacing(1),
  },
  statsCard: {
    marginBottom: theme.spacing(2),
  },
  statsValue: {
    fontSize: "2rem",
    fontWeight: "bold",
    color: theme.palette.primary.main,
  },
  statsLabel: {
    color: theme.palette.text.secondary,
  },
  inboundChip: {
    backgroundColor: green[500],
    color: "#fff",
  },
  outboundChip: {
    backgroundColor: blue[500],
    color: "#fff",
  },
  filterContainer: {
    display: "flex",
    gap: theme.spacing(2),
    marginBottom: theme.spacing(2),
    flexWrap: "wrap",
  },
  searchField: {
    width: "100%",
    maxWidth: 300,
  },
}));

const reducer = (state, action) => {
  switch (action.type) {
    case "LOAD_ASTERISKS":
      return [...action.payload];
    case "ADD_ASTERISK":
      return [action.payload, ...state];
    case "UPDATE_ASTERISK":
      return state.map((a) =>
        a.id === action.payload.id ? action.payload : a
      );
    case "DELETE_ASTERISK":
      return state.filter((a) => a.id !== action.payload);
    case "UPDATE_STATUS":
      return state.map((a) =>
        a.id === action.payload.asteriskId
          ? { ...a, status: action.payload.status }
          : a
      );
    default:
      return state;
  }
};

const extensionReducer = (state, action) => {
  switch (action.type) {
    case "LOAD_EXTENSIONS":
      return [...action.payload];
    case "ADD_EXTENSION":
      return [action.payload, ...state];
    case "UPDATE_EXTENSION":
      return state.map((e) =>
        e.id === action.payload.id ? action.payload : e
      );
    case "DELETE_EXTENSION":
      return state.filter((e) => e.id !== action.payload);
    default:
      return state;
  }
};

const callReducer = (state, action) => {
  switch (action.type) {
    case "LOAD_CALLS":
      return [...action.payload];
    case "ADD_CALL":
      return [action.payload, ...state.slice(0, 99)];
    case "UPDATE_CALL":
      return state.map((c) =>
        c.id === action.payload.id ? action.payload : c
      );
    default:
      return state;
  }
};

const Asterisk = () => {
  const classes = useStyles();

  // Tab state
  const [tabValue, setTabValue] = useState(0);

  // Loading states
  const [loading, setLoading] = useState(false);
  const [loadingExtensions, setLoadingExtensions] = useState(false);
  const [loadingCalls, setLoadingCalls] = useState(false);

  // Data states
  const [asterisks, dispatch] = useReducer(reducer, []);
  const [extensions, dispatchExtensions] = useReducer(extensionReducer, []);
  const [calls, dispatchCalls] = useReducer(callReducer, []);
  const [callStats, setCallStats] = useState({
    totalCalls: 0,
    answeredCalls: 0,
    missedCalls: 0,
    avgDuration: 0,
  });

  // Modal states
  const [asteriskModalOpen, setAsteriskModalOpen] = useState(false);
  const [extensionModalOpen, setExtensionModalOpen] = useState(false);
  const [selectedAsterisk, setSelectedAsterisk] = useState(null);
  const [selectedExtension, setSelectedExtension] = useState(null);
  const [confirmModalOpen, setConfirmModalOpen] = useState(false);
  const [confirmExtensionModalOpen, setConfirmExtensionModalOpen] = useState(false);
  const [connectingId, setConnectingId] = useState(null);

  // Filter states
  const [searchTerm, setSearchTerm] = useState("");
  const [dateFilter, setDateFilter] = useState("");

  const socketManager = useContext(SocketContext);

  // Fetch Extensions
  const fetchExtensions = useCallback(async () => {
    setLoadingExtensions(true);
    try {
      const { data } = await api.get("/extensions");
      dispatchExtensions({ type: "LOAD_EXTENSIONS", payload: data.extensions || data || [] });
    } catch (err) {
      console.log("Extensions not available yet");
    }
    setLoadingExtensions(false);
  }, []);

  // Fetch Calls
  const fetchCalls = useCallback(async () => {
    setLoadingCalls(true);
    try {
      const params = {};
      if (dateFilter) params.date = dateFilter;
      if (searchTerm) params.search = searchTerm;

      const { data } = await api.get("/calls", { params });
      dispatchCalls({ type: "LOAD_CALLS", payload: data.calls || data || [] });

      // Fetch stats
      try {
        const statsResponse = await api.get("/calls/stats");
        setCallStats(statsResponse.data);
      } catch (e) {
        console.log("Stats not available");
      }
    } catch (err) {
      console.log("Calls not available yet");
    }
    setLoadingCalls(false);
  }, [dateFilter, searchTerm]);

  const fetchAsterisks = useCallback(async () => {
    setLoading(true);
    try {
      const { data } = await api.get("/asterisks");
      dispatch({ type: "LOAD_ASTERISKS", payload: data.asterisks || data || [] });
    } catch (err) {
      toastError(err);
    }
    setLoading(false);
  }, []);

  useEffect(() => {
    fetchAsterisks();
    fetchExtensions();
    fetchCalls();
  }, [fetchAsterisks, fetchExtensions, fetchCalls]);

  useEffect(() => {
    const companyId = localStorage.getItem("companyId");
    const socket = socketManager.getSocket(companyId);

    socket.on(`company-${companyId}-asterisk`, (data) => {
      if (data.action === "create") {
        dispatch({ type: "ADD_ASTERISK", payload: data.asterisk });
      }
      if (data.action === "update") {
        dispatch({ type: "UPDATE_ASTERISK", payload: data.asterisk });
      }
      if (data.action === "delete") {
        dispatch({ type: "DELETE_ASTERISK", payload: data.asteriskId });
      }
      if (data.action === "status") {
        dispatch({ type: "UPDATE_STATUS", payload: data });
      }
    });

    socket.on(`company-${companyId}-extension`, (data) => {
      if (data.action === "create") {
        dispatchExtensions({ type: "ADD_EXTENSION", payload: data.extension });
      }
      if (data.action === "update") {
        dispatchExtensions({ type: "UPDATE_EXTENSION", payload: data.extension });
      }
      if (data.action === "delete") {
        dispatchExtensions({ type: "DELETE_EXTENSION", payload: data.extensionId });
      }
    });

    socket.on(`company-${companyId}-call`, (data) => {
      if (data.action === "create") {
        dispatchCalls({ type: "ADD_CALL", payload: data.call });
      }
      if (data.action === "update") {
        dispatchCalls({ type: "UPDATE_CALL", payload: data.call });
      }
    });

    return () => {
      socket.disconnect();
    };
  }, [socketManager]);

  const handleOpenAsteriskModal = () => {
    setSelectedAsterisk(null);
    setAsteriskModalOpen(true);
  };

  const handleCloseAsteriskModal = useCallback(() => {
    setAsteriskModalOpen(false);
    setSelectedAsterisk(null);
  }, []);

  const handleEditAsterisk = (asterisk) => {
    setSelectedAsterisk(asterisk);
    setAsteriskModalOpen(true);
  };

  const handleDeleteAsterisk = async (asteriskId) => {
    try {
      await api.delete(`/asterisks/${asteriskId}`);
      toast.success(i18n.t("asterisk.toasts.deleted"));
    } catch (err) {
      toastError(err);
    }
    setConfirmModalOpen(false);
    setSelectedAsterisk(null);
  };

  const handleConnect = async (asteriskId) => {
    setConnectingId(asteriskId);
    try {
      await api.post(`/asterisks/${asteriskId}/connect`);
      toast.success(i18n.t("asterisk.toasts.connected"));
    } catch (err) {
      toastError(err);
    }
    setConnectingId(null);
  };

  const handleDisconnect = async (asteriskId) => {
    setConnectingId(asteriskId);
    try {
      await api.post(`/asterisks/${asteriskId}/disconnect`);
      toast.success(i18n.t("asterisk.toasts.disconnected"));
    } catch (err) {
      toastError(err);
    }
    setConnectingId(null);
  };

  // Extension handlers
  const handleOpenExtensionModal = () => {
    setSelectedExtension(null);
    setExtensionModalOpen(true);
  };

  const handleCloseExtensionModal = useCallback(() => {
    setExtensionModalOpen(false);
    setSelectedExtension(null);
  }, []);

  const handleEditExtension = (extension) => {
    setSelectedExtension(extension);
    setExtensionModalOpen(true);
  };

  const handleDeleteExtension = async (extensionId) => {
    try {
      await api.delete(`/extensions/${extensionId}`);
      toast.success(i18n.t("extension.toasts.deleted"));
    } catch (err) {
      toastError(err);
    }
    setConfirmExtensionModalOpen(false);
    setSelectedExtension(null);
  };

  const handleTabChange = (event, newValue) => {
    setTabValue(newValue);
  };

  const formatDuration = (seconds) => {
    if (!seconds) return "00:00";
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins.toString().padStart(2, "0")}:${secs.toString().padStart(2, "0")}`;
  };

  const formatDateTime = (dateString) => {
    if (!dateString) return "-";
    try {
      return format(parseISO(dateString), "dd/MM/yyyy HH:mm", { locale: ptBR });
    } catch {
      return dateString;
    }
  };

  const renderStatus = (status) => {
    const statusConfig = {
      CONNECTED: { label: "Conectado", class: classes.connected, icon: CheckCircle },
      DISCONNECTED: { label: "Desconectado", class: classes.disconnected, icon: LinkOff },
      ERROR: { label: "Erro", class: classes.error, icon: Error },
      RECONNECTING: { label: "Reconectando", class: classes.reconnecting, icon: Warning },
    };

    const config = statusConfig[status] || statusConfig.DISCONNECTED;
    const Icon = config.icon;

    return (
      <Chip
        size="small"
        icon={<Icon style={{ color: "#fff" }} />}
        label={config.label}
        className={`${classes.chip} ${config.class}`}
      />
    );
  };

  return (
    <MainContainer>
      {/* Confirmation Modals */}
      <ConfirmationModal
        title={
          selectedAsterisk &&
          `${i18n.t("asterisk.confirmationModal.deleteTitle")} ${selectedAsterisk.name}?`
        }
        open={confirmModalOpen}
        onClose={() => setConfirmModalOpen(false)}
        onConfirm={() => handleDeleteAsterisk(selectedAsterisk.id)}
      >
        {i18n.t("asterisk.confirmationModal.deleteMessage")}
      </ConfirmationModal>

      <ConfirmationModal
        title={
          selectedExtension &&
          `Excluir ramal ${selectedExtension.exten}?`
        }
        open={confirmExtensionModalOpen}
        onClose={() => setConfirmExtensionModalOpen(false)}
        onConfirm={() => handleDeleteExtension(selectedExtension.id)}
      >
        Tem certeza que deseja excluir este ramal?
      </ConfirmationModal>

      {/* Modals */}
      <AsteriskModal
        open={asteriskModalOpen}
        onClose={handleCloseAsteriskModal}
        asteriskId={selectedAsterisk?.id}
      />

      <ExtensionModal
        open={extensionModalOpen}
        onClose={handleCloseExtensionModal}
        extensionId={selectedExtension?.id}
        asterisks={asterisks}
      />

      <MainHeader>
        <Title>{i18n.t("asterisk.title")} (VoIP)</Title>
        <MainHeaderButtonsWrapper>
          {tabValue === 0 && (
            <Button
              variant="contained"
              color="primary"
              onClick={handleOpenAsteriskModal}
              startIcon={<Settings />}
            >
              {i18n.t("asterisk.buttons.add")}
            </Button>
          )}
          {tabValue === 1 && (
            <Button
              variant="contained"
              color="primary"
              onClick={handleOpenExtensionModal}
              startIcon={<PersonAdd />}
            >
              Adicionar Ramal
            </Button>
          )}
          {tabValue === 2 && (
            <Button
              variant="contained"
              color="primary"
              onClick={fetchCalls}
              startIcon={<Refresh />}
            >
              Atualizar
            </Button>
          )}
        </MainHeaderButtonsWrapper>
      </MainHeader>

      <Paper className={classes.mainPaper} variant="outlined">
        <Tabs
          value={tabValue}
          onChange={handleTabChange}
          indicatorColor="primary"
          textColor="primary"
          className={classes.tabs}
        >
          <Tab label="Conexões" icon={<Settings />} />
          <Tab label="Ramais" icon={<Phone />} />
          <Tab label="Chamadas" icon={<PhoneCallback />} />
        </Tabs>

        {/* Tab 0: Conexões Asterisk */}
        <TabPanel value={tabValue} index={0}>
          <Table size="small">
            <TableHead>
              <TableRow>
                <TableCell align="center">{i18n.t("asterisk.table.name")}</TableCell>
                <TableCell align="center">{i18n.t("asterisk.table.host")}</TableCell>
                <TableCell align="center">Porta ARI</TableCell>
                <TableCell align="center">{i18n.t("asterisk.table.status")}</TableCell>
                <TableCell align="center">{i18n.t("asterisk.table.actions")}</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {loading ? (
                <TableRowSkeleton columns={5} />
              ) : (
                <>
                  {asterisks.length === 0 ? (
                    <TableRow>
                      <TableCell colSpan={5} align="center">
                        <Typography variant="body2" color="textSecondary">
                          {i18n.t("asterisk.table.empty")}
                        </Typography>
                      </TableCell>
                    </TableRow>
                  ) : (
                    asterisks.map((asterisk) => (
                      <TableRow key={asterisk.id}>
                        <TableCell align="center">
                          <div className={classes.customTableCell}>
                            <Phone style={{ marginRight: 8 }} />
                            {asterisk.name}
                          </div>
                        </TableCell>
                        <TableCell align="center">{asterisk.host}</TableCell>
                        <TableCell align="center">{asterisk.ariPort}</TableCell>
                        <TableCell align="center">
                          {renderStatus(asterisk.status)}
                        </TableCell>
                        <TableCell align="center">
                          {asterisk.status === "CONNECTED" ? (
                            <Tooltip title={i18n.t("asterisk.buttons.disconnect")}>
                              <IconButton
                                size="small"
                                onClick={() => handleDisconnect(asterisk.id)}
                                disabled={connectingId === asterisk.id}
                              >
                                {connectingId === asterisk.id ? (
                                  <CircularProgress size={24} className={classes.buttonProgress} />
                                ) : (
                                  <LinkOff />
                                )}
                              </IconButton>
                            </Tooltip>
                          ) : (
                            <Tooltip title={i18n.t("asterisk.buttons.connect")}>
                              <IconButton
                                size="small"
                                onClick={() => handleConnect(asterisk.id)}
                                disabled={connectingId === asterisk.id}
                              >
                                {connectingId === asterisk.id ? (
                                  <CircularProgress size={24} className={classes.buttonProgress} />
                                ) : (
                                  <LinkIcon color="primary" />
                                )}
                              </IconButton>
                            </Tooltip>
                          )}
                          <Tooltip title={i18n.t("asterisk.buttons.edit")}>
                            <IconButton
                              size="small"
                              onClick={() => handleEditAsterisk(asterisk)}
                            >
                              <Edit />
                            </IconButton>
                          </Tooltip>
                          <Tooltip title={i18n.t("asterisk.buttons.delete")}>
                            <IconButton
                              size="small"
                              onClick={() => {
                                setSelectedAsterisk(asterisk);
                                setConfirmModalOpen(true);
                              }}
                            >
                              <DeleteOutline />
                            </IconButton>
                          </Tooltip>
                        </TableCell>
                      </TableRow>
                    ))
                  )}
                </>
              )}
            </TableBody>
          </Table>
        </TabPanel>

        {/* Tab 1: Ramais */}
        <TabPanel value={tabValue} index={1}>
          <Table size="small">
            <TableHead>
              <TableRow>
                <TableCell align="center">Ramal</TableCell>
                <TableCell align="center">Nome</TableCell>
                <TableCell align="center">Usuário</TableCell>
                <TableCell align="center">Servidor</TableCell>
                <TableCell align="center">WebRTC</TableCell>
                <TableCell align="center">Status</TableCell>
                <TableCell align="center">Ações</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {loadingExtensions ? (
                <TableRowSkeleton columns={7} />
              ) : (
                <>
                  {extensions.length === 0 ? (
                    <TableRow>
                      <TableCell colSpan={7} align="center">
                        <Typography variant="body2" color="textSecondary">
                          Nenhum ramal cadastrado
                        </Typography>
                      </TableCell>
                    </TableRow>
                  ) : (
                    extensions.map((extension) => (
                      <TableRow key={extension.id}>
                        <TableCell align="center">
                          <strong>{extension.exten}</strong>
                        </TableCell>
                        <TableCell align="center">{extension.callerIdName || "-"}</TableCell>
                        <TableCell align="center">{extension.user?.name || "-"}</TableCell>
                        <TableCell align="center">{extension.asterisk?.name || "-"}</TableCell>
                        <TableCell align="center">
                          <Chip
                            size="small"
                            label={extension.webrtcEnabled ? "Sim" : "Não"}
                            color={extension.webrtcEnabled ? "primary" : "default"}
                          />
                        </TableCell>
                        <TableCell align="center">
                          {renderStatus(extension.status || "DISCONNECTED")}
                        </TableCell>
                        <TableCell align="center">
                          <Tooltip title="Editar">
                            <IconButton
                              size="small"
                              onClick={() => handleEditExtension(extension)}
                            >
                              <Edit />
                            </IconButton>
                          </Tooltip>
                          <Tooltip title="Excluir">
                            <IconButton
                              size="small"
                              onClick={() => {
                                setSelectedExtension(extension);
                                setConfirmExtensionModalOpen(true);
                              }}
                            >
                              <DeleteOutline />
                            </IconButton>
                          </Tooltip>
                        </TableCell>
                      </TableRow>
                    ))
                  )}
                </>
              )}
            </TableBody>
          </Table>
        </TabPanel>

        {/* Tab 2: Histórico de Chamadas */}
        <TabPanel value={tabValue} index={2}>
          {/* Stats Cards */}
          <Grid container spacing={2} className={classes.statsCard}>
            <Grid item xs={12} sm={6} md={3}>
              <Card>
                <CardContent>
                  <Typography className={classes.statsValue}>
                    {callStats.totalCalls || 0}
                  </Typography>
                  <Typography className={classes.statsLabel}>
                    <Phone style={{ marginRight: 8, verticalAlign: "middle" }} />
                    Total de Chamadas
                  </Typography>
                </CardContent>
              </Card>
            </Grid>
            <Grid item xs={12} sm={6} md={3}>
              <Card>
                <CardContent>
                  <Typography className={classes.statsValue} style={{ color: green[500] }}>
                    {callStats.answeredCalls || 0}
                  </Typography>
                  <Typography className={classes.statsLabel}>
                    <CheckCircle style={{ marginRight: 8, verticalAlign: "middle", color: green[500] }} />
                    Atendidas
                  </Typography>
                </CardContent>
              </Card>
            </Grid>
            <Grid item xs={12} sm={6} md={3}>
              <Card>
                <CardContent>
                  <Typography className={classes.statsValue} style={{ color: red[500] }}>
                    {callStats.missedCalls || 0}
                  </Typography>
                  <Typography className={classes.statsLabel}>
                    <PhoneMissed style={{ marginRight: 8, verticalAlign: "middle", color: red[500] }} />
                    Perdidas
                  </Typography>
                </CardContent>
              </Card>
            </Grid>
            <Grid item xs={12} sm={6} md={3}>
              <Card>
                <CardContent>
                  <Typography className={classes.statsValue} style={{ color: blue[500] }}>
                    {formatDuration(callStats.avgDuration || 0)}
                  </Typography>
                  <Typography className={classes.statsLabel}>
                    <Timer style={{ marginRight: 8, verticalAlign: "middle", color: blue[500] }} />
                    Duração Média
                  </Typography>
                </CardContent>
              </Card>
            </Grid>
          </Grid>

          {/* Filters */}
          <Box className={classes.filterContainer}>
            <TextField
              className={classes.searchField}
              placeholder="Buscar por número..."
              variant="outlined"
              size="small"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              InputProps={{
                startAdornment: (
                  <InputAdornment position="start">
                    <Search />
                  </InputAdornment>
                ),
              }}
            />
            <TextField
              type="date"
              variant="outlined"
              size="small"
              value={dateFilter}
              onChange={(e) => setDateFilter(e.target.value)}
              InputProps={{
                startAdornment: (
                  <InputAdornment position="start">
                    <Today />
                  </InputAdornment>
                ),
              }}
            />
          </Box>

          <Table size="small">
            <TableHead>
              <TableRow>
                <TableCell align="center">Data/Hora</TableCell>
                <TableCell align="center">Direção</TableCell>
                <TableCell align="center">Origem</TableCell>
                <TableCell align="center">Destino</TableCell>
                <TableCell align="center">Duração</TableCell>
                <TableCell align="center">Status</TableCell>
                <TableCell align="center">Atendente</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {loadingCalls ? (
                <TableRowSkeleton columns={7} />
              ) : (
                <>
                  {calls.length === 0 ? (
                    <TableRow>
                      <TableCell colSpan={7} align="center">
                        <Typography variant="body2" color="textSecondary">
                          Nenhuma chamada registrada
                        </Typography>
                      </TableCell>
                    </TableRow>
                  ) : (
                    calls.map((call) => (
                      <TableRow key={call.id}>
                        <TableCell align="center">
                          {formatDateTime(call.startedAt)}
                        </TableCell>
                        <TableCell align="center">
                          {call.direction === "inbound" ? (
                            <Chip
                              size="small"
                              icon={<PhoneCallback style={{ color: "#fff" }} />}
                              label="Entrada"
                              className={`${classes.chip} ${classes.inboundChip}`}
                            />
                          ) : (
                            <Chip
                              size="small"
                              icon={<PhoneForwarded style={{ color: "#fff" }} />}
                              label="Saída"
                              className={`${classes.chip} ${classes.outboundChip}`}
                            />
                          )}
                        </TableCell>
                        <TableCell align="center">
                          {call.callerName ? `${call.callerName} (${call.caller})` : call.caller}
                        </TableCell>
                        <TableCell align="center">{call.called}</TableCell>
                        <TableCell align="center">
                          <Timer style={{ marginRight: 4, verticalAlign: "middle", fontSize: 16 }} />
                          {formatDuration(call.duration)}
                        </TableCell>
                        <TableCell align="center">
                          <Chip
                            size="small"
                            label={
                              call.status === "completed" ? "Completada" :
                              call.status === "answered" ? "Atendida" :
                              call.status === "missed" ? "Perdida" :
                              call.status === "busy" ? "Ocupado" :
                              call.status === "failed" ? "Falhou" :
                              call.status === "ringing" ? "Tocando" : call.status
                            }
                            style={{
                              backgroundColor:
                                call.status === "completed" || call.status === "answered" ? green[500] :
                                call.status === "missed" || call.status === "failed" ? red[500] :
                                call.status === "busy" ? orange[500] : grey[500],
                              color: "#fff"
                            }}
                          />
                        </TableCell>
                        <TableCell align="center">
                          {call.user?.name || "-"}
                        </TableCell>
                      </TableRow>
                    ))
                  )}
                </>
              )}
            </TableBody>
          </Table>
        </TabPanel>
      </Paper>
    </MainContainer>
  );
};

export default Asterisk;
