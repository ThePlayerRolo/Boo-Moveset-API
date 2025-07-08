ACT_BOO_FLOAT = allocate_mario_action(ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION | ACT_FLAG_CONTROL_JUMP_HEIGHT | 
ACT_FLAG_ALLOW_FIRST_PERSON | ACT_FLAG_PAUSE_EXIT)



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





function on_mario_update(m) 
    _G.BooMovesetAPI.apply_player_boo_flags()
    if _G.BooMovesetAPI.has_boo_flags(m, _G.BooMovesetAPI.gBooMovesetFlags.FLAG_FLOAT_ENABLED) then
    if m.action & ACT_FLAG_AIR ~= 0 and m.controller.buttonPressed & A_BUTTON ~= 0 and m.vel.y < 0 and gPlayerSyncTable[0].CURRENT_FLOAT_AMOUNT > 0  and BOO_FLOAT_WHITELIST[m.action] then
        gPlayerSyncTable[0].CURRENT_FLOAT_AMOUNT = gPlayerSyncTable[0].CURRENT_FLOAT_AMOUNT - 1;
        gPlayerSyncTable[0].FLOAT_TIMER = 0;
        set_mario_action(m, ACT_BOO_FLOAT, 0)
    end
    if m.pos.y <= m.floorHeight then
        gPlayerSyncTable[0].CURRENT_FLOAT_AMOUNT =  BooMovesetAPI.gBooFloatValuesTable[charSelect.character_get_current_table().model].MAX_FLOATS
    end


end
end

hook_mario_action(ACT_BOO_FLOAT, act_boo_float)
hook_event(HOOK_MARIO_UPDATE, on_mario_update)
--[[
you could be: inside a wall hitbox, above a ceiling or out-of-bounds
the first thing I could think of is to run perform_air_step() once at the end of the action, then check for AIR_STEP_HIT_WALL (for wall hitbox and ceiling cases) or check if there is a floor below Mario (out-of-bounds)
if it's one of the 3 cases, restore the position that you stored before the action and set the current action to ACT_FREEFALL or something (to prevent bonking or dying)]]