import { createContext } from "react";
import openSocket from "socket.io-client";
import jwt from "jsonwebtoken";

class ManagedSocket {
  constructor(socketManager) {
    this.socketManager = socketManager;
    this.rawSocket = socketManager.currentSocket;
    this.callbacks = [];
    this.joins = [];

    this.rawSocket.on("connect", () => {
      if (!this.rawSocket.recovered) {
        const refreshJoinsOnReady = () => {
          for (const j of this.joins) {
            console.debug("refreshing join", j);
            this.rawSocket.emit(`join${j.event}`, ...j.params);
          }
          this.rawSocket.off("ready", refreshJoinsOnReady);
        };
        for (const j of this.callbacks) {
          this.rawSocket.off(j.event, j.callback);
          this.rawSocket.on(j.event, j.callback);
        }
        
        this.rawSocket.on("ready", refreshJoinsOnReady);
      }
    });
  }
  
  on(event, callback) {
    if (event === "ready" || event === "connect") {
      return this.socketManager.onReady(callback);
    }
    this.callbacks.push({event, callback});
    return this.rawSocket.on(event, callback);
  }
  
  off(event, callback) {
    const i = this.callbacks.findIndex((c) => c.event === event && c.callback === callback);
    this.callbacks.splice(i, 1);
    return this.rawSocket.off(event, callback);
  }
  
  emit(event, ...params) {
    if (event.startsWith("join")) {
      this.joins.push({ event: event.substring(4), params });
      console.log("Joining", { event: event.substring(4), params});
    }
    return this.rawSocket.emit(event, ...params);
  }
  
  disconnect() {
    for (const j of this.joins) {
      this.rawSocket.emit(`leave${j.event}`, ...j.params);
    }
    this.joins = [];
    for (const c of this.callbacks) {
      this.rawSocket.off(c.event, c.callback);
    }
    this.callbacks = [];
  }
}

class DummySocket {
  on(..._) {}
  off(..._) {}
  emit(..._) {}
  disconnect() {}
}

const SocketManager = {
  currentCompanyId: -1,
  currentUserId: -1,
  currentSocket: null,
  socketReady: false,

  getSocket: function(companyId) {
    let userId = null;
    if (localStorage.getItem("userId")) {
      userId = localStorage.getItem("userId");
    }

    if (!companyId && !this.currentSocket) {
      return new DummySocket();
    }

    if (companyId && typeof companyId !== "string") {
      companyId = `${companyId}`;
    }

    if (companyId !== this.currentCompanyId || userId !== this.currentUserId) {
      if (this.currentSocket) {
        console.warn("closing old socket - company or user changed");
        this.currentSocket.removeAllListeners();
        this.currentSocket.disconnect();
        this.currentSocket = null;
      }

      let token = JSON.parse(localStorage.getItem("token"));
      if (!token) {
        return new DummySocket();
      }

      const decoded = jwt.decode(token);
      const exp = decoded?.exp;

      if (exp && Date.now() >= exp * 1000) {
        console.warn("Token expirado - iniciando refresh silencioso");
        
        // Iniciar refresh em background (não bloquear com await)
        if (!this._refreshingToken) {
          this._refreshingToken = true;
          fetch(`${process.env.REACT_APP_BACKEND_URL}/auth/refresh_token`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ token })
          })
          .then(res => res.ok ? res.json() : Promise.reject("refresh failed"))
          .then(data => {
            if (data.token) {
              localStorage.setItem("token", JSON.stringify(data.token));
              console.info("Token renovado com sucesso via refresh");
              // Próxima chamada a getSocket() usará o token novo
              this.currentCompanyId = -1;
            }
            this._refreshingToken = false;
          })
          .catch(() => {
            console.warn("Falha no refresh do token - redirecionando para login");
            this._refreshingToken = false;
            localStorage.removeItem("token");
            localStorage.removeItem("companyId");
            localStorage.removeItem("userId");
            window.location.href = "/login";
          });
        }
        
        // Retornar DummySocket enquanto refresh está em andamento
        // O polling do QrcodeModal garante atualizações mesmo sem socket
        return new DummySocket();
      }

      this.currentCompanyId = companyId;
      this.currentUserId = userId;
      
      if (!token) {
        return new DummySocket();
      }
      
      this.currentSocket = openSocket(process.env.REACT_APP_BACKEND_URL, {
        transports: ["websocket"],
        pingTimeout: 18000,
        pingInterval: 18000,
        query: { token },
      });
      
      this.currentSocket.on("disconnect", (reason) => {
        console.warn(`socket disconnected because: ${reason}`);
        if (reason.startsWith("io ") && reason !== "io client disconnect") {
          console.warn("Tentando reconectar socket...");

          // Verificar token antes de reconectar
          let currentToken = JSON.parse(localStorage.getItem("token"));
          if (!currentToken) {
            console.warn("Sem token - redirecionando para login");
            localStorage.clear();
            window.location.href = "/login";
            return;
          }

          const decoded = jwt.decode(currentToken);
          if (decoded?.exp && Date.now() >= decoded.exp * 1000) {
            // Tentar refresh silencioso antes de redirecionar
            fetch(`${process.env.REACT_APP_BACKEND_URL}/auth/refresh_token`, {
              method: "POST",
              headers: { "Content-Type": "application/json" },
              body: JSON.stringify({ token: currentToken })
            }).then(res => {
              if (res.ok) return res.json();
              throw new Error("refresh failed");
            }).then(data => {
              if (data.token) {
                localStorage.setItem("token", JSON.stringify(data.token));
                console.info("Token renovado na reconexão");
                // Forçar nova conexão de socket com o token atualizado
                if (this.currentSocket) {
                  this.currentSocket.io.opts.query = { token: data.token };
                  this.currentSocket.connect();
                }
              }
            }).catch(() => {
              console.warn("Token expirado e refresh falhou - login necessário");
              localStorage.clear();
              window.location.href = "/login";
            });
            return;
          }

          // Token válido - reconectar após delay
          setTimeout(() => {
            if (this.currentSocket && !this.currentSocket.connected) {
              this.currentSocket.connect();
            }
          }, 3000);
        }
      });
      
      this.currentSocket.on("connect", (...params) => {
        console.warn("socket connected", params);
      })
      
      this.currentSocket.onAny((event, ...args) => {
        console.debug("Event: ", { socket: this.currentSocket, event, args });
      });
      
      this.onReady(() => {
        this.socketReady = true;
      });

    }
    
    return new ManagedSocket(this);
  },
  
  onReady: function( callbackReady ) {
    if (this.socketReady) {
      callbackReady();
      return
    }
    
    this.currentSocket.once("ready", () => {
      callbackReady();
    });
  },

};

const SocketContext = createContext()

export { SocketContext, SocketManager };
