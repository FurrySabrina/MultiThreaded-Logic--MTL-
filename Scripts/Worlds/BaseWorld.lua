--- @class WorldClass
BaseWorld = class()

-- function for redirecting mod hooks to the actual command function.
function BaseWorld.sv_e_onChatCommand( self, commandData )
    return
end
