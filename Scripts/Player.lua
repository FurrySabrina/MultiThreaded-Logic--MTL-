Player = class( nil )

function Player.server_onCreate( self )
	print("Player.server_onCreate")
    print(self)
end

function Player:server_onFixedUpdate()
end
