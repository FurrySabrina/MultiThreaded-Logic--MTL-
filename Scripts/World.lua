World = class( nil )
World.terrainScript = "$CONTENT_DATA/Scripts/terrain.lua"
World.cellMinX = -16
World.cellMaxX = 16
World.cellMinY = -16
World.cellMaxY = 16
World.worldBorder = true

function World.server_onCreate( self )
    print("World.server_onCreate")
end
