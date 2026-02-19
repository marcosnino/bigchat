import React, { useEffect, useState } from "react";

import * as Yup from "yup";
import { Formik, Form, Field } from "formik";
import { toast } from "react-toastify";

import { makeStyles } from "@material-ui/core/styles";
import { green } from "@material-ui/core/colors";
import Button from "@material-ui/core/Button";
import TextField from "@material-ui/core/TextField";
import Dialog from "@material-ui/core/Dialog";
import DialogActions from "@material-ui/core/DialogActions";
import DialogContent from "@material-ui/core/DialogContent";
import DialogTitle from "@material-ui/core/DialogTitle";
import CircularProgress from "@material-ui/core/CircularProgress";
import FormControlLabel from "@material-ui/core/FormControlLabel";
import Switch from "@material-ui/core/Switch";

import { i18n } from "../../translate/i18n";
import api from "../../services/api";
import toastError from "../../errors/toastError";

const useStyles = makeStyles(theme => ({
  btnWrapper: {
    position: "relative",
  },
  buttonProgress: {
    color: green[500],
    position: "absolute",
    top: "50%",
    left: "50%",
    marginTop: -12,
    marginLeft: -12,
  },
}));

const CloseReasonSchema = Yup.object().shape({
  name: Yup.string().min(3, "Mensagem muito curta").required("Obrigatorio"),
});

const CloseReasonModal = ({ open, onClose, closeReasonId, reload }) => {
  const classes = useStyles();

  const initialState = {
    name: "",
    description: "",
    isActive: true,
  };

  const [closeReason, setCloseReason] = useState(initialState);

  useEffect(() => {
    try {
      (async () => {
        if (!closeReasonId) return;

        const { data } = await api.get(`/close-reasons/${closeReasonId}`);
        setCloseReason(prevState => ({ ...prevState, ...data }));
      })();
    } catch (err) {
      toastError(err);
    }
  }, [closeReasonId, open]);

  const handleClose = () => {
    setCloseReason(initialState);
    onClose();
  };

  const handleSaveCloseReason = async values => {
    const payload = {
      name: values.name,
      description: values.description,
      isActive: values.isActive,
    };

    try {
      if (closeReasonId) {
        await api.put(`/close-reasons/${closeReasonId}`, payload);
      } else {
        await api.post("/close-reasons", payload);
      }
      toast.success(i18n.t("closeReasonModal.success"));
      if (typeof reload === "function") {
        reload();
      }
    } catch (err) {
      toastError(err);
    }
    handleClose();
  };

  return (
    <Dialog
      open={open}
      onClose={handleClose}
      maxWidth="xs"
      fullWidth
      scroll="paper"
    >
      <DialogTitle id="form-dialog-title">
        {closeReasonId
          ? i18n.t("closeReasonModal.title.edit")
          : i18n.t("closeReasonModal.title.add")}
      </DialogTitle>
      <Formik
        initialValues={closeReason}
        enableReinitialize
        validationSchema={CloseReasonSchema}
        onSubmit={(values, actions) => {
          setTimeout(() => {
            handleSaveCloseReason(values);
            actions.setSubmitting(false);
          }, 400);
        }}
      >
        {({ touched, errors, isSubmitting, values, setFieldValue }) => (
          <Form>
            <DialogContent dividers>
              <Field
                as={TextField}
                label={i18n.t("closeReasonModal.form.name")}
                name="name"
                error={touched.name && Boolean(errors.name)}
                helperText={touched.name && errors.name}
                variant="outlined"
                margin="dense"
                fullWidth
              />
              <Field
                as={TextField}
                label={i18n.t("closeReasonModal.form.description")}
                name="description"
                variant="outlined"
                margin="dense"
                fullWidth
                multiline
                minRows={3}
              />
              <FormControlLabel
                control={
                  <Switch
                    checked={Boolean(values.isActive)}
                    onChange={(e) => setFieldValue("isActive", e.target.checked)}
                    color="primary"
                  />
                }
                label={i18n.t("closeReasonModal.form.isActive")}
              />
            </DialogContent>
            <DialogActions>
              <Button
                onClick={handleClose}
                color="secondary"
                disabled={isSubmitting}
                variant="outlined"
              >
                {i18n.t("closeReasonModal.buttons.cancel")}
              </Button>
              <Button
                type="submit"
                color="primary"
                disabled={isSubmitting}
                variant="contained"
                className={classes.btnWrapper}
              >
                {closeReasonId
                  ? i18n.t("closeReasonModal.buttons.okEdit")
                  : i18n.t("closeReasonModal.buttons.okAdd")}
                {isSubmitting && (
                  <CircularProgress size={24} className={classes.buttonProgress} />
                )}
              </Button>
            </DialogActions>
          </Form>
        )}
      </Formik>
    </Dialog>
  );
};

export default CloseReasonModal;
