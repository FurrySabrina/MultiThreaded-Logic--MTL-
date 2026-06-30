TIME_SCALE_MANAGER = {}

-- server

function TIME_SCALE_MANAGER.sv_onCreate(self)
    self.sv.timeScale = {
        enabled = sm.timeScale ~= nil,
        current = 1
    }
end

function TIME_SCALE_MANAGER.sv_onFixedUpdate(self)
    if self.sv.timeScale.enabled then
        if self.sv.timeScale.current ~= sm.timeScale.get() then
            self.sv.timeScale.current = sm.timeScale.get()
            TIME_SCALE_MANAGER.sv_sendTimeScale(self)
        end
    end
end

function TIME_SCALE_MANAGER.sv_onPlayerJoined(self, player)
    if not self.sv.timeScale then self.sv.timeScale = {} end
    if self.sv.timeScale.enabled then
        self.network:sendToClient(player, "client_onTimeScale", self.sv.timeScale.current)
    end
end

function TIME_SCALE_MANAGER.sv_sendTimeScale(self)
    self.network:sendToClients("client_onTimeScale", self.sv.timeScale.current)
end

-- client

function TIME_SCALE_MANAGER.cl_onTimeScale(self, timeScale)
    if sm.isHost then return end
    if not self.cl.timeScale.enabled then
        fWarn("TimeScale was set by the server, but the client does not have the timeScale DLL.")
        return
    end
    sm.timeScale.set(timeScale)
end
