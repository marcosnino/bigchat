import React, { useState, useEffect } from "react";
import {
  Box,
  Chip,
  Tooltip,
  IconButton,
  Badge
} from "@mui/material";
import {
  CheckCircle as CheckCircleIcon,
  Warning as WarningIcon,
  Error as ErrorIcon
} from "@mui/icons-material";
import api from "../../services/api";

const QueueValidationIndicator = ({ whatsAppId, showLabel = false, compact = false }) => {
  const [status, setStatus] = useState("loading");
  const [details, setDetails] = useState("");
  const [queueCount, setQueueCount] = useState(0);

  useEffect(() => {
    const checkValidation = async () => {
      try {
        const response = await api.get("/validation/whatsapp-queue/report/whatsapps");
        const whatsApps = response.data.data;
        
        const currentWhatsApp = whatsApps.find(wa => wa.whatsAppId === whatsAppId);
        
        if (currentWhatsApp) {
          const queues = currentWhatsApp.queues || [];
          setQueueCount(queues.length);
          
          if (queues.length === 0) {
            setStatus("error");
            setDetails("WhatsApp sem filas vinculadas");
          } else {
            setStatus("success");
            setDetails(`${queues.length} fila(s) vinculada(s): ${queues.map(q => q.name).join(", ")}`);
          }
        } else {
          setStatus("error");
          setDetails("WhatsApp não encontrado");
        }
      } catch (error) {
        setStatus("error");
        setDetails("Erro ao verificar validação");
      }
    };

    if (whatsAppId) {
      checkValidation();
    }
  }, [whatsAppId]);

  if (status === "loading") {
    return null;
  }

  const getIcon = () => {
    switch (status) {
      case "success":
        return <CheckCircleIcon color="success" />;
      case "error":
        return <ErrorIcon color="error" />;
      case "warning":
        return <WarningIcon color="warning" />;
      default:
        return <WarningIcon color="disabled" />;
    }
  };

  const getColor = () => {
    switch (status) {
      case "success":
        return "success";
      case "error":
        return "error";
      case "warning":
        return "warning";
      default:
        return "default";
    }
  };

  if (compact) {
    return (
      <Tooltip title={details} arrow>
        <Badge 
          badgeContent={queueCount} 
          color={queueCount > 0 ? "success" : "error"}
          showZero
        >
          <IconButton size="small">
            {getIcon()}
          </IconButton>
        </Badge>
      </Tooltip>
    );
  }

  if (showLabel) {
    return (
      <Tooltip title={details} arrow>
        <Box display="flex" alignItems="center" gap={1}>
          {getIcon()}
          <Chip
            label={`${queueCount} fila(s)`}
            size="small"
            color={getColor()}
            variant={status === "success" ? "filled" : "outlined"}
          />
        </Box>
      </Tooltip>
    );
  }

  return (
    <Tooltip title={details} arrow>
      {getIcon()}
    </Tooltip>
  );
};

export default QueueValidationIndicator;