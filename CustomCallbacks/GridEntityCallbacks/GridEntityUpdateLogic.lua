local function OnTSILLoad()
    TSIL.SaveManager.AddPersistentVariable(
        TSIL.__MOD,
        "initializedGridEntities_GRID_ENTITY_UPDATE_LOGIC",
        {},
        TSIL.Enums.VariablePersistenceMode.RESET_ROOM
    )
end
TSIL.__AddInternalCallback(
    "GRID_ENTITY_UPDATE_LOGIC_ON_TSIL_LOAD",
    TSIL.Enums.CustomCallback.POST_TSIL_LOAD,
    OnTSILLoad
)


local function CheckGridEntitiesRemoved()
    local initializedGridEntities = TSIL.SaveManager.GetPersistentVariable(
        TSIL.__MOD,
        "initializedGridEntities_GRID_ENTITY_UPDATE_LOGIC"
    )

    local room = Game():GetRoom()

    for gridIndex, gridEntityTuple in pairs(initializedGridEntities) do
        local storedGridEntityType = gridEntityTuple.Type
        local storedGridEntityVariant = gridEntityTuple.Variant

        local gridEntity = room:GetGridEntity(gridIndex)

        if gridEntity == nil or gridEntity:GetType() ~= storedGridEntityType then
            initializedGridEntities[gridIndex] = nil

            TSIL.__TriggerCustomCallback(
                TSIL.Enums.CustomCallback.POST_GRID_ENTITY_REMOVED,
                storedGridEntityType,
                storedGridEntityVariant,
                gridIndex
            )
        end
    end
end


---@param gridEntity GridEntity
local function UpdateTupleInMap(gridEntity)
    local gridEntityType = gridEntity:GetType()
    local variant = gridEntity:GetVariant()
    local gridIndex = gridEntity:GetGridIndex()
    local newTuple = {
        Type = gridEntityType,
        Variant = variant,
        State = gridEntity.State,
    }

    local initializedGridEntities = TSIL.SaveManager.GetPersistentVariable(
        TSIL.__MOD,
        "initializedGridEntities_GRID_ENTITY_UPDATE_LOGIC"
    )
    initializedGridEntities[gridIndex] = newTuple
end


---@param gridIndex integer
---@param gridEntity GridEntity
local function CheckGridEntityStateChanged(gridIndex, gridEntity)
    local initializedGridEntities = TSIL.SaveManager.GetPersistentVariable(
        TSIL.__MOD,
        "initializedGridEntities_GRID_ENTITY_UPDATE_LOGIC"
    )
    local gridEntityTuple = initializedGridEntities[gridIndex]
    if gridEntityTuple == nil then
        return
    end

    local oldState = gridEntityTuple.State
    local newState = gridEntity.State;
    if oldState ~= newState then
        UpdateTupleInMap(gridEntity);

        TSIL.__TriggerCustomCallback(
            TSIL.Enums.CustomCallback.POST_GRID_ENTITY_STATE_CHANGED,
            gridEntity,
            oldState,
            newState
        )

        if TSIL.GridEntities.IsGridEntityBroken(gridEntity) then
            TSIL.__TriggerCustomCallback(
                TSIL.Enums.CustomCallback.POST_GRID_ENTITY_BROKEN,
                gridEntity
            )
        end
    end
end


---@param gridIndex integer
---@param gridEntity GridEntity
local function CheckNewGridEntity(gridIndex, gridEntity)
    local initializedGridEntities = TSIL.SaveManager.GetPersistentVariable(
        TSIL.__MOD,
        "initializedGridEntities_GRID_ENTITY_UPDATE_LOGIC"
    )
    local gridEntityTuple = initializedGridEntities[gridIndex]
    local gridEntityType = gridEntity:GetType()

    if gridEntityTuple and gridEntityTuple.Type ~= gridEntityType then
        TSIL.__TriggerCustomCallback(
            TSIL.Enums.CustomCallback.POST_GRID_ENTITY_REMOVED,
            gridEntityTuple.Type,
            gridEntityTuple.Variant,
            gridIndex
        )
    end

    if gridEntityTuple == nil or gridEntityTuple.Type ~= gridEntityType then
        UpdateTupleInMap(gridEntity)
    end
end


local function OnNewRoom()
    local gridEntitiesMap = TSIL.GridEntities.GetGridEntitiesMap()

    for gridIndex, gridEntity in pairs(gridEntitiesMap) do
        CheckNewGridEntity(gridIndex, gridEntity);
    end
end
TSIL.__AddInternalCallback(
    "GRID_ENTITY_UPDATE_LOGIC_ON_NEW_ROOM_REORDERED",
    TSIL.Enums.CustomCallback.POST_NEW_ROOM_REORDERED,
    OnNewRoom
)


local function OnUpdate()
    CheckGridEntitiesRemoved()
end
TSIL.__AddInternalCallback(
    "GRID_ENTITY_UPDATE_LOGIC_ON_UPDATE",
    ModCallbacks.MC_POST_UPDATE,
    OnUpdate
)


