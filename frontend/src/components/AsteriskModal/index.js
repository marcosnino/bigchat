import React, { useState, useEffect } from "react";
import * as Yup from "yup";
import { Formik, Form, Field } from "formik";
import { toast } from "react-toastify";

import { makeStyles } from "@material-ui/core/styles";
import { green } from "@material-ui/core/colors";

import {
  Dialog,
  DialogContent,
  DialogTitle,
  Button,
  DialogActions,
  CircularProgress,
  TextField,
  Switch,
  FormControlLabel,
  Grid,
} from "@material-ui/core";

import api from "../../services/api";
import { i18n } from "../../translate/i18n";
import toastError from "../../errors/toastError";

const useStyles = makeStyles((theme) => ({
  root: {
    display: "flex",
    flexWrap: "wrap",
  },
  multFieldLine: {
    display: "flex",
    "& > *:not(:last-child)": {
      marginRight: theme.spacing(1),
    },
  },
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

const AsteriskSchema = Yup.object().shape({
  name: Yup.string()
    .min(2, "Nome muito curto")
    .max(50, "Nome muito longo")
    .required("Nome é obrigatório"),
  host: Yup.string()
    .required("Host é obrigatório"),
  ariUser: Yup.string()
    .required("Usuário ARI é obrigatório"),
  ariPassword: Yup.string()
    .required("Senha ARI é obrigatória"),
  ariPort: Yup.number()
    .min(1, "Porta inválida")
    .max(65535, "Porta inválida"),
  sipPort: Yup.number()
    .min(1, "Porta inválida")
    .max(65535, "Porta inválida"),
  wsPort: Yup.number()
    .min(1, "Porta inválida")
    .max(65535, "Porta inválida"),
});

const AsteriskModal = ({ open, onClose, asteriskId }) => {
  const classes = useStyles();
  const [asterisk, setAsterisk] = useState(null);
  const [loading, setLoading] = useState(false);

  const initialValues = {
    name: "",
    host: "",
    ariPort: 8088,
    sipPort: 5060,
    wsPort: 8089,
    ariUser: "",
    ariPassword: "",
    ariApplication: "bigchat",
    isActive: false,
    useSSL: false,
    sipDomain: "",
    outboundContext: "from-internal",
    inboundContext: "from-internal",
    notes: "",
  };

  useEffect(() => {
    const fetchAsterisk = async () => {
      if (!asteriskId) {
        setAsterisk(null);
        return;
      }

      setLoading(true);
      try {
        const { data } = await api.get(`/asterisks/${asteriskId}`);
        setAsterisk(data);
      } catch (err) {
        toastError(err);
      }
      setLoading(false);
    };

    fetchAsterisk();
  }, [asteriskId, open]);

  const handleClose = () => {
    setAsterisk(null);
    onClose();
  };

  const handleSaveAsterisk = async (values) => {
    try {
      if (asteriskId) {
        await api.put(`/asterisks/${asteriskId}`, values);
        toast.success(i18n.t("asterisk.toasts.updated"));
      } else {
        await api.post("/asterisks", values);
        toast.success(i18n.t("asterisk.toasts.created"));
      }
      handleClose();
    } catch (err) {
      toastError(err);
    }
  };

  return (
    <Dialog
      open={open}
      onClose={handleClose}
      maxWidth="md"
      fullWidth
      scroll="paper"
    >
      <DialogTitle>
        {asteriskId
          ? i18n.t("asterisk.modal.edit")
          : i18n.t("asterisk.modal.add")}
      </DialogTitle>
      <Formik
        initialValues={asterisk || initialValues}
        enableReinitialize
        validationSchema={AsteriskSchema}
        onSubmit={(values, actions) => {
          setTimeout(() => {
            handleSaveAsterisk(values);
            actions.setSubmitting(false);
          }, 400);
        }}
      >
        {({ values, errors, touched, isSubmitting }) => (
          <Form>
            <DialogContent dividers>
              {loading ? (
                <CircularProgress />
              ) : (
                <Grid container spacing={2}>
                  <Grid item xs={12} sm={6}>
                    <Field
                      as={TextField}
                      label={i18n.t("asterisk.form.name")}
                      name="name"
                      error={touched.name && Boolean(errors.name)}
                      helperText={touched.name && errors.name}
                      variant="outlined"
                      margin="dense"
                      fullWidth
                    />
                  </Grid>
                  <Grid item xs={12} sm={6}>
                    <Field
                      as={TextField}
                      label={i18n.t("asterisk.form.host")}
                      name="host"
                      error={touched.host && Boolean(errors.host)}
                      helperText={touched.host && errors.host}
                      variant="outlined"
                      margin="dense"
                      fullWidth
                      placeholder="192.168.1.100 ou asterisk.exemplo.com"
                    />
                  </Grid>
                  <Grid item xs={12} sm={4}>
                    <Field
                      as={TextField}
                      label={i18n.t("asterisk.form.ariPort")}
                      name="ariPort"
                      type="number"
                      error={touched.ariPort && Boolean(errors.ariPort)}
                      helperText={touched.ariPort && errors.ariPort}
                      variant="outlined"
                      margin="dense"
                      fullWidth
                    />
                  </Grid>
                  <Grid item xs={12} sm={4}>
                    <Field
                      as={TextField}
                      label={i18n.t("asterisk.form.sipPort")}
                      name="sipPort"
                      type="number"
                      error={touched.sipPort && Boolean(errors.sipPort)}
                      helperText={touched.sipPort && errors.sipPort}
                      variant="outlined"
                      margin="dense"
                      fullWidth
                    />
                  </Grid>
                  <Grid item xs={12} sm={4}>
                    <Field
                      as={TextField}
                      label={i18n.t("asterisk.form.wsPort")}
                      name="wsPort"
                      type="number"
                      error={touched.wsPort && Boolean(errors.wsPort)}
                      helperText={touched.wsPort && errors.wsPort}
                      variant="outlined"
                      margin="dense"
                      fullWidth
                    />
                  </Grid>
                  <Grid item xs={12} sm={6}>
                    <Field
                      as={TextField}
                      label={i18n.t("asterisk.form.ariUser")}
                      name="ariUser"
                      error={touched.ariUser && Boolean(errors.ariUser)}
                      helperText={touched.ariUser && errors.ariUser}
                      variant="outlined"
                      margin="dense"
                      fullWidth
                    />
                  </Grid>
                  <Grid item xs={12} sm={6}>
                    <Field
                      as={TextField}
                      label={i18n.t("asterisk.form.ariPassword")}
                      name="ariPassword"
                      type="password"
                      error={touched.ariPassword && Boolean(errors.ariPassword)}
                      helperText={touched.ariPassword && errors.ariPassword}
                      variant="outlined"
                      margin="dense"
                      fullWidth
                    />
                  </Grid>
                  <Grid item xs={12} sm={6}>
                    <Field
                      as={TextField}
                      label={i18n.t("asterisk.form.ariApplication")}
                      name="ariApplication"
                      variant="outlined"
                      margin="dense"
                      fullWidth
                      placeholder="bigchat"
                    />
                  </Grid>
                  <Grid item xs={12} sm={6}>
                    <Field
                      as={TextField}
                      label={i18n.t("asterisk.form.sipDomain")}
                      name="sipDomain"
                      variant="outlined"
                      margin="dense"
                      fullWidth
                      placeholder="sip.exemplo.com"
                    />
                  </Grid>
                  <Grid item xs={12} sm={6}>
                    <Field
                      as={TextField}
                      label={i18n.t("asterisk.form.outboundContext")}
                      name="outboundContext"
                      variant="outlined"
                      margin="dense"
                      fullWidth
                    />
                  </Grid>
                  <Grid item xs={12} sm={6}>
                    <Field
                      as={TextField}
                      label={i18n.t("asterisk.form.inboundContext")}
                      name="inboundContext"
                      variant="outlined"
                      margin="dense"
                      fullWidth
                    />
                  </Grid>
                  <Grid item xs={12} sm={6}>
                    <FormControlLabel
                      control={
                        <Field
                          as={Switch}
                          color="primary"
                          name="useSSL"
                          checked={values.useSSL}
                        />
                      }
                      label={i18n.t("asterisk.form.useSSL")}
                    />
                  </Grid>
                  <Grid item xs={12} sm={6}>
                    <FormControlLabel
                      control={
                        <Field
                          as={Switch}
                          color="primary"
                          name="isActive"
                          checked={values.isActive}
                        />
                      }
                      label={i18n.t("asterisk.form.isActive")}
                    />
                  </Grid>
                  <Grid item xs={12}>
                    <Field
                      as={TextField}
                      label={i18n.t("asterisk.form.notes")}
                      name="notes"
                      variant="outlined"
                      margin="dense"
                      fullWidth
                      multiline
                      rows={3}
                    />
                  </Grid>
                </Grid>
              )}
            </DialogContent>
            <DialogActions>
              <Button
                onClick={handleClose}
                color="secondary"
                disabled={isSubmitting}
                variant="outlined"
              >
                {i18n.t("asterisk.buttons.cancel")}
              </Button>
              <Button
                type="submit"
                color="primary"
                disabled={isSubmitting}
                variant="contained"
                className={classes.btnWrapper}
              >
                {asteriskId
                  ? i18n.t("asterisk.buttons.okEdit")
                  : i18n.t("asterisk.buttons.okAdd")}
                {isSubmitting && (
                  <CircularProgress
                    size={24}
                    className={classes.buttonProgress}
                  />
                )}
              </Button>
            </DialogActions>
          </Form>
        )}
      </Formik>
    </Dialog>
  );
};

export default AsteriskModal;
