import React, { useState, useEffect } from 'react';
import {
  Badge,
  Box,
  Chip,
  IconButton,
  Tooltip,
  Typography,
  Card,
  CardContent,
  Grid,
  CircularProgress
} from '@material-ui/core';
import {
  CheckCircle as CheckCircleIcon,
  Schedule as ScheduleIcon,
  Fiber as FiberIcon,
  Refresh as RefreshIcon,
  Assessment as AssessmentIcon
} from '@material-ui/icons';
import { makeStyles } from '@material-ui/core/styles';
import { green, red, orange, grey } from '@material-ui/core/colors';
import api from '../../services/api';
import { toast } from 'react-toastify';

const useStyles = makeStyles((theme) => ({
  root: {
    padding: theme.spacing(1),
    marginBottom: theme.spacing(2)
  },
  semaphoreContainer: {
    display: 'flex',
    alignItems: 'center',
    gap: theme.spacing(1)
  },
  greenLight: {
    backgroundColor: green[500],
    animation: '$pulse 2s infinite'
  },
  redLight: {
    backgroundColor: red[500], 
    animation: '$pulse 1s infinite'
  },
  orangeLight: {
    backgroundColor: orange[500]
  },
  greyLight: {
    backgroundColor: grey[400]
  },
  '@keyframes pulse': {
    '0%': {
      transform: 'scale(1)',
      opacity: 1,
    },
    '50%': {
      transform: 'scale(1.1)',
      opacity: 0.8,
    },
    '100%': {
      transform: 'scale(1)',
      opacity: 1,
    }
  },
  statsCard: {
    backgroundColor: theme.palette.background.paper,
    borderRadius: theme.spacing(1),
    marginBottom: theme.spacing(1)
  },
  statChip: {
    margin: theme.spacing(0.5)
  }
}));

