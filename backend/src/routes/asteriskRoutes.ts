import { Router } from "express";
import isAuth from "../middleware/isAuth";

import * as AsteriskController from "../controllers/AsteriskController";

const asteriskRoutes = Router();

asteriskRoutes.get("/asterisks", isAuth, AsteriskController.index);
asteriskRoutes.post("/asterisks", isAuth, AsteriskController.store);
asteriskRoutes.get("/asterisks/:asteriskId", isAuth, AsteriskController.show);
asteriskRoutes.put("/asterisks/:asteriskId", isAuth, AsteriskController.update);
asteriskRoutes.delete("/asterisks/:asteriskId", isAuth, AsteriskController.remove);
asteriskRoutes.post("/asterisks/:asteriskId/test", isAuth, AsteriskController.testConnection);
asteriskRoutes.post("/asterisks/:asteriskId/connect", isAuth, AsteriskController.connect);
asteriskRoutes.post("/asterisks/:asteriskId/disconnect", isAuth, AsteriskController.disconnect);
asteriskRoutes.get("/asterisks/:asteriskId/status", isAuth, AsteriskController.getStatus);

export default asteriskRoutes;