---@param gridEntityDecoration GridEntityDecoration
local function OnGridEntityDecorationUpdate(_, gridEntityDecoration)
    local gridIndex = gridEntityDecoration:GetGridIndex()
    CheckGridEntityStateChanged(gridIndex, gridEntityDecoration);
    CheckNewGridEntity(gridIndex, gridEntityDecoration);
end
TSIL.__AddInternalCallback(
    "GRID_ENTITY_UPDATE_LOGIC_GRID_ENTITY_DECORATION_UPDATE",
    ModCallbacks.MC_POST_GRID_ENTITY_DECORATION_UPDATE,
    OnGridEntityDecorationUpdate
)


---@param gridEntityDoor GridEntityDoor
local function OnGridEntityDoorUpdate(_, gridEntityDoor)
    local gridIndex = gridEntityDoor:GetGridIndex()
    CheckGridEntityStateChanged(gridIndex, gridEntityDoor);
    CheckNewGridEntity(gridIndex, gridEntityDoor);
end
TSIL.__AddInternalCallback(
    "GRID_ENTITY_UPDATE_LOGIC_GRID_ENTITY_DOOR_UPDATE",
    ModCallbacks.MC_POST_GRID_ENTITY_DOOR_UPDATE,
    OnGridEntityDoorUpdate
)


---@param gridEntityFire GridEntityFire
local function OnGridEntityFireUpdate(_, gridEntityFire)
    local gridIndex = gridEntityFire:GetGridIndex()
    CheckGridEntityStateChanged(gridIndex, gridEntityFire);
    CheckNewGridEntity(gridIndex, gridEntityFire);
end
TSIL.__AddInternalCallback(
    "GRID_ENTITY_UPDATE_LOGIC_GRID_ENTITY_FIRE_UPDATE",
    ModCallbacks.MC_POST_GRID_ENTITY_FIRE_UPDATE,
    OnGridEntityFireUpdate
)


---@param gridEntityGravity GridEntityGravity
local function OnGridEntityGravityUpdate(_, gridEntityGravity)
    local gridIndex = gridEntityGravity:GetGridIndex()
    CheckGridEntityStateChanged(gridIndex, gridEntityGravity);
    CheckNewGridEntity(gridIndex, gridEntityGravity);
end
TSIL.__AddInternalCallback(
    "GRID_ENTITY_UPDATE_LOGIC_GRID_ENTITY_GRAVITY_UPDATE",
    ModCallbacks.MC_POST_GRID_ENTITY_GRAVITY_UPDATE,
    OnGridEntityGravityUpdate
)


---@param gridEntityLock GridEntityLock
local function OnGridEntityLockUpdate(_, gridEntityLock)
    local gridIndex = gridEntityLock:GetGridIndex()
    CheckGridEntityStateChanged(gridIndex, gridEntityLock);
    CheckNewGridEntity(gridIndex, gridEntityLock);
end
TSIL.__AddInternalCallback(
    "GRID_ENTITY_UPDATE_LOGIC_GRID_ENTITY_LOCK_UPDATE",
    ModCallbacks.MC_POST_GRID_ENTITY_LOCK_UPDATE,
    OnGridEntityLockUpdate
)


---@param gridEntityPit GridEntityPit
local function OnGridEntityPitUpdate(_, gridEntityPit)
    local gridIndex = gridEntityPit:GetGridIndex()
    CheckGridEntityStateChanged(gridIndex, gridEntityPit);
    CheckNewGridEntity(gridIndex, gridEntityPit);
end
TSIL.__AddInternalCallback(
    "GRID_ENTITY_UPDATE_LOGIC_GRID_ENTITY_PIT_UPDATE",
    ModCallbacks.MC_POST_GRID_ENTITY_PIT_UPDATE,
    OnGridEntityPitUpdate
)


---@param gridEntityPoop GridEntityPoop
local function OnGridEntityPoopUpdate(_, gridEntityPoop)
    local gridIndex = gridEntityPoop:GetGridIndex()
    CheckGridEntityStateChanged(gridIndex, gridEntityPoop);
    CheckNewGridEntity(gridIndex, gridEntityPoop);
end
TSIL.__AddInternalCallback(
    "GRID_ENTITY_UPDATE_LOGIC_GRID_ENTITY_POOP_UPDATE",
    ModCallbacks.MC_POST_GRID_ENTITY_POOP_UPDATE,
    OnGridEntityPoopUpdate
)


---@param gridEntityPressurePlate GridEntityPressurePlate
local function OnGridEntityPressurePlateUpdate(_, gridEntityPressurePlate)
    local gridIndex = gridEntityPressurePlate:GetGridIndex()
    CheckGridEntityStateChanged(gridIndex, gridEntityPressurePlate);
    CheckNewGridEntity(gridIndex, gridEntityPressurePlate);
end
TSIL.__AddInternalCallback(
    "GRID_ENTITY_UPDATE_LOGIC_GRID_ENTITY_PRESSUREPLATE_UPDATE",
    ModCallbacks.MC_POST_GRID_ENTITY_PRESSUREPLATE_UPDATE,
    OnGridEntityPressurePlateUpdate
)


