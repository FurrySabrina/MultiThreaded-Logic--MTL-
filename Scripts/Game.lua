dofile("Modules/Config.lua")
dofile("Modules/Utils.lua")
dofile("Modules/TimeScaleManager.lua")
--- @class GameClass
Game = class(nil)

-- server

function Game:server_onCreate()
    if self.data and self.data.dev then
        CONFIG.isDebug = true
        print(sm.debugDraw.enabled)
        if sm.debugDraw.enabled == nil then
            fWarn("debugDraw DLL not found. Debug draw will not work.")
        elseif sm.debugDraw.enabled == false then
            fWarn("debugDraw DLL is disabled. (-debugDraw flag not set.)")
        end
        CONFIG.canDebugDraw = sm.debugDraw.enabled==true
    end
    fPrint("Game.server_onCreate")
    self.sv = {
        hostPlayer = nil
    }
    TIME_SCALE_MANAGER.sv_onCreate(self)
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
    fPrint("Game.server_onPlayerJoined")
    if isNewPlayer then
        if not sm.exists(self.sv.saved.worlds[1]) then
            sm.world.loadWorld(self.sv.saved.worlds[1])
        end
        self.sv.saved.worlds[1]:loadCell(0, 0, player, "sv_createPlayerCharacter")
    end
    if self.sv.hostPlayer == nil then
        self.sv.hostPlayer = player -- set the host player.
    end
    TIME_SCALE_MANAGER.sv_onPlayerJoined(self, player)
end

function Game:sv_createPlayerCharacter(world, x, y, player, params)
    local character = sm.character.createCharacter(player, world, sm.vec3.new(0, 0, 5), 0, 0)
    player:setCharacter(character)
end

function Game:server_onFixedUpdate()
    TIME_SCALE_MANAGER.sv_onFixedUpdate(self)
end

-- client

function Game:client_onTimeScale(timeScale)
    TIME_SCALE_MANAGER.cl_onTimeScale(self, timeScale)
end

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
    fPrint("Game:cl_onChatCommand", "/" .. command, params)
    if command == "stats" then
        fPrint("balls")
    end
end
