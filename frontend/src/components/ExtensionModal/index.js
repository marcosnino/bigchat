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
  MenuItem,
  FormControl,
  InputLabel,
  Select,
} from "@material-ui/core";

import api from "../../services/api";
import { i18n } from "../../translate/i18n";
import toastError from "../../errors/toastError";

const useStyles = makeStyles((theme) => ({
  root: {
    display: "flex",
    flexWrap: "wrap",
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
  formControl: {
    minWidth: "100%",
    marginTop: theme.spacing(1),
  },
}));

const ExtensionSchema = Yup.object().shape({
  exten: Yup.string()
    .min(2, "Ramal muito curto")
    .max(20, "Ramal muito longo")
    .required("Ramal é obrigatório"),
  password: Yup.string()
    .min(4, "Senha muito curta")
    .required("Senha é obrigatória"),
  asteriskId: Yup.number()
    .required("Conexão Asterisk é obrigatória"),
});

const ExtensionModal = ({ open, onClose, extensionId, asterisks = [] }) => {
  const classes = useStyles();
  const [extension, setExtension] = useState(null);
  const [loading, setLoading] = useState(false);
  const [users, setUsers] = useState([]);

  const initialValues = {
    exten: "",
    password: "",
    callerIdName: "",
    callerIdNumber: "",
    asteriskId: "",
    userId: "",
    webrtcEnabled: true,
    context: "from-internal",
    transport: "udp,ws,wss",
    codecs: "ulaw,alaw,g729,opus",
    maxContacts: 1,
    notes: "",
  };

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const { data } = await api.get("/users");
        setUsers(data.users || data || []);
      } catch (err) {
        toastError(err);
      }
    };
    fetchUsers();
  }, []);

  useEffect(() => {
    const fetchExtension = async () => {
      if (!extensionId) {
        setExtension(null);
        return;
      }

      setLoading(true);
      try {
        const { data } = await api.get(`/extensions/${extensionId}`);
        setExtension(data);
      } catch (err) {
        toastError(err);
      }
      setLoading(false);
    };

    fetchExtension();
  }, [extensionId, open]);

  const handleClose = () => {
    setExtension(null);
    onClose();
  };

  const handleSaveExtension = async (values) => {
    try {
      if (extensionId) {
        await api.put(`/extensions/${extensionId}`, values);
        toast.success(i18n.t("extension.toasts.updated"));
      } else {
        await api.post("/extensions", values);
        toast.success(i18n.t("extension.toasts.created"));
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
        {extensionId
          ? i18n.t("extension.modal.edit")
          : i18n.t("extension.modal.add")}
      </DialogTitle>
      <Formik
        initialValues={extension || initialValues}
        enableReinitialize
        validationSchema={ExtensionSchema}
        onSubmit={(values, actions) => {
          setTimeout(() => {
            handleSaveExtension(values);
            actions.setSubmitting(false);
          }, 400);
        }}
      >
        {({ values, errors, touched, isSubmitting, setFieldValue }) => (
          <Form>
            <DialogContent dividers>
              {loading ? (
                <CircularProgress />
              ) : (
                <Grid container spacing={2}>
                  <Grid item xs={12} sm={6}>
                    <Field
                      as={TextField}
                      label={i18n.t("extension.form.exten")}
                      name="exten"
                      error={touched.exten && Boolean(errors.exten)}
                      helperText={touched.exten && errors.exten}
                      variant="outlined"
                      margin="dense"
                      fullWidth
                      placeholder="1001"
                    />
                  </Grid>
                  <Grid item xs={12} sm={6}>
                    <Field
                      as={TextField}
                      label={i18n.t("extension.form.password")}
                      name="password"
                      type="password"
                      error={touched.password && Boolean(errors.password)}
                      helperText={touched.password && errors.password}
                      variant="outlined"
                      margin="dense"
                      fullWidth
                    />
                  </Grid>
                  <Grid item xs={12} sm={6}>
                    <Field
                      as={TextField}
                      label={i18n.t("extension.form.callerIdName")}
                      name="callerIdName"
                      variant="outlined"
                      margin="dense"
                      fullWidth
                      placeholder="Nome do Atendente"
                    />
                  </Grid>
                  <Grid item xs={12} sm={6}>
                    <Field
                      as={TextField}
                      label={i18n.t("extension.form.callerIdNumber")}
                      name="callerIdNumber"
                      variant="outlined"
                      margin="dense"
                      fullWidth
                      placeholder="1001"
                    />
                  </Grid>
                  <Grid item xs={12} sm={6}>
                    <FormControl
                      variant="outlined"
                      margin="dense"
                      fullWidth
                      error={touched.asteriskId && Boolean(errors.asteriskId)}
                    >
                      <InputLabel>{i18n.t("extension.form.asterisk")}</InputLabel>
                      <Field
                        as={Select}
                        name="asteriskId"
                        label={i18n.t("extension.form.asterisk")}
                      >
                        <MenuItem value="">
                          <em>{i18n.t("extension.form.selectAsterisk")}</em>
                        </MenuItem>
                        {asterisks.map((asterisk) => (
                          <MenuItem key={asterisk.id} value={asterisk.id}>
                            {asterisk.name} ({asterisk.host})
                          </MenuItem>
                        ))}
                      </Field>
                    </FormControl>
                  </Grid>
                  <Grid item xs={12} sm={6}>
                    <FormControl
                      variant="outlined"
                      margin="dense"
                      fullWidth
                    >
                      <InputLabel>{i18n.t("extension.form.user")}</InputLabel>
                      <Field
                        as={Select}
                        name="userId"
                        label={i18n.t("extension.form.user")}
                      >
                        <MenuItem value="">
                          <em>{i18n.t("extension.form.selectUser")}</em>
                        </MenuItem>
                        {users.map((user) => (
                          <MenuItem key={user.id} value={user.id}>
                            {user.name}
                          </MenuItem>
                        ))}
                      </Field>
                    </FormControl>
                  </Grid>
                  <Grid item xs={12} sm={6}>
                    <Field
                      as={TextField}
                      label={i18n.t("extension.form.context")}
                      name="context"
                      variant="outlined"
                      margin="dense"
                      fullWidth
                    />
                  </Grid>
                  <Grid item xs={12} sm={6}>
                    <Field
                      as={TextField}
                      label={i18n.t("extension.form.transport")}
                      name="transport"
                      variant="outlined"
                      margin="dense"
                      fullWidth
                      placeholder="udp,ws,wss"
                    />
                  </Grid>
                  <Grid item xs={12} sm={6}>
                    <Field
                      as={TextField}
                      label={i18n.t("extension.form.codecs")}
                      name="codecs"
                      variant="outlined"
                      margin="dense"
                      fullWidth
                      placeholder="ulaw,alaw,g729,opus"
                    />
                  </Grid>
                  <Grid item xs={12} sm={6}>
                    <Field
                      as={TextField}
                      label={i18n.t("extension.form.maxContacts")}
                      name="maxContacts"
                      type="number"
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
                          name="webrtcEnabled"
                          checked={values.webrtcEnabled}
                        />
                      }
                      label={i18n.t("extension.form.webrtcEnabled")}
                    />
                  </Grid>
                  <Grid item xs={12}>
                    <Field
                      as={TextField}
                      label={i18n.t("extension.form.notes")}
                      name="notes"
                      variant="outlined"
                      margin="dense"
                      fullWidth
                      multiline
                      rows={2}
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
                {i18n.t("extension.buttons.cancel")}
              </Button>
              <Button
                type="submit"
                color="primary"
                disabled={isSubmitting}
                variant="contained"
                className={classes.btnWrapper}
              >
                {extensionId
                  ? i18n.t("extension.buttons.okEdit")
                  : i18n.t("extension.buttons.okAdd")}
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

export default ExtensionModal;
