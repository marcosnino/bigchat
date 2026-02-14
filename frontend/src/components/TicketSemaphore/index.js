import React, { useState, useEffect } from 'react';
import { Tooltip, IconButton, Badge } from '@material-ui/core';
import {
  CheckCircle as CheckCircleIcon,
  Schedule as ScheduleIcon,
  Fiber as FiberIcon,
  Warning as WarningIcon
} from '@material-ui/icons';
import { makeStyles } from '@material-ui/core/styles';
import { green, red, orange, grey } from '@material-ui/core/colors';

const useStyles = makeStyles((theme) => ({
  semaphoreIcon: {
    width: 24,
    height: 24,
    borderRadius: '50%',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: theme.spacing(0.5)
  },
  greenLight: {
    backgroundColor: green[500],
    color: 'white',
    animation: '$pulse 2s infinite'
  },
  redLight: {
    backgroundColor: red[500],
    color: 'white', 
    animation: '$pulse 1s infinite'
  },
  orangeLight: {
    backgroundColor: orange[500],
    color: 'white'
  },
  greyLight: {
    backgroundColor: grey[400],
    color: 'white'
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
  }
}));

/**
 * Componente simples de semáforo para usar na lista de tickets
 */
const TicketSemaphore = ({ ticket }) => {
  const classes = useStyles();

  const getSemaphoreState = () => {
    if (!ticket) return 'normal';
    
    // Se tem mensagens pendentes do cliente
    if (ticket.pendingClientMessages > 0) {
      // Se a última mensagem do cliente foi há mais de 5 minutos
      const lastClientMessage = ticket.lastClientMessageAt ? new Date(ticket.lastClientMessageAt) : null;
      const now = new Date();
      
      if (lastClientMessage && (now - lastClientMessage) > 5 * 60 * 1000) {
        return 'waiting'; // Vermelho - aguardando resposta há muito tempo
      }
      return 'new'; // Verde - mensagens novas
    }
    
    return 'replied'; // Cinza - tudo respondido
  };

  const getSemaphoreProps = () => {
    const state = getSemaphoreState();
    const pendingCount = ticket?.pendingClientMessages || 0;
    
    switch (state) {
      case 'waiting':
        return {
          icon: <WarningIcon fontSize="small" />,
          className: classes.redLight,
          tooltip: `${pendingCount} mensagem(ns) aguardando resposta há mais de 5 minutos`,
          badgeContent: pendingCount
        };
      case 'new':
        return {
          icon: <FiberIcon fontSize="small" />,
          className: classes.greenLight,
          tooltip: `${pendingCount} nova(s) mensagem(ns) para responder`,
          badgeContent: pendingCount
        };
      case 'replied':
      default:
        return {
          icon: <CheckCircleIcon fontSize="small" />,
          className: classes.greyLight,
          tooltip: 'Todas as mensagens foram respondidas',
          badgeContent: 0
        };
    }
  };

  if (!ticket || ticket.status === 'closed') {
    return null;
  }

  const { icon, className, tooltip, badgeContent } = getSemaphoreProps();

  return (
    <Tooltip title={tooltip} placement="top">
      <Badge 
        badgeContent={badgeContent > 0 ? badgeContent : undefined}
        color="primary"
        max={99}
        overlap="circle"
      >
        <div className={`${classes.semaphoreIcon} ${className}`}>
          {icon}
        </div>
      </Badge>
    </Tooltip>
  );
};

export default TicketSemaphore;