Game = class( nil )

function Game.server_onCreate( self )
	print("Game.server_onCreate")
    self.sv = {}
	self.sv.saved = self.storage:load()
    if self.sv.saved == nil then
		self.sv.saved = {}
        self.sv.saved.world_index = 1
		self.sv.saved.worlds = {
            [1] = sm.world.createWorld( "$CONTENT_DATA/Scripts/World.lua", "World" )
        }
		self.storage:save( self.sv.saved )
	end
end

function Game.server_onPlayerJoined( self, player, isNewPlayer )
    print("Game.server_onPlayerJoined")
    if isNewPlayer then
        if not sm.exists( self.sv.saved.worlds[1] ) then
            sm.world.loadWorld( self.sv.saved.worlds[1] )
        end
        self.sv.saved.worlds[1]:loadCell( 0, 0, player, "sv_createPlayerCharacter" )
    end
end

function Game.sv_createPlayerCharacter( self, world, x, y, player, params )
    local character = sm.character.createCharacter( player, world, sm.vec3.new( 0, 0, 5 ), 0, 0 )
	player:setCharacter( character )
end
