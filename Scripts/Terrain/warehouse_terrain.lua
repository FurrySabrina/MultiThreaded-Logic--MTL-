---@diagnostic disable: undefined-global
dofile("$SURVIVAL_DATA/Scripts/terrain/terrain_util2.lua")

local function directionToUuid(direction)
    return sm.uuid.generateNamed(sm.uuid.new("82b89df0-55ce-4aad-bb18-5c1395689332"), direction)
end

function Init()
    print("[Terrain] Init terrain")

    -- Init fence
    g_fenceTileList = {}

    --	Corners
    g_fenceTileList[tostring(directionToUuid("NE"))] =
    "$GAME_DATA/Terrain/Tiles/CreativeTiles/Auto/Flatterrain_FenceNE.tile"
    g_fenceTileList[tostring(directionToUuid("NW"))] =
    "$GAME_DATA/Terrain/Tiles/CreativeTiles/Auto/Flatterrain_FenceNW.tile"
    g_fenceTileList[tostring(directionToUuid("SE"))] =
    "$GAME_DATA/Terrain/Tiles/CreativeTiles/Auto/Flatterrain_FenceSE.tile"
    g_fenceTileList[tostring(directionToUuid("SW"))] =
    "$GAME_DATA/Terrain/Tiles/CreativeTiles/Auto/Flatterrain_FenceSW.tile"

    --	North
    g_fenceTileList[tostring(directionToUuid("N"))] =
    "$GAME_DATA/Terrain/Tiles/CreativeTiles/Auto/Flatterrain_FenceN_01.tile"

    --	South
    g_fenceTileList[tostring(directionToUuid("S"))] =
    "$GAME_DATA/Terrain/Tiles/CreativeTiles/Auto/Flatterrain_FenceS_01.tile"

    --	East
    g_fenceTileList[tostring(directionToUuid("E"))] =
    "$GAME_DATA/Terrain/Tiles/CreativeTiles/Auto/Flatterrain_FenceE_01.tile"

    --	West
    g_fenceTileList[tostring(directionToUuid("W"))] =
    "$GAME_DATA/Terrain/Tiles/CreativeTiles/Auto/Flatterrain_FenceW_01.tile"
end

local function writeTile(uid, xPos, yPos, size, rotation)
    assert(type(uid) == "Uuid")
    for y = 0, size - 1 do
        for x = 0, size - 1 do
            local cellX = x + xPos
            local cellY = y + yPos
            g_cellData.uid[cellY][cellX] = uid
            g_cellData.rotation[cellY][cellX] = rotation

            if rotation == 1 then
                g_cellData.xOffset[cellY][cellX] = y
                g_cellData.yOffset[cellY][cellX] = (size - 1) - x
            elseif rotation == 2 then
                g_cellData.xOffset[cellY][cellX] = (size - 1) - x
                g_cellData.yOffset[cellY][cellX] = (size - 1) - y
            elseif rotation == 3 then
                g_cellData.xOffset[cellY][cellX] = (size - 1) - y
                g_cellData.yOffset[cellY][cellX] = x
            else
                g_cellData.xOffset[cellY][cellX] = x
                g_cellData.yOffset[cellY][cellX] = y
            end
        end
    end
end

local function createFence(xMin, xMax, yMin, yMax, padding)
    local _xMin = xMin + padding;
    local _xMax = xMax - padding;

    local _yMin = yMin + padding;
    local _yMax = yMax - padding;

    for cellY = _yMin, _yMax do
        for cellX = _xMin, _xMax do
            if cellX == _xMin or cellX == _xMax or cellY == _yMin or cellY == _yMax then
                local direction = ""
                if cellY == _xMax then
                    direction = direction .. "N"
                elseif cellY == _xMin then
                    direction = direction .. "S"
                end

                if cellX == _xMax then
                    direction = direction .. "E"
                elseif cellX == _xMin then
                    direction = direction .. "W"
                end

                local uid = directionToUuid(direction)
                writeTile(uid, cellX, cellY, 1, 0)
            end
        end
    end
end