const MessageSemaphore = ({ ticketId, companyId, compact = false }) => {
  const classes = useStyles();
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(false);
  const [globalStats, setGlobalStats] = useState(null);

  useEffect(() => {
    if (ticketId) {
      fetchTicketStats();
    }
    fetchGlobalStats();
  }, [ticketId]);

  const fetchTicketStats = async () => {
    try {
      setLoading(true);
      const { data } = await api.get(`/tickets/${ticketId}/semaphore/stats`);
      setStats(data);
    } catch (error) {
      console.error('Erro ao buscar estatísticas do semáforo:', error);
    } finally {
      setLoading(false);
    }
  };

  const fetchGlobalStats = async () => {
    try {
      const { data } = await api.get('/semaphore/stats');
      setGlobalStats(data);
    } catch (error) {
      console.error('Erro ao buscar estatísticas globais:', error);
    }
  };

  const handleMarkAsReplied = async () => {
    try {
      await api.put(`/tickets/${ticketId}/semaphore/mark-replied`);
      toast.success('Mensagens marcadas como respondidas!');
      fetchTicketStats();
    } catch (error) {
      toast.error('Erro ao marcar mensagens como respondidas');
    }
  };

  const handleResetSemaphore = async () => {
    try {
      await api.put(`/tickets/${ticketId}/semaphore/reset`);
      toast.success('Semáforo resetado!');
      fetchTicketStats();
    } catch (error) {
      toast.error('Erro ao resetar semáforo');
    }
  };

  const getSemaphoreColor = () => {
    if (!stats) return classes.greyLight;
    
    if (stats.waitingMessages > 0) {
      return classes.redLight; // Vermelho - mensagens aguardando resposta
    }
    if (stats.newMessages > 0) {
      return classes.greenLight; // Verde - mensagens novas
    }
    return classes.greyLight; // Cinza - tudo respondido
  };

  const getSemaphoreIcon = () => {
    if (!stats) return <FiberIcon />;
    
    if (stats.waitingMessages > 0) {
      return <ScheduleIcon />;
    }
    if (stats.newMessages > 0) {
      return <FiberIcon />;
    }
    return <CheckCircleIcon />;
  };

  const getSemaphoreTooltip = () => {
    if (!stats) return 'Carregando...';
    
    if (stats.waitingMessages > 0) {
      return `${stats.waitingMessages} mensagem(ns) aguardando resposta há mais de 5 minutos`;
    }
    if (stats.newMessages > 0) {
      return `${stats.newMessages} mensagem(ns) nova(s) para responder`;
    }
    return 'Todas as mensagens foram respondidas';
  };

  const formatTime = (seconds) => {
    if (!seconds) return 'N/A';
    
    if (seconds < 60) return `${seconds}s`;
    if (seconds < 3600) return `${Math.round(seconds / 60)}m`;
    return `${Math.round(seconds / 3600)}h`;
  };

  if (compact) {
    return (
      <Box className={classes.semaphoreContainer}>
        <Tooltip title={getSemaphoreTooltip()}>
          <Badge 
            badgeContent={stats?.newMessages + stats?.waitingMessages || 0}
            color="primary"
            max={99}
          >
            <IconButton size="small" className={getSemaphoreColor()}>
              {getSemaphoreIcon()}
            </IconButton>
          </Badge>
        </Tooltip>
      </Box>
    );
  }

  return (
    <Card className={classes.statsCard} elevation={2}>
      <CardContent>
        <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
          <Typography variant="h6" style={{ display: 'flex', alignItems: 'center' }}>
            <AssessmentIcon style={{ marginRight: 8 }} />
            Semáforo de Mensagens
          </Typography>
          <Box>
            <Tooltip title="Atualizar">
              <IconButton size="small" onClick={fetchTicketStats} disabled={loading}>
                {loading ? <CircularProgress size={20} /> : <RefreshIcon />}
              </IconButton>
            </Tooltip>
          </Box>
        </Box>

        {ticketId && stats && (
          <Grid container spacing={2} style={{ marginBottom: 16 }}>
            <Grid item xs={12}>
              <Box display="flex" alignItems="center" justifyContent="center" style={{ marginBottom: 16 }}>
                <Tooltip title={getSemaphoreTooltip()}>
                  <IconButton className={getSemaphoreColor()} style={{ width: 60, height: 60 }}>
                    {getSemaphoreIcon()}
                  </IconButton>
                </Tooltip>
              </Box>
            </Grid>
            
            <Grid item xs={4}>
              <Chip 
                icon={<FiberIcon />}
                label={`${stats.newMessages} Novas`}
                color="primary"
                variant="outlined"
                className={classes.statChip}
              />
            </Grid>
            
            <Grid item xs={4}>
              <Chip 
                icon={<ScheduleIcon />}
                label={`${stats.waitingMessages} Aguardando`}
                color="secondary"
                variant="outlined"
                className={classes.statChip}
              />
            </Grid>
            
            <Grid item xs={4}>
              <Chip 
                icon={<CheckCircleIcon />}
                label={`${stats.repliedMessages} Respondidas`}
                color="default"
                variant="outlined"
                className={classes.statChip}
              />
            </Grid>
          </Grid>
        )}

        {stats && (
          <Box display="flex" justifyContent="space-between" style={{ marginTop: 16 }}>
            <Typography variant="caption" color="textSecondary">
              Tempo médio de resposta: {formatTime(stats.averageResponseTime)}
            </Typography>
            
            {ticketId && (
              <Box>
                <Tooltip title="Marcar como respondidas">
                  <IconButton 
                    size="small" 
                    onClick={handleMarkAsReplied}
                    disabled={!stats.newMessages && !stats.waitingMessages}
                  >
                    <CheckCircleIcon />
                  </IconButton>
                </Tooltip>
                <Tooltip title="Resetar semáforo">
                  <IconButton size="small" onClick={handleResetSemaphore}>
                    <RefreshIcon />
                  </IconButton>
                </Tooltip>
              </Box>
            )}
          </Box>
        )}

        {globalStats && (
          <Box mt={2} pt={2} style={{ borderTop: '1px solid #eee' }}>
            <Typography variant="subtitle2" gutterBottom>
              Estatísticas Globais
            </Typography>
            <Box display="flex" flexWrap="wrap">
              <Chip 
                label={`${globalStats.totalNewMessages} novas`}
                size="small" 
                style={{ margin: 4, backgroundColor: green[100] }}
              />
              <Chip 
                label={`${globalStats.totalWaitingMessages} aguardando`}
                size="small"
                style={{ margin: 4, backgroundColor: red[100] }}
              />
              <Chip 
                label={`${globalStats.ticketsWithPendingMessages} tickets pendentes`}
                size="small"
                style={{ margin: 4, backgroundColor: orange[100] }}
              />
            </Box>
            <Typography variant="caption" color="textSecondary" style={{ marginTop: 8, display: 'block' }}>
              Tempo médio global: {formatTime(globalStats.averageResponseTime)}
            </Typography>
          </Box>
        )}
      </CardContent>
    </Card>
  );
};

export default MessageSemaphore;