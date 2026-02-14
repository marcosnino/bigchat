import React, { useEffect, useState } from "react";
import { makeStyles } from "@material-ui/core/styles";
import {
  Typography,
  Paper,
  List,
  ListItem,
  ListItemText,
  ListItemIcon,
  Divider,
  CircularProgress,
  Chip,
  Collapse,
  IconButton,
  Tooltip,
  Box,
} from "@material-ui/core";
import {
  History as HistoryIcon,
  Person as PersonIcon,
  AccessTime as TimeIcon,
  ExpandMore as ExpandMoreIcon,
  ExpandLess as ExpandLessIcon,
  CheckCircle as CheckCircleIcon,
  SwapHoriz as TransferIcon,
  Chat as ChatIcon,
} from "@material-ui/icons";
import { green, orange, red, grey } from "@material-ui/core/colors";

import { i18n } from "../../translate/i18n";
import api from "../../services/api";
import toastError from "../../errors/toastError";

const useStyles = makeStyles((theme) => ({
  container: {
    marginTop: 8,
    padding: 8,
  },
  headerRow: {
    display: "flex",
    alignItems: "center",
    justifyContent: "space-between",
    cursor: "pointer",
    padding: "4px 0",
  },
  headerTitle: {
    display: "flex",
    alignItems: "center",
    gap: 6,
  },
  historyList: {
    padding: 0,
  },
  historyItem: {
    paddingLeft: 4,
    paddingRight: 4,
    borderLeft: `3px solid ${theme.palette.primary.main}`,
    marginBottom: 6,
    borderRadius: 4,
    backgroundColor: theme.palette.background.default,
  },
  statusChip: {
    height: 20,
    fontSize: 10,
  },
  closedChip: {
    backgroundColor: green[100],
    color: green[800],
  },
  transferredChip: {
    backgroundColor: orange[100],
    color: orange[800],
  },
  emptyText: {
    textAlign: "center",
    padding: "12px 0",
    color: grey[500],
    fontSize: 13,
  },
  timelineDate: {
    fontSize: 11,
    color: grey[600],
  },
  durationText: {
    fontSize: 11,
    color: grey[500],
    display: "flex",
    alignItems: "center",
    gap: 4,
  },
  badge: {
    marginLeft: 8,
    height: 20,
    minWidth: 20,
    fontSize: 11,
    backgroundColor: theme.palette.primary.main,
    color: "#fff",
  },
  loadingContainer: {
    display: "flex",
    justifyContent: "center",
    padding: 16,
  },
  metaRow: {
    display: "flex",
    alignItems: "center",
    gap: 8,
    marginTop: 2,
    flexWrap: "wrap",
  },
  metaItem: {
    display: "flex",
    alignItems: "center",
    gap: 2,
    fontSize: 11,
    color: grey[600],
  },
}));

const formatDuration = (seconds) => {
  if (!seconds || seconds <= 0) return "< 1min";
  const hrs = Math.floor(seconds / 3600);
  const mins = Math.floor((seconds % 3600) / 60);
  if (hrs > 0) return `${hrs}h ${mins}min`;
  return `${mins}min`;
};

const formatDate = (dateStr) => {
  if (!dateStr) return "-";
  const d = new Date(dateStr);
  return d.toLocaleDateString("pt-BR", {
    day: "2-digit",
    month: "2-digit",
    year: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
  });
};