local function initializeCellData(xMin, xMax, yMin, yMax, seed)
    g_cellData = {
        bounds = { xMin = xMin, xMax = xMax, yMin = yMin, yMax = yMax },
        seed = seed,
        -- Per Cell
        uid = {},
        xOffset = {},
        yOffset = {},
        rotation = {}
    }

    -- Cells
    for cellY = yMin, yMax do
        g_cellData.uid[cellY] = {}
        g_cellData.xOffset[cellY] = {}
        g_cellData.yOffset[cellY] = {}
        g_cellData.rotation[cellY] = {}

        for cellX = xMin, xMax do
            g_cellData.uid[cellY][cellX] = sm.uuid.getNil()
            g_cellData.xOffset[cellY][cellX] = 0
            g_cellData.yOffset[cellY][cellX] = 0
            g_cellData.rotation[cellY][cellX] = 0
        end
    end
end

local function initializeTiledWorld(xMin, xMax, yMin, yMax, worldPath)
    g_uuidToPath = {}
    local jWorld = sm.json.open(worldPath)
    for _, cell in pairs(jWorld.cellData) do
        if cell.path ~= "" then
            local uid = sm.terrainTile.getTileUuid(cell.path)
            g_cellData.uid[cell.y][cell.x] = uid
            g_cellData.xOffset[cell.y][cell.x] = cell.offsetX
            g_cellData.yOffset[cell.y][cell.x] = cell.offsetY
            g_cellData.rotation[cell.y][cell.x] = cell.rotation
            g_uuidToPath[tostring(uid)] = cell.path
        end
    end
end

function Create(xMin, xMax, yMin, yMax, seed)
    xMin = xMin - 1
    xMax = xMax + 1
    yMin = yMin - 1
    yMax = yMax + 1

    initializeCellData(xMin, xMax, yMin, yMax, seed)

    createFence(xMin, xMax, yMin, yMax, 0)

    initializeTiledWorld(xMin, xMax, yMin, yMax, "$CONTENT_DATA/Terrain/Worlds/World 2x2.world")

    sm.terrainData.save({ g_uuidToPath, g_cellData })
end

function Load()
    if sm.terrainData.exists() then
        print("[Terrain] Loading terrain data")
        local data = sm.terrainData.load()
        g_uuidToPath = data[1]
        g_cellData = data[2]
        createFence(g_cellData.bounds.xMin, g_cellData.bounds.xMax, g_cellData.bounds.yMin, g_cellData.bounds.yMax, 0)
        return true
    end
    return false
end

function GetTilePath(uid)
    if not uid:isNil() then
        return g_uuidToPath[tostring(uid)]
    end
    return ""
end

function GetCellTileUidAndOffset(cellX, cellY)
    if InsideCellBounds(cellX, cellY) then
        return g_cellData.uid[cellY][cellX],
            g_cellData.xOffset[cellY][cellX],
            g_cellData.yOffset[cellY][cellX]
    end
    return sm.uuid.getNil(), 0, 0
end

function GetTileLoadParamsFromWorldPos(x, y, lod)
    local cellX, cellY = GetCell(x, y)
    local uid, tileCellOffsetX, tileCellOffsetY = GetCellTileUidAndOffset(cellX, cellY)
    local rx, ry = InverseRotateLocal(cellX, cellY, x - cellX * CELL_SIZE, y - cellY * CELL_SIZE)
    if lod then
        return uid, tileCellOffsetX, tileCellOffsetY, lod, rx, ry
    else
        return uid, tileCellOffsetX, tileCellOffsetY, rx, ry
    end
end

function GetTileLoadParamsFromCellPos(cellX, cellY, lod)
    local uid, tileCellOffsetX, tileCellOffsetY = GetCellTileUidAndOffset(cellX, cellY)
    if lod then
        return uid, tileCellOffsetX, tileCellOffsetY, lod
    else
        return uid, tileCellOffsetX, tileCellOffsetY
    end
end

function GetHeightAt(x, y, lod)
    return sm.terrainTile.getHeightAt(GetTileLoadParamsFromWorldPos(x, y, lod))
end

function GetColorAt(x, y, lod)
    local color = sm.color.new("#8d8f89")
    local noise = sm.noise.octaveNoise2d(x / 8, y / 8, 4, g_cellData.seed) / 4
    return color.r + noise, color.g + noise, color.b + noise, 1
end

