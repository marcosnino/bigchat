import React, { useContext, useState } from "react";
import { useHistory } from "react-router-dom";

import { makeStyles } from "@material-ui/core/styles";
import { IconButton, Button } from "@material-ui/core";
import { MoreVert, Replay } from "@material-ui/icons";

import { i18n } from "../../translate/i18n";
import api from "../../services/api";
import TicketOptionsMenu from "../TicketOptionsMenu";
import ButtonWithSpinner from "../ButtonWithSpinner";
import toastError from "../../errors/toastError";
import { AuthContext } from "../../context/Auth/AuthContext";
import { TicketsContext } from "../../context/Tickets/TicketsContext";
import UndoRoundedIcon from '@material-ui/icons/UndoRounded';
import DoneAllIcon from '@material-ui/icons/DoneAll';
import CloseIcon from '@material-ui/icons/Close';
import ThumbUpIcon from '@material-ui/icons/ThumbUp';
import Tooltip from '@material-ui/core/Tooltip';
import { green, red } from '@material-ui/core/colors';
import CloseReasonDialog from "../CloseReasonDialog";


const useStyles = makeStyles(theme => ({
	actionButtons: {
		marginRight: 6,
		flex: "none",
		alignSelf: "center",
		marginLeft: "auto",
		display: "flex",
		alignItems: "center",
		gap: 4,
		"& > *": {
			margin: theme.spacing(0.5),
		},
	},
	acceptBtn: {
		backgroundColor: green[600],
		color: "#fff",
		fontWeight: 600,
		"&:hover": {
			backgroundColor: green[800],
		},
		textTransform: "none",
		borderRadius: 20,
		padding: "4px 16px",
	},
	closeBtn: {
		backgroundColor: red[500],
		color: "#fff",
		fontWeight: 600,
		"&:hover": {
			backgroundColor: red[700],
		},
		textTransform: "none",
		borderRadius: 20,
		padding: "4px 16px",
	},
	resolveBtn: {
		backgroundColor: green[500],
		color: "#fff",
		fontWeight: 600,
		"&:hover": {
			backgroundColor: green[700],
		},
		textTransform: "none",
		borderRadius: 20,
		padding: "4px 16px",
	},
}));

const TicketActionButtonsCustom = ({ ticket }) => {
	const classes = useStyles();
	const history = useHistory();
	const [anchorEl, setAnchorEl] = useState(null);
	const [loading, setLoading] = useState(false);
	const [closeReasonDialogOpen, setCloseReasonDialogOpen] = useState(false);
	const ticketOptionsMenuOpen = Boolean(anchorEl);
	const { user } = useContext(AuthContext);
	const { setCurrentTicket } = useContext(TicketsContext);

	const handleOpenTicketOptionsMenu = e => {
		setAnchorEl(e.currentTarget);
	};

	const handleCloseTicketOptionsMenu = e => {
		setAnchorEl(null);
	};

	const handleUpdateTicketStatus = async (e, status, userId, closeReasonId) => {
		setLoading(true);
		try {
			const payload = {
				status: status,
				userId: userId || null,
				useIntegration: status === "closed" ? false : ticket.useIntegration,
				promptId: status === "closed" ? false : ticket.promptId,
				integrationId: status === "closed" ? false : ticket.integrationId,
			};
			if (status === "closed") {
				payload.closeReasonId = closeReasonId;
			}
			await api.put(`/tickets/${ticket.id}`, payload);

			setLoading(false);
			if (status === "open") {
				setCurrentTicket({ ...ticket, code: "#open" });
			} else {
				setCurrentTicket({ id: null, code: null })
				history.push("/tickets");
			}
		} catch (err) {
			setLoading(false);
			toastError(err);
		}
	};

	const handleOpenCloseReasonDialog = () => {
		setCloseReasonDialogOpen(true);
	};

	const handleCloseReasonDialog = () => {
		setCloseReasonDialogOpen(false);
	};

	const handleConfirmCloseReason = (closeReasonId) => {
		setCloseReasonDialogOpen(false);
		handleUpdateTicketStatus(null, "closed", user?.id, closeReasonId);
	};

	return (
		<div className={classes.actionButtons}>
			{/* CLOSED: Reopen button */}
			{ticket.status === "closed" && (
				<ButtonWithSpinner
					loading={loading}
					startIcon={<Replay />}
					size="small"
					onClick={e => handleUpdateTicketStatus(e, "open", user?.id)}
				>
					{i18n.t("messagesList.header.buttons.reopen")}
				</ButtonWithSpinner>
			)}

			{/* OPEN: Return + Resolve/Close + Menu */}
			{ticket.status === "open" && (
				<>
					<Tooltip title={i18n.t("messagesList.header.buttons.return")}>
						<IconButton
							size="small"
							onClick={e => handleUpdateTicketStatus(e, "pending", null)}
						>
							<UndoRoundedIcon />
						</IconButton>
					</Tooltip>

					<Tooltip title={i18n.t("ticketActionButtons.endChat")}>
						<Button
							variant="contained"
							size="small"
							className={classes.resolveBtn}
							onClick={handleOpenCloseReasonDialog}
							startIcon={<DoneAllIcon style={{ fontSize: 18 }} />}
							disabled={loading}
						>
							{i18n.t("ticketActionButtons.end")}
						</Button>
					</Tooltip>

					<Tooltip title={i18n.t("ticketActionButtons.closeChat")}>
						<IconButton
							size="small"
							onClick={handleOpenCloseReasonDialog}
							style={{ color: red[500] }}
						>
							<CloseIcon />
						</IconButton>
					</Tooltip>

					<IconButton size="small" onClick={handleOpenTicketOptionsMenu}>
						<MoreVert />
					</IconButton>
					<TicketOptionsMenu
						ticket={ticket}
						anchorEl={anchorEl}
						menuOpen={ticketOptionsMenuOpen}
						handleClose={handleCloseTicketOptionsMenu}
					/>
				</>
			)}

			{/* PENDING: Accept button */}
			{ticket.status === "pending" && (
				<Button
					variant="contained"
					size="small"
					className={classes.acceptBtn}
					onClick={e => handleUpdateTicketStatus(e, "open", user?.id)}
					startIcon={<ThumbUpIcon style={{ fontSize: 18 }} />}
					disabled={loading}
				>
					{i18n.t("messagesList.header.buttons.accept")}
				</Button>
			)}

			{/* Confirmation Dialog for Close/End */}
			<CloseReasonDialog
				open={closeReasonDialogOpen}
				onClose={handleCloseReasonDialog}
				onConfirm={handleConfirmCloseReason}
				queueId={ticket?.queue?.id || ticket?.queueId}
			/>
		</div>
	);
};

export default TicketActionButtonsCustom;
