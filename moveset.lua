ACT_BOO_FLOAT = allocate_mario_action(ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION | ACT_FLAG_CONTROL_JUMP_HEIGHT | 
ACT_FLAG_ALLOW_FIRST_PERSON | ACT_FLAG_PAUSE_EXIT)
ACT_BOO_VANISH = allocate_mario_action(ACT_GROUP_CUTSCENE | ACT_FLAG_STATIONARY | ACT_FLAG_INTANGIBLE)


local FLOAT_AMOUT_CONSTANT = 5;

local BOO_FLOAT_WHITELIST = {
    [ACT_JUMP] = true,
    [ACT_DOUBLE_JUMP] = true,
    [ACT_TRIPLE_JUMP] = true,
    [ACT_LONG_JUMP] = true,
    [ACT_FREEFALL] = true
}

if charSelect then
    gPlayerSyncTable[0].CURRENT_FLOAT_AMOUNT = BooMovesetAPI.gBooFloatValuesTable[charSelect.character_get_current_table().model].MAX_FLOATS;
end
    gPlayerSyncTable[0].FLOAT_TIMER = 5;
    gPlayerSyncTable[0].VANISH_TIMER = 5;

function act_boo_float(m)
    if gPlayerSyncTable[0].FLOAT_TIMER == 0 then
          audio_sample_play(BooMovesetAPI.gBooFloatValuesTable[charSelect.character_get_current_table().model].FLOAT_SOUNDEFFECT, gMarioStates[0].pos, 1)  
    end
    m.intendedMag = m.intendedMag / 2
    common_air_action_step(m, ACT_FREEFALL_LAND, CHAR_ANIM_IDLE_HEAD_CENTER, AIR_STEP_CHECK_LEDGE_GRAB);
    m.intendedMag = m.intendedMag * 2
    m.vel.y = 0;
    m.vel.y = m.vel.y + 20;
    if gPlayerSyncTable[0].FLOAT_TIMER == 10 then
        set_mario_action(m, ACT_FREEFALL, 0);
    end

    gPlayerSyncTable[0].FLOAT_TIMER = gPlayerSyncTable[0].FLOAT_TIMER + 1;
    return false;
end

function act_boo_vanish(m)
    --[[
    positionVariable = m.pos
positionVariable.x = positionVariable.x + 25(sins(movementAngle))
positionVariable.z = positionVariable.z + 25(coss(movementAngle))
if (collision_find_floor(positionVariable's x,y,z coordinated) ~= nil) then
  do the raycast
  warp the player
end]]
    set_mario_action(m, ACT_FREEFALL, 0);
end

local function start_walk_on_water(m)
    _G.BooMovesetAPI.gBooFloatOnWater[m.playerIndex] = true
    _G.BooMovesetAPI.gBooFloatedOnWater[m.playerIndex] = true
    if not obj_get_first_with_behavior_id_and_field_s32(id_bhvBooFakeFloor, 0x40, m.playerIndex) then
        local fakeFloor = spawn_non_sync_object(id_bhvBooFakeFloor, E_MODEL_NONE, m.pos.x, m.pos.y, m.pos.z, nil)
        fakeFloor.oBehParams = m.playerIndex
    end
end

local function on_mario_update_water_walk(m) 
    if not _G.BooMovesetAPI.gBooFloatOnWater[m.playerIndex] and not _G.BooMovesetAPI.gBooFloatedOnWater[m.playerIndex] and m.pos.y < m.waterLevel then
        start_walk_on_water(m)
    end

    if m.pos.y <= m.waterLevel and _G.BooMovesetAPI.gBooFloatOnWater[m.playerIndex] and m.controller.buttonPressed & Z_TRIG ~= 0 then
        _G.BooMovesetAPI.gBooFloatOnWater[m.playerIndex] = false
        set_mario_action(m, ACT_FREEFALL, 0)
    end

    if m.floorHeight > m.waterLevel then
        _G.BooMovesetAPI.gBooFloatOnWater[m.playerIndex] = false
        _G.BooMovesetAPI.gBooFloatOnWater[m.playerIndex] = false
    end
end

local function on_mario_update_jump_float(m)
        if m.action & ACT_FLAG_AIR ~= 0 and m.controller.buttonPressed & A_BUTTON ~= 0 and m.vel.y < 0 and gPlayerSyncTable[0].CURRENT_FLOAT_AMOUNT > 0  and BOO_FLOAT_WHITELIST[m.action] then
            gPlayerSyncTable[0].CURRENT_FLOAT_AMOUNT = gPlayerSyncTable[0].CURRENT_FLOAT_AMOUNT - 1;
            gPlayerSyncTable[0].FLOAT_TIMER = 0;
            set_mario_action(m, ACT_BOO_FLOAT, 0)
        end
        if m.pos.y <= m.floorHeight then
            gPlayerSyncTable[0].CURRENT_FLOAT_AMOUNT =  BooMovesetAPI.gBooFloatValuesTable[charSelect.character_get_current_table().model].MAX_FLOATS
        end
end

function on_mario_update(m) 
    _G.BooMovesetAPI.apply_player_boo_flags()
    if _G.BooMovesetAPI.has_boo_flags(m, _G.BooMovesetAPI.gBooMovesetFlags.FLAG_FLOAT_ENABLED) then
        on_mario_update_jump_float(m)
    end
    if _G.BooMovesetAPI.has_boo_flags(m, _G.BooMovesetAPI.gBooMovesetFlags.FLAG_VANISH_ENABLED) then
        if m.controller.buttonPressed & L_TRIG ~= 0 then
            set_mario_action(m, ACT_BOO_VANISH, 0)
        end
    end
    if _G.BooMovesetAPI.has_boo_flags(m, _G.BooMovesetAPI.gBooMovesetFlags.FLAG_WATER_FLOAT_ENABLED) then
        on_mario_update_water_walk(m)
    end
end


hook_event(HOOK_ALLOW_FORCE_WATER_ACTION, function (m, isInWaterAction)
    if isInWaterAction and not _G.BooMovesetAPI.gBooFloatedOnWater[m.playerIndex] and _G.BooMovesetAPI.has_boo_flags(m, _G.BooMovesetAPI.gBooMovesetFlags.FLAG_WATER_FLOAT_ENABLED) then
        start_walk_on_water(m)
        return false
    end
end)

hook_mario_action(ACT_BOO_FLOAT, act_boo_float)
hook_mario_action(ACT_BOO_VANISH, act_boo_vanish)
hook_event(HOOK_MARIO_UPDATE, on_mario_update)