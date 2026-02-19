import React, { useState, useEffect } from "react";
import {
  Paper,
  makeStyles,
  Grid,
  TextField,
  Button,
  Table,
  TableHead,
  TableBody,
  TableCell,
  TableRow,
  Card,
  CardContent,
  Typography,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  TablePagination,
  CircularProgress,
  Box,
  Chip
} from "@material-ui/core";
import {
  GetApp as GetAppIcon,
  Assessment as AssessmentIcon,
  Search as SearchIcon,
  Clear as ClearIcon
} from "@material-ui/icons";
import { i18n } from "../../translate/i18n";
import { toast } from "react-toastify";
import api from "../../services/api";
import MainContainer from "../../components/MainContainer";
import MainHeader from "../../components/MainHeader";
import MainHeaderButtonsWrapper from "../../components/MainHeaderButtonsWrapper";
import Title from "../../components/Title";
import { format, parseISO } from "date-fns";

const useStyles = makeStyles((theme) => ({
  mainPaper: {
    flex: 1,
    padding: theme.spacing(2),
    overflowY: "scroll",
    ...theme.scrollbarStyles,
  },
  filtersPaper: {
    padding: theme.spacing(2),
    marginBottom: theme.spacing(2),
  },
  filterButton: {
    marginTop: theme.spacing(3),
    marginRight: theme.spacing(1),
  },
  summaryCard: {
    marginBottom: theme.spacing(2),
    background: theme.palette.primary.main,
    color: "#fff",
  },
  summaryCardSecondary: {
    marginBottom: theme.spacing(2),
    background: theme.palette.secondary.main,
    color: "#fff",
  },
  summaryCardDefault: {
    marginBottom: theme.spacing(2),
  },
  table: {
    minWidth: 650,
  },
  tableRow: {
    "&:hover": {
      backgroundColor: theme.palette.action.hover,
    },
  },
  chip: {
    margin: theme.spacing(0.5),
  },
  loadingContainer: {
    display: "flex",
    justifyContent: "center",
    alignItems: "center",
    padding: theme.spacing(4),
  },
  noData: {
    textAlign: "center",
    padding: theme.spacing(4),
    color: theme.palette.text.secondary,
  },
}));

