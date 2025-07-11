local function bhv_boo_fake_floor_init(o)
    cur_obj_scale(2)
    o.collisionData = gGlobalObjectCollisionData.metal_box_seg8_collision_08024C28
    o.oCollisionDistance = 30000
end

local function bhv_boo_fake_floor_loop(o)
    local m = gMarioStates[o.oBehParams]
    o.oPosX = m.pos.x
    o.oPosY = m.waterLevel - 614
    o.oPosZ = m.pos.z
    o.oFaceAnglePitch = 0
    o.oFaceAngleYaw = m.faceAngle.y
    o.oFaceAngleRoll = 0
    m.pos.y = math.max(m.pos.y, m.waterLevel)
    load_object_collision_model()
    if not _G.BooMovesetAPI.gBooFloatOnWater[m.playerIndex] then
        obj_mark_for_deletion(o)
    end
end

id_bhvBooFakeFloor = hook_behavior(nil, OBJ_LIST_SURFACE, true, bhv_boo_fake_floor_init, bhv_boo_fake_floor_loop, "bhvBooFakeFloor")
