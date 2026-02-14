import { Router } from "express";
import isAuth from "../middleware/isAuth";
import * as ExtensionController from "../controllers/ExtensionController";

const extensionRoutes = Router();

extensionRoutes.get("/extensions", isAuth, ExtensionController.index);
extensionRoutes.post("/extensions", isAuth, ExtensionController.store);
extensionRoutes.get("/extensions/:extensionId", isAuth, ExtensionController.show);
extensionRoutes.put("/extensions/:extensionId", isAuth, ExtensionController.update);
extensionRoutes.delete("/extensions/:extensionId", isAuth, ExtensionController.remove);

export default extensionRoutes;
