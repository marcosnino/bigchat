import React, { useEffect, useState } from "react";

import {
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogContentText,
  DialogTitle,
  FormControl,
  FormHelperText,
  InputLabel,
  MenuItem,
  Select
} from "@material-ui/core";

import { i18n } from "../../translate/i18n";
import api from "../../services/api";
import toastError from "../../errors/toastError";

const CloseReasonDialog = ({ open, onClose, onConfirm }) => {
  const [reasons, setReasons] = useState([]);
  const [selectedReasonId, setSelectedReasonId] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    if (!open) {
      setReasons([]);
      setSelectedReasonId("");
      setError("");
      setLoading(false);
      return;
    }

    const fetchReasons = async () => {
      setLoading(true);
      try {
        const { data } = await api.get("/close-reasons", {
          params: { includeInactive: false }
        });
        setReasons(data.reasons || []);
      } catch (err) {
        toastError(err);
      } finally {
        setLoading(false);
      }
    };

    fetchReasons();
  }, [open]);

  const handleConfirm = () => {
    if (!selectedReasonId) {
      setError(i18n.t("closeReasonDialog.errors.required"));
      return;
    }
    setError("");
    onConfirm(selectedReasonId);
  };

  return (
    <Dialog
      open={open}
      onClose={onClose}
      maxWidth="xs"
      fullWidth
      scroll="paper"
    >
      <DialogTitle>{i18n.t("closeReasonDialog.title")}</DialogTitle>
      <DialogContent dividers>
        <DialogContentText>
          {i18n.t("closeReasonDialog.message")}
        </DialogContentText>
        <FormControl
          fullWidth
          margin="dense"
          variant="outlined"
          error={Boolean(error)}
          disabled={loading}
        >
          <InputLabel>{i18n.t("closeReasonDialog.form.reason")}</InputLabel>
          <Select
            value={selectedReasonId}
            onChange={(e) => {
              setSelectedReasonId(e.target.value);
              setError("");
            }}
            label={i18n.t("closeReasonDialog.form.reason")}
          >
            <MenuItem value="">
              {i18n.t("closeReasonDialog.form.placeholder")}
            </MenuItem>
            {reasons.map((reason) => (
              <MenuItem key={reason.id} value={reason.id}>
                {reason.name}
              </MenuItem>
            ))}
          </Select>
          {error && <FormHelperText>{error}</FormHelperText>}
        </FormControl>
      </DialogContent>
      <DialogActions>
        <Button onClick={onClose} color="default">
          {i18n.t("closeReasonDialog.buttons.cancel")}
        </Button>
        <Button onClick={handleConfirm} color="secondary" variant="contained">
          {i18n.t("closeReasonDialog.buttons.confirm")}
        </Button>
      </DialogActions>
    </Dialog>
  );
};

export default CloseReasonDialog;
