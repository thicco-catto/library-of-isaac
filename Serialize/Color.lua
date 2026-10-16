local ALL_KEYS = {"R", "G", "B", "A", "RO", "GO", "BO", "RC", "GC", "BC", "AC"}
local COPYABLE_KEYS = {"R", "G", "B", "A", "RO", "GO", "BO"}
local OBJECT_NAME = "Color"


---Helper function to convert a serialized object to a normal `Color` object. (This
---is used by the save data manager when reading data from the "save#.dat" file.)
---@param color table<unknown, unknown>
---@return Color
function TSIL.Serialize.DeserializeColor(color)
    if type(color) ~= "table" then
        error("Failed to deserialize a " .. OBJECT_NAME .. " object since the provided object was not a table")
    end

    local numbers = TSIL.Utils.Tables.GetNumbersFromTable(color, OBJECT_NAME, table.unpack(ALL_KEYS))

    if numbers[1] == nil then
        error("Failed to deserialize a " .. OBJECT_NAME .. " as the provided object did not have a value for: R")
    elseif numbers[2] == nil then
        error("Failed to deserialize a " .. OBJECT_NAME .. " as the provided object did not have a value for: G")
    elseif numbers[3] == nil then
        error("Failed to deserialize a " .. OBJECT_NAME .. " as the provided object did not have a value for: B")
    end

    return Color(numbers[1], numbers[2], numbers[3], numbers[4], numbers[5], numbers[6], numbers[7], numbers[8], numbers[9], numbers[10], numbers[11])
end


---Used to determine is the given table is a serialized `Color` object created by the `deepCopy`
---function.
---@param object unknown
---@return boolean
function TSIL.Serialize.IsSerializedColor(object)
    if type(object) ~= "table" then
        return false
    end

    return not not (TSIL.Utils.Tables.TableHasKeys(object, table.unpack(ALL_KEYS)) and object[TSIL.Enums.SerializationBrand.COLOR] ~= nil)
end


---Helper function to convert a `Color` object to a serialized version.
---@param color Color
---@return unknown
function TSIL.Serialize.SerializeColor(color)
    if not TSIL.IsaacAPIClass.IsColor(color) then
        error("Failed to serialize a " .. OBJECT_NAME .. " object since the provided object was not a userdata " .. OBJECT_NAME .. " class.")
    end

    local colorTable = {}
    TSIL.Utils.Tables.CopyUserdataValuesToTable(color, COPYABLE_KEYS, colorTable)

    local colorize = color:GetColorize()
    colorTable["RC"] = colorize.R
    colorTable["GC"] = colorize.G
    colorTable["BC"] = colorize.B
    colorTable["AC"] = colorize.A

    colorTable[TSIL.Enums.SerializationBrand.COLOR] = ""
    return colorTable
end