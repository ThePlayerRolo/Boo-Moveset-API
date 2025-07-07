ACT_BOO_FLOAT = allocate_mario_action(ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION | ACT_FLAG_CONTROL_JUMP_HEIGHT | 
ACT_FLAG_ALLOW_FIRST_PERSON | ACT_FLAG_PAUSE_EXIT)

local FLOAT_AMOUT_CONSTANT = 5
gPlayerSyncTable[0].CURRENT_FLOAT_AMOUNT = FLOAT_AMOUT_CONSTANT;
gPlayerSyncTable[0].FLOAT_TIMER = 5;

function act_boo_float(m)
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




function before_update(m)
    if _G.BooMovesetAPI.has_boo_flags(m, _G.BooMovesetAPI.gBooMovesetFlags.FLAG_EDIT_IDLE) then
        if (m.action == ACT_IDLE) then
            m.actionTimer = m.actionTimer + 1
            if (m.actionTimer > 900) then
                m.actionState = 3
            else
                m.actionState = 0
            end
        end
    end
end

function on_mario_update(m) 
    _G.BooMovesetAPI.apply_player_boo_flags()
    if _G.BooMovesetAPI.has_boo_flags(m, _G.BooMovesetAPI.gBooMovesetFlags.FLAG_FLOAT_ENABLED) then
    if m.action & ACT_FLAG_AIR ~= 0 and m.controller.buttonPressed & A_BUTTON ~= 0 and m.vel.y < 0 and gPlayerSyncTable[0].CURRENT_FLOAT_AMOUNT > 0 then
        gPlayerSyncTable[0].CURRENT_FLOAT_AMOUNT = gPlayerSyncTable[0].CURRENT_FLOAT_AMOUNT - 1;
        gPlayerSyncTable[0].FLOAT_TIMER = 0;
        set_mario_action(m, ACT_BOO_FLOAT, 0)
    end
    if m.pos.y <= m.floorHeight then
        gPlayerSyncTable[0].CURRENT_FLOAT_AMOUNT = FLOAT_AMOUT_CONSTANT
    end
end

end

hook_mario_action(ACT_BOO_FLOAT, act_boo_float)
hook_event(HOOK_MARIO_UPDATE, on_mario_update)
hook_event(HOOK_BEFORE_MARIO_UPDATE, before_update)
