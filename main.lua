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
    }
    --Adjusts how much float jumps the character can do before dropping to the floor.
    --FLOAT_CONSTANT = 5

    ---@type integer
    --Bitfield Containing Boo Moveset Flags.
    gPlayerSyncTable[0].booState = 0

    --Table Containing Boo Moveset Flags.
    gBooFlagsTable = {}
    
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

    _G.BooMovesetAPI = BooMovesetAPI
end
