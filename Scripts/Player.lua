dofile("Modules/Config.lua")
dofile("Modules/Utils.lua")
Player = class(nil)

-- server

-- client

function Player:client_onCreate()
    fPrint("Player:client_onCreate")
    self.cl = {
        guiInterfaces = {
            stats = sm.gui.createGuiFromLayout("$CONTENT_DATA/Gui/Layouts/Stats.layout", false, {
                isHud = true
            })
        }
    }
end
