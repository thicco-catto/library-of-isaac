---@param functions ScheduledFunction[]
local function UpdateScheludedFunctions(functions)
	local indexesToRemove = {}

	local length = #functions
	for i = 1, length, 1 do
		local scheduledFunction = functions[i]

		scheduledFunction.frames = scheduledFunction.frames - 1

		if scheduledFunction.frames <= 0 then
			scheduledFunction.funct(table.unpack(scheduledFunction.params))
			table.insert(indexesToRemove, 1, i)
		end
	end

	for _, index in ipairs(indexesToRemove) do
		table.remove(functions, index)
	end
end

---@param functions ScheduledFunction[]
local function ClearScheludedFunctions(functions)
	local length = #functions
	for i = 1, length, 1 do
		functions[i] = nil
	end
end


local function OnFrameUpdate()
	UpdateScheludedFunctions(TSIL.__VERSION_PERSISTENT_DATA.ScheduledFunctions)
	UpdateScheludedFunctions(TSIL.__VERSION_PERSISTENT_DATA.TemporaryScheduledFunctions)
end
TSIL.__AddInternalCallback(
	"SCHEDULER_POST_UPDATE",
	ModCallbacks.MC_POST_UPDATE,
	OnFrameUpdate
)


local function OnNewRoom()
	ClearScheludedFunctions(TSIL.__VERSION_PERSISTENT_DATA.TemporaryScheduledFunctions)
end
TSIL.__AddInternalCallback(
	"SCHEDULER_POST_NEW_ROOM",
	ModCallbacks.MC_POST_NEW_ROOM,
	OnNewRoom
)


local function OnGameExit()
	ClearScheludedFunctions(TSIL.__VERSION_PERSISTENT_DATA.ScheduledFunctions)
	ClearScheludedFunctions(TSIL.__VERSION_PERSISTENT_DATA.TemporaryScheduledFunctions)
end
TSIL.__AddInternalCallback(
	"SCHEDULER_PRE_GAME_EXIT",
	ModCallbacks.MC_PRE_GAME_EXIT,
	OnGameExit
)


--- Runs a function in a given number of frames.
---@param funct function
---@param frames integer
---@param ... any
function TSIL.Utils.Functions.RunInFrames(funct, frames, ...)
	local args = {...}
	local newindex = #TSIL.__VERSION_PERSISTENT_DATA.ScheduledFunctions + 1
	TSIL.__VERSION_PERSISTENT_DATA.ScheduledFunctions[newindex] = {funct = funct, frames = frames, params = args}
end


--- Runs a function in a given number of frames.
--- 
--- Unlike `TSIL.Utils.Functions.RunInFrames` this will not persist when moving to a different room.
---@param funct function
---@param frames integer
---@param ... any
function TSIL.Utils.Functions.RunInFramesTemporary(funct, frames, ...)
	local args = {...}
	local newindex = #TSIL.__VERSION_PERSISTENT_DATA.TemporaryScheduledFunctions + 1
	TSIL.__VERSION_PERSISTENT_DATA.TemporaryScheduledFunctions[newindex] = {funct = funct, frames = frames, params = args}
end