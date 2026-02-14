import { Router } from "express";
import isAuth from "../middleware/isAuth";

import * as CallController from "../controllers/CallController";

const callRoutes = Router();

callRoutes.get("/calls", isAuth, CallController.index);
callRoutes.get("/calls/stats", isAuth, CallController.stats);
callRoutes.get("/calls/:callId", isAuth, CallController.show);
callRoutes.post("/calls/originate", isAuth, CallController.originate);
callRoutes.post("/calls/:callId/hangup", isAuth, CallController.hangup);
callRoutes.post("/calls/:callId/transfer", isAuth, CallController.transfer);

export default callRoutes;
