import express from "express";
import isAuth from "../middleware/isAuth";
import * as FlowChatController from "../controllers/FlowChatController";

const routes = express.Router();

routes.get("/flow-chats", isAuth, FlowChatController.index);
routes.get("/flow-chats/:id", isAuth, FlowChatController.show);
routes.post("/flow-chats", isAuth, FlowChatController.store);
routes.put("/flow-chats/:id", isAuth, FlowChatController.update);
routes.delete("/flow-chats/:id", isAuth, FlowChatController.remove);
routes.post("/flow-chats/:id/duplicate", isAuth, FlowChatController.duplicate);

export default routes;