---@param gridEntityRock GridEntityRock
local function OnGridEntityRockUpdate(_, gridEntityRock)
    local gridIndex = gridEntityRock:GetGridIndex()
    CheckGridEntityStateChanged(gridIndex, gridEntityRock);
    CheckNewGridEntity(gridIndex, gridEntityRock);
end
TSIL.__AddInternalCallback(
    "GRID_ENTITY_UPDATE_LOGIC_GRID_ENTITY_ROCK_UPDATE",
    ModCallbacks.MC_POST_GRID_ENTITY_ROCK_UPDATE,
    OnGridEntityRockUpdate
)


---@param gridEntitySpikes GridEntitySpikes
local function OnGridEntitySpikesUpdate(_, gridEntitySpikes)
    local gridIndex = gridEntitySpikes:GetGridIndex()
    CheckGridEntityStateChanged(gridIndex, gridEntitySpikes);
    CheckNewGridEntity(gridIndex, gridEntitySpikes);
end
TSIL.__AddInternalCallback(
    "GRID_ENTITY_UPDATE_LOGIC_GRID_ENTITY_SPIKES_UPDATE",
    ModCallbacks.MC_POST_GRID_ENTITY_SPIKES_UPDATE,
    OnGridEntitySpikesUpdate
)


---@param gridEntityStairs GridEntityStairs
local function OnGridEntityStairsUpdate(_, gridEntityStairs)
    local gridIndex = gridEntityStairs:GetGridIndex()
    CheckGridEntityStateChanged(gridIndex, gridEntityStairs);
    CheckNewGridEntity(gridIndex, gridEntityStairs);
end
TSIL.__AddInternalCallback(
    "GRID_ENTITY_UPDATE_LOGIC_GRID_ENTITY_STAIRCASE_UPDATE",
    ModCallbacks.MC_POST_GRID_ENTITY_STAIRCASE_UPDATE,
    OnGridEntityStairsUpdate
)


---@param gridEntityStatue GridEntityStatue
local function OnGridEntityStatueUpdate(_, gridEntityStatue)
    local gridIndex = gridEntityStatue:GetGridIndex()
    CheckGridEntityStateChanged(gridIndex, gridEntityStatue);
    CheckNewGridEntity(gridIndex, gridEntityStatue);
end
TSIL.__AddInternalCallback(
    "GRID_ENTITY_UPDATE_LOGIC_GRID_ENTITY_STATUE_UPDATE",
    ModCallbacks.MC_POST_GRID_ENTITY_STATUE_UPDATE,
    OnGridEntityStatueUpdate
)


---@param gridEntityTeleporter GridEntityTeleporter
local function OnGridEntityTeleporterUpdate(_, gridEntityTeleporter)
    local gridIndex = gridEntityTeleporter:GetGridIndex()
    CheckGridEntityStateChanged(gridIndex, gridEntityTeleporter);
    CheckNewGridEntity(gridIndex, gridEntityTeleporter);
end
TSIL.__AddInternalCallback(
    "GRID_ENTITY_UPDATE_LOGIC_GRID_ENTITY_TELEPORTER_UPDATE",
    ModCallbacks.MC_POST_GRID_ENTITY_TELEPORTER_UPDATE,
    OnGridEntityTeleporterUpdate
)


---@param gridEntityTNT GridEntityTNT
local function OnGridEntityTNTUpdate(_, gridEntityTNT)
    local gridIndex = gridEntityTNT:GetGridIndex()
    CheckGridEntityStateChanged(gridIndex, gridEntityTNT);
    CheckNewGridEntity(gridIndex, gridEntityTNT);
end
TSIL.__AddInternalCallback(
    "GRID_ENTITY_UPDATE_LOGIC_GRID_ENTITY_TNT_UPDATE",
    ModCallbacks.MC_POST_GRID_ENTITY_TNT_UPDATE,
    OnGridEntityTNTUpdate
)


---@param gridEntityTrapDoor GridEntityTrapDoor
local function OnGridEntityTrapDoorUpdate(_, gridEntityTrapDoor)
    local gridIndex = gridEntityTrapDoor:GetGridIndex()
    CheckGridEntityStateChanged(gridIndex, gridEntityTrapDoor);
    CheckNewGridEntity(gridIndex, gridEntityTrapDoor);
end
TSIL.__AddInternalCallback(
    "GRID_ENTITY_UPDATE_LOGIC_GRID_ENTITY_TRAPDOOR_UPDATE",
    ModCallbacks.MC_POST_GRID_ENTITY_TRAPDOOR_UPDATE,
    OnGridEntityTrapDoorUpdate
)


---@param gridEntityWeb GridEntityWeb
local function OnGridEntityWebUpdate(_, gridEntityWeb)
    local gridIndex = gridEntityWeb:GetGridIndex()
    CheckGridEntityStateChanged(gridIndex, gridEntityWeb);
    CheckNewGridEntity(gridIndex, gridEntityWeb);
end
TSIL.__AddInternalCallback(
    "GRID_ENTITY_UPDATE_LOGIC_GRID_ENTITY_WEB_UPDATE",
    ModCallbacks.MC_POST_GRID_ENTITY_WEB_UPDATE,
    OnGridEntityWebUpdate
)