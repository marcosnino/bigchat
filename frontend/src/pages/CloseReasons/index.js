import React, {
  useState,
  useEffect,
  useReducer,
  useCallback,
  useContext,
} from "react";
import { toast } from "react-toastify";

import { makeStyles } from "@material-ui/core/styles";
import Paper from "@material-ui/core/Paper";
import Button from "@material-ui/core/Button";
import Table from "@material-ui/core/Table";
import TableBody from "@material-ui/core/TableBody";
import TableCell from "@material-ui/core/TableCell";
import TableHead from "@material-ui/core/TableHead";
import TableRow from "@material-ui/core/TableRow";
import IconButton from "@material-ui/core/IconButton";
import SearchIcon from "@material-ui/icons/Search";
import TextField from "@material-ui/core/TextField";
import InputAdornment from "@material-ui/core/InputAdornment";
import Chip from "@material-ui/core/Chip";

import DeleteOutlineIcon from "@material-ui/icons/DeleteOutline";
import EditIcon from "@material-ui/icons/Edit";
import MainContainer from "../../components/MainContainer";
import MainHeader from "../../components/MainHeader";
import MainHeaderButtonsWrapper from "../../components/MainHeaderButtonsWrapper";
import Title from "../../components/Title";

import api from "../../services/api";
import { i18n } from "../../translate/i18n";
import TableRowSkeleton from "../../components/TableRowSkeleton";
import CloseReasonModal from "../../components/CloseReasonModal";
import ConfirmationModal from "../../components/ConfirmationModal";
import toastError from "../../errors/toastError";
import { SocketContext } from "../../context/Socket/SocketContext";
import { AuthContext } from "../../context/Auth/AuthContext";

const reducer = (state, action) => {
  if (action.type === "LOAD_REASONS") {
    const reasons = action.payload;
    const newReasons = [];

    reasons.forEach((reason) => {
      const reasonIndex = state.findIndex((s) => s.id === reason.id);
      if (reasonIndex !== -1) {
        state[reasonIndex] = reason;
      } else {
        newReasons.push(reason);
      }
    });

    return [...state, ...newReasons];
  }

  if (action.type === "UPDATE_REASON") {
    const reason = action.payload;
    const reasonIndex = state.findIndex((s) => s.id === reason.id);

    if (reasonIndex !== -1) {
      state[reasonIndex] = reason;
      return [...state];
    }
    return [reason, ...state];
  }

  if (action.type === "DELETE_REASON") {
    const reasonId = action.payload;

    const reasonIndex = state.findIndex((s) => s.id === reasonId);
    if (reasonIndex !== -1) {
      state.splice(reasonIndex, 1);
    }
    return [...state];
  }

  if (action.type === "RESET") {
    return [];
  }
};

const useStyles = makeStyles((theme) => ({
  mainPaper: {
    flex: 1,
    padding: theme.spacing(1),
    overflowY: "scroll",
    ...theme.scrollbarStyles,
  },
}));

