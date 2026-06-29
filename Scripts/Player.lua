Player = class( nil )

function Player.server_onCreate( self )
	print("Player.server_onCreate")
end

function Player:server_onFixedUpdate()
    print(self.player:getCharacter().worldPosition)
end
