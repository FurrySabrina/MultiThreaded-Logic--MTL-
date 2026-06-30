COMMAND_MANAGER = {}

-- server

function COMMAND_MANAGER.sv_onCreate(self)
    for command, data in pairs(CONFIG.commands) do
        sm.game.bindChatCommand("/" .. command, data.params, "cl_onChatCommand", data.help)
    end
end

-- client

function COMMAND_MANAGER.cl_onChatCommand(self, commandData)
    local command = commandData[1]:sub(2) -- removes the / from the command.
    local params = { n = #commandData-1 }
    for i = 2, #commandData do
        params[i - 1] = commandData[i]
    end
    fPrint("COMMAND_MANAGER.cl_onChatCommand", "/" .. command, params)
    if CONFIG.commands[command].clientFunc then
        CONFIG.commands[command].clientFunc(self, params)
    end
    self.network:sendToServer("sv_onChatCommand", commandData)
end

function COMMAND_MANAGER.sv_onChatCommand(self, commandData, player)
    local command = commandData[1]:sub(2) -- removes the / from the command.
    local params = { n = #commandData-1 }
    for i = 2, #commandData do
        params[i - 1] = commandData[i]
    end
    fPrint("COMMAND_MANAGER.sv_onChatCommand", "/" .. command, params)
    if CONFIG.commands[command].serverFunc then
        CONFIG.commands[command].serverFunc(self, params)
    end
    if sm.exists(player.character) then
        commandData.player = player
        sm.event.sendToWorld(player.character.world, "sv_e_onChatCommand", commandData)
    end
end
