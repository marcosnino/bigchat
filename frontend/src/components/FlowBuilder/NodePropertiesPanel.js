import React, { useState, useEffect } from "react";
import { makeStyles } from "@material-ui/core/styles";
import {
  Typography,
  TextField,
  Button,
  IconButton,
  Select,
  MenuItem,
  FormControl,
  InputLabel,
  Divider,
} from "@material-ui/core";
import CloseIcon from "@material-ui/icons/Close";
import DeleteIcon from "@material-ui/icons/Delete";
import AddIcon from "@material-ui/icons/Add";

const useStyles = makeStyles((theme) => ({
  drawer: {
    width: 320,
    flexShrink: 0,
  },
  drawerPaper: {
    width: 320,
    padding: theme.spacing(2),
    position: "relative",
    height: "100%",
    overflow: "auto",
  },
  header: {
    display: "flex",
    justifyContent: "space-between",
    alignItems: "center",
    marginBottom: theme.spacing(2),
  },
  field: {
    marginBottom: theme.spacing(2),
  },
  optionRow: {
    display: "flex",
    gap: 8,
    alignItems: "center",
    marginBottom: 8,
  },
  deleteBtn: {
    marginTop: theme.spacing(3),
  },
}));

const nodeLabels = {
  start: "Início",
  message: "Mensagem",
  condition: "Condição",
  delay: "Delay",
  menu: "Menu de Opções",
  transfer: "Transferir",
  waitInput: "Aguardar Resposta",
  tag: "Aplicar Tag",
  webhook: "Webhook",
  close: "Encerrar",
  openai: "OpenAI",
};

