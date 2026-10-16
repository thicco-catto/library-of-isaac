---@generic T
---@param entityType EntityType
---@param variant integer?
---@param subtype integer?
---@param cast fun(entity: Entity): T?
---@param ignoreFriendly boolean?
---@return fun(): T?
local function CreateIterator(entityType, variant, subtype, cast, ignoreFriendly)
	local entities = TSIL.Entities.GetEntities(entityType, variant, subtype, ignoreFriendly)
    local i = 0

    return function ()
        local bomb
        repeat
            i = i + 1
            local entity = entities[i]
            if not entity then return end

            bomb = cast(entity)
        until bomb

        return bomb
    end
end


--- Helper function to get all of the bombs in the room in an iterator. (Specifically, this refers to the `EntityBomb` class, not bomb pickups.)
--- ```lua
---    for bomb in TSIL.EntitySpecific.GetBombsIter() do body end
--- ```
---@param bombVariant BombVariant|integer? @Default: -1 | Default is -1, which matches all variants.
---@param subType integer? @Default: -1 | Default is -1, which matches all sub-types.
---@return fun(): EntityBomb?
function TSIL.EntitySpecific.GetBombsIter(bombVariant, subType)
    return CreateIterator(EntityType.ENTITY_BOMB, bombVariant, subType, function (entity)
        return entity:ToBomb()
    end)
end


--- Helper function to get all of the effects in the room in an iterator.
--- ```lua
---    for effect in TSIL.EntitySpecific.GetEffectsIter() do body end
--- ```
---@param effectVariant EffectVariant|integer? @Default: -1 | Default is -1, which matches all variants.
---@param subType integer? @Default: -1 | Default is -1, which matches all sub-types.
---@return fun(): EntityEffect?
function TSIL.EntitySpecific.GetEffectsIter(effectVariant, subType)
    return CreateIterator(EntityType.ENTITY_EFFECT, effectVariant, subType, function (entity)
        return entity:ToEffect()
    end)
end


--- Helper function to get all of the familiars in the room in an iterator.
--- ```lua
---    for familiar in TSIL.EntitySpecific.GetFamiliarsIter() do body end
--- ```
---@param familiarVariant FamiliarVariant|integer? @Default: -1 | Default is -1, which matches all variants.
---@param subType integer? @Default: -1 | Default is -1, which matches all sub-types.
---@return fun(): EntityFamiliar?
function TSIL.EntitySpecific.GetFamiliarsIter(familiarVariant, subType)
	return CreateIterator(EntityType.ENTITY_FAMILIAR, familiarVariant, subType, function (entity)
        return entity:ToFamiliar()
    end)
end


--- Helper function to get all of the knives in the room in an iterator.
--- ```lua
---    for knife in TSIL.EntitySpecific.GetKnivesIter() do body end
--- ```
---@param knifeVariant KnifeVariant|integer? @Default: -1 | Default is -1, which matches all variants.
---@param subType integer? @Default: -1 | Default is -1, which matches all sub-types.
---@return fun(): EntityKnife?
function TSIL.EntitySpecific.GetKnivesIter(knifeVariant, subType)
	return CreateIterator(EntityType.ENTITY_KNIFE, knifeVariant, subType, function (entity)
        return entity:ToKnife()
    end)
end


--- Helper function to get all of the lasers in the room in an iterator.
--- ```lua
---    for laser in TSIL.EntitySpecific.GetLasersIter() do body end
--- ```
---@param laserVariant LaserVariant|integer? @Default: -1 | Default is -1, which matches all variants.
---@param subType integer? @Default: -1 | Default is -1, which matches all sub-types.
---@return fun(): EntityLaser?
function TSIL.EntitySpecific.GetLasersIter(laserVariant, subType)
	return CreateIterator(EntityType.ENTITY_LASER, laserVariant, subType, function (entity)
        return entity:ToLaser()
    end)
end


--- Helper function to get all of the NPCs in the room in an iterator.
--- ```lua
---    for npc in TSIL.EntitySpecific.GetNPCs() do body end
--- ```
---@param entityType EntityType|integer? @Default: -1 | Default is -1, which matches all types.
---@param variant integer? @Default: -1 | Default is -1, which matches all variants.
---@param subType integer? @Default: -1 | Default is -1, which matches all sub-types.
---@param ignoreFriendly boolean? @Default: false | If set to true, it will exclude friendly NPCs from being returned. Default is false. Will only be taken into account if the `entityType` is specified.
---@return fun(): EntityNPC?
function TSIL.EntitySpecific.GetNPCs(entityType, variant, subType, ignoreFriendly)
	return CreateIterator(entityType, variant, subType, function (entity)
        return entity:ToNPC()
    end, ignoreFriendly)
end


--- Helper function to get all of the pickups in the room in an iterator.
--- ```lua
---    for pickup in TSIL.EntitySpecific.GetPickupsIter() do body end
--- ```
---@param pickupVariant PickupVariant|integer? @Default: -1 | Default is -1, which matches all variants.
---@param subType integer? @Default: -1 | Default is -1, which matches all sub-types.
---@return fun(): EntityPickup?
function TSIL.EntitySpecific.GetPickupsIter(pickupVariant, subType)
    return CreateIterator(EntityType.ENTITY_PICKUP, pickupVariant, subType, function (entity)
        return entity:ToNPC()
    end)
end


--- Helper function to get all of the projectiles in the room in an iterator.
--- ```lua
---    for projectile in TSIL.EntitySpecific.GetProjectilesIter() do body end
--- ```
---@param projectileVariant ProjectileVariant|integer? @Default: -1 | Default is -1, which matches all variants.
---@param subType integer? @Default: -1 | Default is -1, which matches all sub-types.
---@return fun(): EntityProjectile?
function TSIL.EntitySpecific.GetProjectilesIter(projectileVariant, subType)
	return CreateIterator(EntityType.ENTITY_PROJECTILE, projectileVariant, subType, function (entity)
        return entity:ToProjectile()
    end)
end


--- Helper function to get all of the slots in the room in an iterator.
--- ```lua
---    for slots in TSIL.EntitySpecific.GetSlotsIter() do body end
--- ```
---@param slotVariant SlotVariant|integer? @Default: -1 | Default is -1, which matches all variants.
---@param subType integer? @Default: -1 | Default is -1, which matches all sub-types.
---@return fun(): EntitySlot?
function TSIL.EntitySpecific.GetSlotsIter(slotVariant, subType)
	return CreateIterator(EntityType.ENTITY_SLOT, slotVariant, subType, function (entity)
        return entity:ToSlot()
    end)
end


--- Helper function to get all of the tears in the room in an iterator.
--- ```lua
---    for tear in TSIL.EntitySpecific.GetTearsIter() do body end
--- ```
---@param tearVariant TearVariant|integer? @Default: -1 | Default is -1, which matches all variants.
---@param subType integer? @Default: -1 | Default is -1, which matches all sub-types.
---@return fun(): EntityTear?
function TSIL.EntitySpecific.GetTearsIter(tearVariant, subType)
	return CreateIterator(EntityType.ENTITY_TEAR, tearVariant, subType, function (entity)
        return entity:ToTear()
    end)
end