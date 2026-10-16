--- Helper function to lineally interpolate between two angles.
---@param a number @Given in radians
---@param b number @Given in radians
---@param t number
---@return number
---@overload fun(a: Vector, b: Vector, t: number): Vector
function TSIL.Utils.Math.LerpAngle(a, b, t)
	local CS = (1 - t) * math.cos(a) + t * math.cos(b)
    local SN = (1 - t) * math.sin(a) + t * math.sin(b)
    return math.atan(SN, CS)
end