const NodePropertiesPanel = ({ node, onUpdate, onDelete, onClose }) => {
  const classes = useStyles();
  const [data, setData] = useState({});

  useEffect(() => {
    if (node) {
      setData({ ...node.data });
    }
  }, [node]);

  if (!node) return null;

  const handleChange = (field, value) => {
    const newData = { ...data, [field]: value };
    setData(newData);
    onUpdate(node.id, newData);
  };

  const renderFields = () => {
    switch (node.type) {
      case "start":
        return (
          <TextField
            className={classes.field}
            label="Descrição"
            value={data.label || ""}
            onChange={(e) => handleChange("label", e.target.value)}
            fullWidth
            variant="outlined"
            size="small"
          />
        );

      case "message":
        return (
          <>
            <TextField
              className={classes.field}
              label="Mensagem"
              value={data.message || ""}
              onChange={(e) => handleChange("message", e.target.value)}
              fullWidth
              multiline
              rows={4}
              variant="outlined"
              size="small"
              placeholder="Digite a mensagem que será enviada..."
              helperText="Use {nome} para nome do contato"
            />
            <TextField
              className={classes.field}
              label="URL da Mídia (opcional)"
              value={data.mediaUrl || ""}
              onChange={(e) => handleChange("mediaUrl", e.target.value)}
              fullWidth
              variant="outlined"
              size="small"
              placeholder="https://..."
            />
          </>
        );

      case "condition":
        return (
          <>
            <FormControl
              className={classes.field}
              fullWidth
              variant="outlined"
              size="small"
            >
              <InputLabel>Campo</InputLabel>
              <Select
                value={data.field || "message"}
                onChange={(e) => handleChange("field", e.target.value)}
                label="Campo"
              >
                <MenuItem value="message">Mensagem do cliente</MenuItem>
                <MenuItem value="contactName">Nome do contato</MenuItem>
                <MenuItem value="hour">Hora atual</MenuItem>
                <MenuItem value="weekday">Dia da semana</MenuItem>
              </Select>
            </FormControl>
            <FormControl
              className={classes.field}
              fullWidth
              variant="outlined"
              size="small"
            >
              <InputLabel>Operador</InputLabel>
              <Select
                value={data.operator || "contains"}
                onChange={(e) => handleChange("operator", e.target.value)}
                label="Operador"
              >
                <MenuItem value="contains">Contém</MenuItem>
                <MenuItem value="equals">Igual a</MenuItem>
                <MenuItem value="startsWith">Começa com</MenuItem>
                <MenuItem value="greaterThan">Maior que</MenuItem>
                <MenuItem value="lessThan">Menor que</MenuItem>
              </Select>
            </FormControl>
            <TextField
              className={classes.field}
              label="Valor"
              value={data.value || ""}
              onChange={(e) => handleChange("value", e.target.value)}
              fullWidth
              variant="outlined"
              size="small"
            />
            <TextField
              className={classes.field}
              label="Resumo da condição"
              value={data.condition || ""}
              onChange={(e) => handleChange("condition", e.target.value)}
              fullWidth
              variant="outlined"
              size="small"
              placeholder="Ex: Mensagem contém 'oi'"
            />
          </>
        );

      case "delay":
        return (
          <TextField
            className={classes.field}
            label="Tempo (segundos)"
            type="number"
            value={data.seconds || 0}
            onChange={(e) => handleChange("seconds", parseInt(e.target.value) || 0)}
            fullWidth
            variant="outlined"
            size="small"
            inputProps={{ min: 0 }}
          />
        );

      case "menu":
        return (
          <>
            <TextField
              className={classes.field}
              label="Título do Menu"
              value={data.title || ""}
              onChange={(e) => handleChange("title", e.target.value)}
              fullWidth
              variant="outlined"
              size="small"
              placeholder="Escolha uma opção:"
            />
            <Typography variant="subtitle2" gutterBottom>
              Opções:
            </Typography>
            {(data.options || []).map((opt, idx) => (
              <div key={idx} className={classes.optionRow}>
                <TextField
                  label="Tecla"
                  value={opt.key}
                  onChange={(e) => {
                    const opts = [...(data.options || [])];
                    opts[idx] = { ...opts[idx], key: e.target.value };
                    handleChange("options", opts);
                  }}
                  variant="outlined"
                  size="small"
                  style={{ width: 60 }}
                />
                <TextField
                  label="Texto"
                  value={opt.text}
                  onChange={(e) => {
                    const opts = [...(data.options || [])];
                    opts[idx] = { ...opts[idx], text: e.target.value };
                    handleChange("options", opts);
                  }}
                  variant="outlined"
                  size="small"
                  style={{ flex: 1 }}
                />
                <IconButton
                  size="small"
                  onClick={() => {
                    const opts = (data.options || []).filter((_, i) => i !== idx);
                    handleChange("options", opts);
                  }}
                >
                  <DeleteIcon fontSize="small" />
                </IconButton>
              </div>
            ))}
            <Button
              size="small"
              startIcon={<AddIcon />}
              onClick={() => {
                const opts = [...(data.options || [])];
                opts.push({ key: `${opts.length + 1}`, text: "" });
                handleChange("options", opts);
              }}
            >
              Adicionar Opção
            </Button>
          </>
        );

      case "transfer":
        return (
          <>
            <TextField
              className={classes.field}
              label="Nome da Fila"
              value={data.queueName || ""}
              onChange={(e) => handleChange("queueName", e.target.value)}
              fullWidth
              variant="outlined"
              size="small"
            />
            <TextField
              className={classes.field}
              label="ID da Fila"
              type="number"
              value={data.queueId || ""}
              onChange={(e) => handleChange("queueId", parseInt(e.target.value) || "")}
              fullWidth
              variant="outlined"
              size="small"
            />
            <TextField
              className={classes.field}
              label="Nome do Atendente (opcional)"
              value={data.userName || ""}
              onChange={(e) => handleChange("userName", e.target.value)}
              fullWidth
              variant="outlined"
              size="small"
            />
            <TextField
              className={classes.field}
              label="ID do Atendente (opcional)"
              type="number"
              value={data.userId || ""}
              onChange={(e) => handleChange("userId", parseInt(e.target.value) || "")}
              fullWidth
              variant="outlined"
              size="small"
            />
          </>
        );

      case "waitInput":
        return (
          <TextField
            className={classes.field}
            label="Timeout (segundos, 0 = sem limite)"
            type="number"
            value={data.timeout || 0}
            onChange={(e) => handleChange("timeout", parseInt(e.target.value) || 0)}
            fullWidth
            variant="outlined"
            size="small"
            inputProps={{ min: 0 }}
            helperText="Saída 'resposta' quando responder, 'timeout' quando expirar"
          />
        );

      case "tag":
        return (
          <>
            <TextField
              className={classes.field}
              label="Nome da Tag"
              value={data.tagName || ""}
              onChange={(e) => handleChange("tagName", e.target.value)}
              fullWidth
              variant="outlined"
              size="small"
            />
            <TextField
              className={classes.field}
              label="ID da Tag"
              type="number"
              value={data.tagId || ""}
              onChange={(e) => handleChange("tagId", parseInt(e.target.value) || "")}
              fullWidth
              variant="outlined"
              size="small"
            />
          </>
        );

      case "webhook":
        return (
          <>
            <FormControl
              className={classes.field}
              fullWidth
              variant="outlined"
              size="small"
            >
              <InputLabel>Método</InputLabel>
              <Select
                value={data.method || "POST"}
                onChange={(e) => handleChange("method", e.target.value)}
                label="Método"
              >
                <MenuItem value="GET">GET</MenuItem>
                <MenuItem value="POST">POST</MenuItem>
                <MenuItem value="PUT">PUT</MenuItem>
                <MenuItem value="PATCH">PATCH</MenuItem>
              </Select>
            </FormControl>
            <TextField
              className={classes.field}
              label="URL"
              value={data.url || ""}
              onChange={(e) => handleChange("url", e.target.value)}
              fullWidth
              variant="outlined"
              size="small"
              placeholder="https://api.example.com/webhook"
            />
            <TextField
              className={classes.field}
              label="Headers (JSON)"
              value={data.headers || ""}
              onChange={(e) => handleChange("headers", e.target.value)}
              fullWidth
              multiline
              rows={2}
              variant="outlined"
              size="small"
              placeholder='{"Authorization": "Bearer ..."}'
            />
            <TextField
              className={classes.field}
              label="Body (JSON)"
              value={data.body || ""}
              onChange={(e) => handleChange("body", e.target.value)}
              fullWidth
              multiline
              rows={3}
              variant="outlined"
              size="small"
              placeholder='{"key": "value"}'
            />
          </>
        );

      case "close":
        return (
          <TextField
            className={classes.field}
            label="Mensagem de Despedida (opcional)"
            value={data.farewellMessage || ""}
            onChange={(e) => handleChange("farewellMessage", e.target.value)}
            fullWidth
            multiline
            rows={2}
            variant="outlined"
            size="small"
          />
        );

      case "openai":
        return (
          <>
            <TextField
              className={classes.field}
              label="Nome do Prompt"
              value={data.promptName || ""}
              onChange={(e) => handleChange("promptName", e.target.value)}
              fullWidth
              variant="outlined"
              size="small"
            />
            <TextField
              className={classes.field}
              label="Prompt customizado"
              value={data.prompt || ""}
              onChange={(e) => handleChange("prompt", e.target.value)}
              fullWidth
              multiline
              rows={4}
              variant="outlined"
              size="small"
              placeholder="Você é um assistente..."
            />
          </>
        );

      default:
        return <Typography>Sem propriedades configuráveis</Typography>;
    }
  };

  return (
    <div className={classes.drawer}>
      <div className={classes.drawerPaper}>
        <div className={classes.header}>
          <Typography variant="h6">
            {nodeLabels[node.type] || node.type}
          </Typography>
          <IconButton size="small" onClick={onClose}>
            <CloseIcon />
          </IconButton>
        </div>
        <Divider style={{ marginBottom: 16 }} />
        {renderFields()}
        {node.type !== "start" && (
          <Button
            className={classes.deleteBtn}
            variant="outlined"
            color="secondary"
            startIcon={<DeleteIcon />}
            onClick={() => onDelete(node.id)}
            fullWidth
          >
            Remover Node
          </Button>
        )}
      </div>
    </div>
  );
};

export default NodePropertiesPanel;
