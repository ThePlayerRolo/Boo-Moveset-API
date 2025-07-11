-- name: Boo Moveset API
-- description: A Boo Moveset API for CS Mods\n\n\\#ffff00\\Credits: Wibblus's Bowser Moveset\n\n\\#ff7777\\This API requires Character Select\nto use as a Library!


local BooMovesetAPI = {}
do
    local _ENV = setmetatable(BooMovesetAPI, { __index = _ENV })
    IS_ACTIVE = true;
    --Flag Defines for Boo Moveset Characters.
    gBooMovesetFlags = {
        --Allows the character to do float jumps.
        FLAG_FLOAT_ENABLED = (1 << 0),
        --Enables Vanishing for your Character.
        FLAG_VANISH_ENABLED     = (1 << 1),
        --Enables Floating On Water for your Character.
        FLAG_WATER_FLOAT_ENABLED = (1 << 2),

    }
    --Adjusts how much float jumps the character can do before dropping to the floor.
    --FLOAT_CONSTANT = 5

    ---@type integer
    --Bitfield Containing Boo Moveset Flags.
    for i = 0, MAX_PLAYERS - 1 do
        local p = gPlayerSyncTable[i]
        p.booState = 0
    end

    --Table Containing Boo Moveset Flags.
    gBooFlagsTable = {}
    --Table Containing Boo Float Values
    gBooFloatValuesTable = {}

    --Table Checking If You Can Walk On Water
    gBooFloatOnWater = {}
    --Table Checking If The Player Walked On Water
    gBooFloatedOnWater = {}

    ---@param m MarioState
    ---@return boolean
    ---Checks if You Have The Proper Flags. (Quite literally Wibblus's Implementation)
    function has_boo_flags(m, flags)
        return (gPlayerSyncTable[m.playerIndex].booState & flags ~= 0)
    end

    --Applys Boo Flags to Player. (Quite literally Wibblus's Implementation)
    function apply_player_boo_flags()
        local flags = gBooFlagsTable[_G.charSelect.character_get_current_table().model]
        if flags then
            gPlayerSyncTable[0].booState = flags
        else
            gPlayerSyncTable[0].booState = 0
        end
    end

    ---@param characterModelID ModelExtendedId|integer the model ID supplied to CS (e.g. E_MODEL_ARMATURE)
    ---@param flags integer bitfield of combined moveset flags (e.g. FLAG_FLOAT_ENABLED)
    ---A function that sets Boo Moveset Flags. (Quite literally Wibblus's Implementation)
    function character_set_boo_flags(characterModelID, flags)
        if characterModelID == nil then return end
        gBooFlagsTable[characterModelID] = flags
    end
    


    --- @param characterModelID ModelExtendedId|integer
    --- @param FloatDataTable table -- Table with Float Data
    --- Sets The Boo Float Data for the Extended Model ID
    function character_set_boo_float_data(characterModelID, FloatDataTable)
        if FloatDataTable == nil then
            djui_popup_create("Boo Moveset API Error:\n The Float Table Does Not Exist!\n", 2)
            return
        end
        gBooFloatValuesTable[characterModelID] = FloatDataTable
    end

    _G.BooMovesetAPI = BooMovesetAPI
end
