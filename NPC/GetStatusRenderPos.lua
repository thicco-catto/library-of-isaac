---Returns the screen position where a status effect icon would be rendered
---for the given enemy.
---@param npc EntityNPC
function TSIL.NPC.GetStatusRenderPosition(npc)
    local baseRenderPos = Isaac.WorldToScreen(npc.Position)

    local sprite = npc:GetSprite()
    local overlayFrame = sprite:GetNullFrame("OverlayEffect")

    if overlayFrame then
        local offset = overlayFrame:GetPos()
        return baseRenderPos + offset * npc.Scale
    else
        return baseRenderPos + Vector(0, -20) * npc.Scale
    end
end