const CloseReasons = () => {
  const classes = useStyles();

  const { user } = useContext(AuthContext);

  const [loading, setLoading] = useState(false);
  const [pageNumber, setPageNumber] = useState(1);
  const [hasMore, setHasMore] = useState(false);
  const [selectedReason, setSelectedReason] = useState(null);
  const [deletingReason, setDeletingReason] = useState(null);
  const [confirmModalOpen, setConfirmModalOpen] = useState(false);
  const [searchParam, setSearchParam] = useState("");
  const [reasons, dispatch] = useReducer(reducer, []);
  const [modalOpen, setModalOpen] = useState(false);

  const fetchReasons = useCallback(async () => {
    try {
      const { data } = await api.get("/close-reasons", {
        params: { searchParam, pageNumber },
      });
      dispatch({ type: "LOAD_REASONS", payload: data.reasons });
      setHasMore(data.hasMore);
      setLoading(false);
    } catch (err) {
      toastError(err);
    }
  }, [searchParam, pageNumber]);

  const socketManager = useContext(SocketContext);

  useEffect(() => {
    dispatch({ type: "RESET" });
    setPageNumber(1);
  }, [searchParam]);

  useEffect(() => {
    setLoading(true);
    const delayDebounceFn = setTimeout(() => {
      fetchReasons();
    }, 500);
    return () => clearTimeout(delayDebounceFn);
  }, [searchParam, pageNumber, fetchReasons]);

  useEffect(() => {
    const socket = socketManager.getSocket(user.companyId);

    socket.on("closeReason", (data) => {
      if (data.action === "update" || data.action === "create") {
        dispatch({ type: "UPDATE_REASON", payload: data.reason });
      }

      if (data.action === "delete") {
        dispatch({ type: "DELETE_REASON", payload: +data.closeReasonId });
      }
    });

    return () => {
      socket.disconnect();
    };
  }, [socketManager, user]);

  const handleOpenModal = () => {
    setSelectedReason(null);
    setModalOpen(true);
  };

  const handleCloseModal = () => {
    setSelectedReason(null);
    setModalOpen(false);
  };

  const handleSearch = (event) => {
    setSearchParam(event.target.value.toLowerCase());
  };

  const handleEditReason = (reason) => {
    setSelectedReason(reason);
    setModalOpen(true);
  };

  const handleDeleteReason = async (reasonId) => {
    try {
      await api.delete(`/close-reasons/${reasonId}`);
      toast.success(i18n.t("closeReasons.toasts.deleted"));
    } catch (err) {
      toastError(err);
    }
    setDeletingReason(null);
    setSearchParam("");
    setPageNumber(1);

    dispatch({ type: "RESET" });
    setPageNumber(1);
    await fetchReasons();
  };

  const loadMore = () => {
    setPageNumber((prevState) => prevState + 1);
  };

  const handleScroll = (e) => {
    if (!hasMore || loading) return;
    const { scrollTop, scrollHeight, clientHeight } = e.currentTarget;
    if (scrollHeight - (scrollTop + 100) < clientHeight) {
      loadMore();
    }
  };

  return (
    <MainContainer>
      <ConfirmationModal
        title={
          deletingReason &&
          `${i18n.t("closeReasons.confirmationModal.deleteTitle")}`
        }
        open={confirmModalOpen}
        onClose={setConfirmModalOpen}
        onConfirm={() => handleDeleteReason(deletingReason.id)}
      >
        {i18n.t("closeReasons.confirmationModal.deleteMessage")}
      </ConfirmationModal>
      <CloseReasonModal
        open={modalOpen}
        onClose={handleCloseModal}
        reload={fetchReasons}
        aria-labelledby="form-dialog-title"
        closeReasonId={selectedReason && selectedReason.id}
      />
      <MainHeader>
        <Title>{i18n.t("closeReasons.title")}</Title>
        <MainHeaderButtonsWrapper>
          <TextField
            placeholder={i18n.t("closeReasons.searchPlaceholder")}
            type="search"
            value={searchParam}
            onChange={handleSearch}
            InputProps={{
              startAdornment: (
                <InputAdornment position="start">
                  <SearchIcon style={{ color: "gray" }} />
                </InputAdornment>
              ),
            }}
          />
          <Button variant="contained" color="primary" onClick={handleOpenModal}>
            {i18n.t("closeReasons.buttons.add")}
          </Button>
        </MainHeaderButtonsWrapper>
      </MainHeader>
      <Paper
        className={classes.mainPaper}
        variant="outlined"
        onScroll={handleScroll}
      >
        <Table size="small">
          <TableHead>
            <TableRow>
              <TableCell align="center">
                {i18n.t("closeReasons.table.name")}
              </TableCell>
              <TableCell align="center">
                {i18n.t("closeReasons.table.description")}
              </TableCell>
              <TableCell align="center">
                {i18n.t("closeReasons.table.status")}
              </TableCell>
              <TableCell align="center">
                {i18n.t("closeReasons.table.actions")}
              </TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {reasons.map((reason) => (
              <TableRow key={reason.id}>
                <TableCell align="center">{reason.name}</TableCell>
                <TableCell align="center">
                  {reason.description || "-"}
                </TableCell>
                <TableCell align="center">
                  <Chip
                    variant="outlined"
                    size="small"
                    label={
                      reason.isActive
                        ? i18n.t("closeReasons.status.active")
                        : i18n.t("closeReasons.status.inactive")
                    }
                    color={reason.isActive ? "primary" : "default"}
                  />
                </TableCell>
                <TableCell align="center">
                  <IconButton size="small" onClick={() => handleEditReason(reason)}>
                    <EditIcon />
                  </IconButton>
                  <IconButton
                    size="small"
                    onClick={() => {
                      setConfirmModalOpen(true);
                      setDeletingReason(reason);
                    }}
                  >
                    <DeleteOutlineIcon />
                  </IconButton>
                </TableCell>
              </TableRow>
            ))}
            {loading && <TableRowSkeleton columns={4} />}
          </TableBody>
        </Table>
      </Paper>
    </MainContainer>
  );
};

export default CloseReasons;