const ClosureReports = () => {
  const classes = useStyles();

  // State for filters
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");
  const [queueId, setQueueId] = useState("");
  const [userId, setUserId] = useState("");
  const [whatsappId, setWhatsappId] = useState("");
  const [closeReasonId, setCloseReasonId] = useState("");

  // State for data
  const [reportData, setReportData] = useState([]);
  const [summary, setSummary] = useState(null);
  const [loading, setLoading] = useState(false);
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(50);
  const [totalRecords, setTotalRecords] = useState(0);

  // State for filter options
  const [queues, setQueues] = useState([]);
  const [users, setUsers] = useState([]);
  const [whatsapps, setWhatsapps] = useState([]);
  const [closeReasons, setCloseReasons] = useState([]);

  // Load filter options
  useEffect(() => {
    const loadFilterOptions = async () => {
      try {
        const [queuesRes, usersRes, whatsappsRes, closeReasonsRes] = await Promise.all([
          api.get("/queue"),
          api.get("/users"),
          api.get("/whatsapp"),
          api.get("/close-reasons"),
        ]);

        setQueues(queuesRes.data);
        setUsers(usersRes.data.users || usersRes.data);
        setWhatsapps(whatsappsRes.data);
        setCloseReasons(closeReasonsRes.data);
      } catch (error) {
        console.error("Error loading filter options:", error);
        toast.error(i18n.t("closureReports.errors.loadFilters"));
      }
    };

    loadFilterOptions();
  }, []);

  // Load report data
  const loadReport = async (pageNum = 0) => {
    setLoading(true);
    try {
      const params = {
        page: pageNum + 1,
        limit: rowsPerPage,
      };

      if (startDate) params.startDate = new Date(startDate).toISOString();
      if (endDate) params.endDate = new Date(endDate).toISOString();
      if (queueId) params.queueId = queueId;
      if (userId) params.userId = userId;
      if (whatsappId) params.whatsappId = whatsappId;
      if (closeReasonId) params.closeReasonId = closeReasonId;

      const response = await api.get("/closed-tickets/report", { params });

      setReportData(response.data.data);
      setSummary(response.data.summary);
      setTotalRecords(response.data.pagination.total);
      setPage(pageNum);
    } catch (error) {
      console.error("Error loading report:", error);
      toast.error(i18n.t("closureReports.errors.loadReport"));
    } finally {
      setLoading(false);
    }
  };

  // Handle search
  const handleSearch = () => {
    loadReport(0);
  };

  // Handle clear filters
  const handleClearFilters = () => {
    setStartDate("");
    setEndDate("");
    setQueueId("");
    setUserId("");
    setWhatsappId("");
    setCloseReasonId("");
    setReportData([]);
    setSummary(null);
    setPage(0);
    setTotalRecords(0);
  };

  // Handle export CSV
  const handleExportCSV = async () => {
    try {
      const params = {};

      if (startDate) params.startDate = new Date(startDate).toISOString();
      if (endDate) params.endDate = new Date(endDate).toISOString();
      if (queueId) params.queueId = queueId;
      if (userId) params.userId = userId;
      if (whatsappId) params.whatsappId = whatsappId;
      if (closeReasonId) params.closeReasonId = closeReasonId;

      const response = await api.get("/closed-tickets/report/export", {
        params,
        responseType: "blob",
      });

      const url = window.URL.createObjectURL(new Blob([response.data]));
      const link = document.createElement("a");
      link.href = url;
      link.setAttribute("download", `relatorio-fechamentos-${new Date().toISOString().split("T")[0]}.csv`);
      document.body.appendChild(link);
      link.click();
      link.remove();

      toast.success(i18n.t("closureReports.messages.exportSuccess"));
    } catch (error) {
      console.error("Error exporting CSV:", error);
      toast.error(i18n.t("closureReports.errors.export"));
    }
  };

  // Handle page change
  const handleChangePage = (event, newPage) => {
    loadReport(newPage);
  };

  // Handle rows per page change
  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };

  // Format date
  const formatDate = (dateString) => {
    if (!dateString) return "-";
    try {
      return format(parseISO(dateString), "dd/MM/yyyy HH:mm:ss");
    } catch (error) {
      return dateString;
    }
  };

  return (
    <MainContainer>
      <MainHeader>
        <Title>{i18n.t("closureReports.title")}</Title>
        <MainHeaderButtonsWrapper>
          <Button
            variant="contained"
            color="primary"
            startIcon={<GetAppIcon />}
            onClick={handleExportCSV}
            disabled={!reportData || reportData.length === 0}
          >
            {i18n.t("closureReports.buttons.export")}
          </Button>
        </MainHeaderButtonsWrapper>
      </MainHeader>

      <Paper className={classes.mainPaper} variant="outlined">
        {/* Filters */}
        <Paper className={classes.filtersPaper} elevation={1}>
          <Grid container spacing={2}>
            <Grid item xs={12} sm={6} md={3}>
              <TextField
                fullWidth
                label={i18n.t("closureReports.filters.startDate")}
                type="date"
                value={startDate}
                onChange={(e) => setStartDate(e.target.value)}
                InputLabelProps={{
                  shrink: true,
                }}
              />
            </Grid>
            <Grid item xs={12} sm={6} md={3}>
              <TextField
                fullWidth
                label={i18n.t("closureReports.filters.endDate")}
                type="date"
                value={endDate}
                onChange={(e) => setEndDate(e.target.value)}
                InputLabelProps={{
                  shrink: true,
                }}
              />
            </Grid>
            <Grid item xs={12} sm={6} md={3}>
              <FormControl fullWidth>
                <InputLabel>{i18n.t("closureReports.filters.queue")}</InputLabel>
                <Select
                  value={queueId}
                  onChange={(e) => setQueueId(e.target.value)}
                >
                  <MenuItem value="">{i18n.t("closureReports.filters.all")}</MenuItem>
                  {queues.map((queue) => (
                    <MenuItem key={queue.id} value={queue.id}>
                      {queue.name}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={12} sm={6} md={3}>
              <FormControl fullWidth>
                <InputLabel>{i18n.t("closureReports.filters.user")}</InputLabel>
                <Select
                  value={userId}
                  onChange={(e) => setUserId(e.target.value)}
                >
                  <MenuItem value="">{i18n.t("closureReports.filters.all")}</MenuItem>
                  {users.map((user) => (
                    <MenuItem key={user.id} value={user.id}>
                      {user.name}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={12} sm={6} md={3}>
              <FormControl fullWidth>
                <InputLabel>{i18n.t("closureReports.filters.whatsapp")}</InputLabel>
                <Select
                  value={whatsappId}
                  onChange={(e) => setWhatsappId(e.target.value)}
                >
                  <MenuItem value="">{i18n.t("closureReports.filters.all")}</MenuItem>
                  {whatsapps.map((whatsapp) => (
                    <MenuItem key={whatsapp.id} value={whatsapp.id}>
                      {whatsapp.name}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={12} sm={6} md={3}>
              <FormControl fullWidth>
                <InputLabel>{i18n.t("closureReports.filters.closeReason")}</InputLabel>
                <Select
                  value={closeReasonId}
                  onChange={(e) => setCloseReasonId(e.target.value)}
                >
                  <MenuItem value="">{i18n.t("closureReports.filters.all")}</MenuItem>
                  {closeReasons.map((reason) => (
                    <MenuItem key={reason.id} value={reason.id}>
                      {reason.name}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={12} sm={6} md={3}>
              <Button
                fullWidth
                variant="contained"
                color="primary"
                startIcon={<SearchIcon />}
                onClick={handleSearch}
                className={classes.filterButton}
              >
                {i18n.t("closureReports.buttons.search")}
              </Button>
            </Grid>
            <Grid item xs={12} sm={6} md={3}>
              <Button
                fullWidth
                variant="outlined"
                startIcon={<ClearIcon />}
                onClick={handleClearFilters}
                className={classes.filterButton}
              >
                {i18n.t("closureReports.buttons.clear")}
              </Button>
            </Grid>
          </Grid>
        </Paper>

        {/* Summary Cards */}
        {summary && (
          <Grid container spacing={2} style={{ marginBottom: 16 }}>
            <Grid item xs={12} sm={6} md={3}>
              <Card className={classes.summaryCard}>
                <CardContent>
                  <Typography variant="h6">{i18n.t("closureReports.summary.totalTickets")}</Typography>
                  <Typography variant="h4">{summary.totalTickets}</Typography>
                </CardContent>
              </Card>
            </Grid>
            <Grid item xs={12} sm={6} md={3}>
              <Card className={classes.summaryCardSecondary}>
                <CardContent>
                  <Typography variant="h6">{i18n.t("closureReports.summary.avgDuration")}</Typography>
                  <Typography variant="h4">{summary.averageDurationFormatted}</Typography>
                </CardContent>
              </Card>
            </Grid>
            <Grid item xs={12} sm={6} md={3}>
              <Card className={classes.summaryCardDefault}>
                <CardContent>
                  <Typography variant="h6">{i18n.t("closureReports.summary.totalMessages")}</Typography>
                  <Typography variant="h4">{summary.totalMessages}</Typography>
                </CardContent>
              </Card>
            </Grid>
            <Grid item xs={12} sm={6} md={3}>
              <Card className={classes.summaryCardDefault}>
                <CardContent>
                  <Typography variant="h6">{i18n.t("closureReports.summary.avgRating")}</Typography>
                  <Typography variant="h4">
                    {summary.averageRating ? summary.averageRating.toFixed(1) : "-"}
                  </Typography>
                </CardContent>
              </Card>
            </Grid>
          </Grid>
        )}

        {/* Summary by Queue */}
        {summary && summary.byQueue && summary.byQueue.length > 0 && (
          <Paper style={{ padding: 16, marginBottom: 16 }}>
            <Typography variant="h6" gutterBottom>
              {i18n.t("closureReports.summary.byQueue")}
            </Typography>
            <Grid container spacing={1}>
              {summary.byQueue.map((item) => (
                <Grid item key={item.queueName}>
                  <Chip
                    label={`${item.queueName}: ${item.count} (${item.percentage}%)`}
                    className={classes.chip}
                    color="primary"
                  />
                </Grid>
              ))}
            </Grid>
          </Paper>
        )}

        {/* Summary by Close Reason */}
        {summary && summary.byCloseReason && summary.byCloseReason.length > 0 && (
          <Paper style={{ padding: 16, marginBottom: 16 }}>
            <Typography variant="h6" gutterBottom>
              {i18n.t("closureReports.summary.byCloseReason")}
            </Typography>
            <Grid container spacing={1}>
              {summary.byCloseReason.map((item) => (
                <Grid item key={item.closeReason}>
                  <Chip
                    label={`${item.closeReason}: ${item.count} (${item.percentage}%)`}
                    className={classes.chip}
                    color="secondary"
                  />
                </Grid>
              ))}
            </Grid>
          </Paper>
        )}

        {/* Loading */}
        {loading && (
          <Box className={classes.loadingContainer}>
            <CircularProgress />
          </Box>
        )}

        {/* No Data */}
        {!loading && reportData.length === 0 && (
          <Box className={classes.noData}>
            <AssessmentIcon style={{ fontSize: 48, marginBottom: 16 }} />
            <Typography variant="h6">{i18n.t("closureReports.noData")}</Typography>
          </Box>
        )}

        {/* Data Table */}
        {!loading && reportData.length > 0 && (
          <>
            <Table className={classes.table}>
              <TableHead>
                <TableRow>
                  <TableCell>{i18n.t("closureReports.table.contact")}</TableCell>
                  <TableCell>{i18n.t("closureReports.table.user")}</TableCell>
                  <TableCell>{i18n.t("closureReports.table.queue")}</TableCell>
                  <TableCell>{i18n.t("closureReports.table.closeReason")}</TableCell>
                  <TableCell>{i18n.t("closureReports.table.openedAt")}</TableCell>
                  <TableCell>{i18n.t("closureReports.table.closedAt")}</TableCell>
                  <TableCell>{i18n.t("closureReports.table.duration")}</TableCell>
                  <TableCell align="center">{i18n.t("closureReports.table.messages")}</TableCell>
                  <TableCell align="center">{i18n.t("closureReports.table.rating")}</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {reportData.map((row) => (
                  <TableRow key={row.id} className={classes.tableRow}>
                    <TableCell>
                      <div>{row.contactName}</div>
                      <Typography variant="caption" color="textSecondary">
                        {row.contactNumber}
                      </Typography>
                    </TableCell>
                    <TableCell>{row.userName || "-"}</TableCell>
                    <TableCell>{row.queueName || "-"}</TableCell>
                    <TableCell>{row.closeReason || "-"}</TableCell>
                    <TableCell>{formatDate(row.ticketOpenedAt)}</TableCell>
                    <TableCell>{formatDate(row.ticketClosedAt)}</TableCell>
                    <TableCell>{row.durationFormatted}</TableCell>
                    <TableCell align="center">{row.totalMessages || 0}</TableCell>
                    <TableCell align="center">
                      {row.rating ? (
                        <Chip
                          label={row.rating}
                          size="small"
                          color={row.rating >= 4 ? "primary" : row.rating >= 3 ? "default" : "secondary"}
                        />
                      ) : (
                        "-"
                      )}
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>

            <TablePagination
              rowsPerPageOptions={[10, 25, 50, 100]}
              component="div"
              count={totalRecords}
              rowsPerPage={rowsPerPage}
              page={page}
              onChangePage={handleChangePage}
              onChangeRowsPerPage={handleChangeRowsPerPage}
              labelRowsPerPage={i18n.t("closureReports.table.rowsPerPage")}
            />
          </>
        )}
      </Paper>
    </MainContainer>
  );
};

export default ClosureReports;
