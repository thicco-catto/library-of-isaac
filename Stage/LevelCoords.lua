local LEVEL_GRID_MAP_SIZE = 13

---Coverts a level grid index to a set of coordinates that represent
---the grid index in the level grid map.
---
---Note that this doesn't verify if the given grid index is valid.
---@param gridIndex integer
---@return Vector
function TSIL.Stage.GridIndexToCoords(gridIndex)
    local x = gridIndex % LEVEL_GRID_MAP_SIZE
    local y = math.floor(gridIndex / LEVEL_GRID_MAP_SIZE)

    return Vector(x, y)
end


---Converts a set of level grid map coordinates into its respective
---grid index.
---
---Note that this doesn't verify if the given coordinates are valid.
---@param coords Vector
---@return integer
function TSIL.Stage.CoordsToGridIndex(coords)
    return coords.X + coords.Y * LEVEL_GRID_MAP_SIZE
end


---Helper function to check if the given level grid map coordinates
---are inside the map.
---@param coords Vector
---@return boolean
function TSIL.Stage.AreCoordsValid(coords)
    return coords.X >= 0 and coords.X < LEVEL_GRID_MAP_SIZE and coords.Y >= 0 and coords.Y < LEVEL_GRID_MAP_SIZE
end