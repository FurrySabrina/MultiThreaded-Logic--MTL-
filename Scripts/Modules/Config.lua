dofile("$CHALLENGE_DATA/Scripts/game/challenge_tools.lua")
dofile("$SURVIVAL_DATA/Scripts/game/survival_items.lua")
CONFIG = {}

CONFIG.isDebug = false
if sm.debugDraw.enabled == false then
    fWarn("debugDraw DLL is disabled. (-debugDraw flag not set.)")
end
CONFIG.canDebugDraw = sm.debugDraw.enabled==true

-- all the commands that are available to the player.
CONFIG.commands = {
    setTime = {
        params = {
            {
                "string",
                "isOpen",
                true
            }
        },
        help = "Sets the current time.",
        serverFunc = function(self, isOpen)
            fPrint("setTime", isOpen)
        end
    },
    stats = {
        params = {
            {
                "bool",
                "isOpen",
                true
            }
        },
        help = "Opens the stats gui.",
        clientFunc = function(self, isOpen)
            fPrint("stats", isOpen)
        end
    }
}

CONFIG.startingInventory = {
    [1] = tool_connecttool,
    [2] = tool_lift_creative
}

print(CONFIG.startingInventory)
