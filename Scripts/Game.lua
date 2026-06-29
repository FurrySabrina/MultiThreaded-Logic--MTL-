dofile("Config.lua")
Game = class(nil)

-- server

function Game:server_onCreate()
    if self.data and self.data.dev then
        CONFIG.isDebug = true
    end
    print("Game.server_onCreate")
    self.sv = {}
    self.sv.saved = self.storage:load()
    if self.sv.saved == nil then
        self.sv.saved = {}
        self.sv.saved.world_index = 1
        self.sv.saved.worlds = {
            [1] = sm.world.createWorld("$CONTENT_DATA/Scripts/World.lua", "World")
        }
        self.storage:save(self.sv.saved)
    end
    -- commands
    for command, data in pairs(CONFIG.commands) do
        sm.game.bindChatCommand("/" .. command, data.params, "cl_onChatCommand", data.help)
    end
end

function Game:server_onPlayerJoined(player, isNewPlayer)
    print("Game.server_onPlayerJoined")
    if isNewPlayer then
        if not sm.exists(self.sv.saved.worlds[1]) then
            sm.world.loadWorld(self.sv.saved.worlds[1])
        end
        self.sv.saved.worlds[1]:loadCell(0, 0, player, "sv_createPlayerCharacter")
    end
end

function Game:sv_createPlayerCharacter(world, x, y, player, params)
    local character = sm.character.createCharacter(player, world, sm.vec3.new(0, 0, 5), 0, 0)
    player:setCharacter(character)
end

-- client

-- function for redirecting mod hooks to the actual command function.
function Game:cl_onChatCommand(commandData)
    self:client_onChatCommand(commandData)
end

function Game:client_onChatCommand(commandData)
    local command = commandData[1]:sub(2) -- removes the / from the command.
    local params = { n = #commandData-1 }
    for i = 2, #commandData do
        params[i - 1] = commandData[i]
    end
    print("Game:cl_onChatCommand", "/" .. command, params)
    if command == "stats" then
        print("balls")
    end
end