const TicketHandoffHistory = ({ contactId, ticketId }) => {
  const classes = useStyles();
  const [history, setHistory] = useState([]);
  const [loading, setLoading] = useState(false);
  const [expanded, setExpanded] = useState(false);

  useEffect(() => {
    if (!contactId) return;

    const fetchHistory = async () => {
      setLoading(true);
      try {
        const { data } = await api.get(`/closed-tickets/by-contact/${contactId}`);
        if (data.success) {
          setHistory(data.data || []);
        }
      } catch (err) {
        // Silently fail if no history found - it's expected for new contacts
        console.log("No handoff history found:", err?.response?.status);
      }
      setLoading(false);
    };

    fetchHistory();
  }, [contactId]);

  const toggleExpanded = () => {
    setExpanded(!expanded);
  };

  return (
    <Paper square variant="outlined" className={classes.container}>
      <div className={classes.headerRow} onClick={toggleExpanded}>
        <div className={classes.headerTitle}>
          <HistoryIcon fontSize="small" color="primary" />
          <Typography variant="subtitle1">
            {i18n.t("handoffHistory.title")}
          </Typography>
          {history.length > 0 && (
            <Chip
              label={history.length}
              size="small"
              className={classes.badge}
            />
          )}
        </div>
        <IconButton size="small">
          {expanded ? <ExpandLessIcon /> : <ExpandMoreIcon />}
        </IconButton>
      </div>

      <Collapse in={expanded}>
        {loading ? (
          <div className={classes.loadingContainer}>
            <CircularProgress size={24} />
          </div>
        ) : history.length === 0 ? (
          <Typography className={classes.emptyText}>
            {i18n.t("handoffHistory.empty")}
          </Typography>
        ) : (
          <List dense className={classes.historyList}>
            {history.map((record, index) => (
              <React.Fragment key={record.id}>
                <ListItem className={classes.historyItem}>
                  <ListItemIcon style={{ minWidth: 32 }}>
                    <Tooltip title={record.finalStatus === "closed" ? i18n.t("handoffHistory.closed") : i18n.t("handoffHistory.transferred")}>
                      {record.finalStatus === "closed" ? (
                        <CheckCircleIcon fontSize="small" style={{ color: green[600] }} />
                      ) : (
                        <TransferIcon fontSize="small" style={{ color: orange[600] }} />
                      )}
                    </Tooltip>
                  </ListItemIcon>
                  <ListItemText
                    primary={
                      <Box display="flex" alignItems="center" justifyContent="space-between">
                        <Typography variant="body2" style={{ fontWeight: 500, fontSize: 13 }}>
                          {record.user?.name || i18n.t("handoffHistory.noAgent")}
                        </Typography>
                        <Chip
                          label={record.finalStatus === "closed" 
                            ? i18n.t("handoffHistory.closed") 
                            : i18n.t("handoffHistory.transferred")}
                          size="small"
                          className={`${classes.statusChip} ${
                            record.finalStatus === "closed" 
                              ? classes.closedChip 
                              : classes.transferredChip
                          }`}
                        />
                      </Box>
                    }
                    secondary={
                      <>
                        <Typography className={classes.timelineDate}>
                          {formatDate(record.ticketOpenedAt)} → {formatDate(record.ticketClosedAt)}
                        </Typography>
                        <div className={classes.metaRow}>
                          <span className={classes.metaItem}>
                            <TimeIcon style={{ fontSize: 13 }} />
                            {formatDuration(record.durationSeconds)}
                          </span>
                          <span className={classes.metaItem}>
                            <ChatIcon style={{ fontSize: 13 }} />
                            {record.totalMessages || 0} {i18n.t("handoffHistory.messages")}
                          </span>
                          {record.queue && (
                            <Chip
                              label={record.queue.name}
                              size="small"
                              style={{
                                height: 16,
                                fontSize: 10,
                                backgroundColor: record.queue.color || grey[300],
                                color: "#fff",
                              }}
                            />
                          )}
                        </div>
                        {record.closureReason && (
                          <Typography style={{ fontSize: 11, fontStyle: "italic", color: grey[500], marginTop: 2 }}>
                            {record.closureReason}
                          </Typography>
                        )}
                      </>
                    }
                  />
                </ListItem>
                {index < history.length - 1 && <Divider variant="inset" component="li" />}
              </React.Fragment>
            ))}
          </List>
        )}
      </Collapse>
    </Paper>
  );
};

export default TicketHandoffHistory;
