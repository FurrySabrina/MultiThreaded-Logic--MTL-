CONFIG = {}

CONFIG.isDebug = false

-- all the commands that are available to the player.
CONFIG.commands = {
    time = {
        params = {

        }
    },
    stats = {
        params = {
            {
                "bool",
                "isOpen",
                true
            }
        },
        help = "Opens the stats gui."
    }
}

CONFIG.commandFunctions = {
    time = function(timeString)
        print("time", timeString)
    end,
    stats = function(isOpen)
        print("stats", isOpen)
    end
}