function GetMaterialAt(x, y, lod)
    local noise1 = sm.noise.octaveNoise2d(x / 8, y / 8, 4, g_cellData.seed + 100)
    local normalizedNoise1 = (noise1 + 1) / 2
    local noise2 = sm.noise.octaveNoise2d(x / 8, y / 8, 4, g_cellData.seed + 200)
    local normalizedNoise2 = (noise2 + 1) / 2
    return 1, 0, normalizedNoise1, 0, 0, normalizedNoise2, 0, 0
end

function GetClutterIdxAt(x, y)
    return sm.terrainTile.getClutterIdxAt(GetTileLoadParamsFromWorldPos(x, y))
end

function GetAssetsForCell(cellX, cellY, lod)
    local assets = sm.terrainTile.getAssetsForCell(GetTileLoadParamsFromCellPos(cellX, cellY, lod))
    for _, asset in ipairs(assets) do
        local rx, ry = RotateLocal(cellX, cellY, asset.pos.x, asset.pos.y)
        asset.pos = sm.vec3.new(rx, ry, asset.pos.z)
        asset.rot = GetRotationQuat(cellX, cellY) * asset.rot
    end
    return assets
end

function GetNodesForCell(cellX, cellY)
    local nodes = sm.terrainTile.getNodesForCell(GetTileLoadParamsFromCellPos(cellX, cellY))
    for _, node in ipairs(nodes) do
        local rx, ry = RotateLocal(cellX, cellY, node.pos.x, node.pos.y)
        node.pos = sm.vec3.new(rx, ry, node.pos.z)
        node.rot = GetRotationQuat(cellX, cellY) * node.rot
    end
    return nodes
end

function GetCreationsForCell(cellX, cellY)
    local uid, tileCellOffsetX, tileCellOffsetY = GetCellTileUidAndOffset(cellX, cellY)
    if not uid:isNil() then
        local cellCreations = sm.terrainTile.getCreationsForCell(uid, tileCellOffsetX, tileCellOffsetY)
        for i, creation in ipairs(cellCreations) do
            local rx, ry = RotateLocal(cellX, cellY, creation.pos.x, creation.pos.y)

            creation.pos = sm.vec3.new(rx, ry, creation.pos.z)
            creation.rot = GetRotationQuat(cellX, cellY) * creation.rot
        end

        return cellCreations
    end

    return {}
end

function GetHarvestablesForCell(cellX, cellY, lod)
    local harvestables = sm.terrainTile.getHarvestablesForCell(GetTileLoadParamsFromCellPos(cellX, cellY, lod))
    for _, harvestable in ipairs(harvestables) do
        local rx, ry = RotateLocal(cellX, cellY, harvestable.pos.x, harvestable.pos.y)
        harvestable.pos = sm.vec3.new(rx, ry, harvestable.pos.z)
        harvestable.rot = GetRotationQuat(cellX, cellY) * harvestable.rot
    end
    return harvestables
end

function GetKinematicsForCell(cellX, cellY, lod)
    local kinematics = sm.terrainTile.getKinematicsForCell(GetTileLoadParamsFromCellPos(cellX, cellY, lod))
    for _, kinematic in ipairs(kinematics) do
        local rx, ry = RotateLocal(cellX, cellY, kinematic.pos.x, kinematic.pos.y)
        kinematic.pos = sm.vec3.new(rx, ry, kinematic.pos.z)
        kinematic.rot = GetRotationQuat(cellX, cellY) * kinematic.rot
    end
    return kinematics
end

function GetDecalsForCell(cellX, cellY, lod)
    local decals = sm.terrainTile.getDecalsForCell(GetTileLoadParamsFromCellPos(cellX, cellY, lod))
    for _, decal in ipairs(decals) do
        local rx, ry = RotateLocal(cellX, cellY, decal.pos.x, decal.pos.y)
        decal.pos = sm.vec3.new(rx, ry, decal.pos.z)
        decal.rot = GetRotationQuat(cellX, cellY) * decal.rot
    end
    return decals
end

function GetTilePath(uid)
    if not uid:isNil() then
        if g_fenceTileList[tostring(uid)] then
            return g_fenceTileList[tostring(uid)]
        elseif g_uuidToPath[tostring(uid)] then
            return g_uuidToPath[tostring(uid)]
        end
    end
    return ""
end
