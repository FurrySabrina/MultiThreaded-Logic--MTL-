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
    fPrint("COMMAND_MANAGER:cl_onChatCommand", "/" .. command, params)
    if command == "stats" then
        fPrint("balls")
    end
end
