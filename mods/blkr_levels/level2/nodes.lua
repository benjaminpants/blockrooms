local S = minetest.get_translator()

minetest.register_node("level2:concrete_gritty", {
    description = S("Concrete (Gritty)"),
    tiles = {{name="level2_concrete_dirty.png", align_style="world", scale=4}},
    --drop = "blockrooms:concrete",
    groups = minetest.registered_nodes["blockrooms:concrete"].groups,
    sounds = minetest.registered_nodes["blockrooms:concrete"].sounds
})

minetest.register_node("level2:concrete_gritty_extreme", {
    description = S("Concrete (Extremely Gritty)"),
    tiles = {{name="level2_concrete_extreme_dirty.png", align_style="world", scale=4}},
    --drop = "blockrooms:concrete",
    groups = minetest.registered_nodes["blockrooms:concrete"].groups,
    sounds = minetest.registered_nodes["blockrooms:concrete"].sounds
})

minetest.register_node("level2:concrete_darkb", {
    description = S("Dark Blue Concrete"),
    tiles = {"blockrooms_concrete.png^[multiply:#272B3C"}, --this using the regular concrete texture instead of the colorable one is an intentional decision, not a mistake.
    groups = minetest.registered_nodes["blockrooms:concrete"].groups,
    sounds = minetest.registered_nodes["blockrooms:concrete"].sounds
})

local office_door_data = {
    id = "level2:office_door_dirty",
    name = S("Dirty Office Door"),
    texture = "level2_office_door_dirty.png",
    wield_image = "level2_office_door_dirty_item.png",
    model = "door_handle",
    sounds = blockrooms.node_sound_base({},"tin"),
    groups = {},
    boxes = doors.boxes.OneByTwo,
    max_hear_distance = 11, --its louder cuz creakyness or smth
    open_sound = {name="office_door_open"},
    close_sound = {name="office_door_close"},
    knock_sound = {name="office_door_knock"}
}

local permaShutBox = table.copy(doors.boxes.OneByTwo)

permaShutBox.opened = permaShutBox.closed

local office_door_data_warp = {
    id = "level2:office_door_dirty_warp",
    name = S("(WARP) Dirty Office Door"),
    texture = "level2_office_door_dirty.png",
    wield_image = "level2_office_door_dirty_item.png^blockrooms_dev_marker_special.png",
    model = "door_handle",
    sounds = blockrooms.node_sound_base({},"tin"),
    groups = {},
    drop = "level2:office_door_dirty 1",
    boxes = permaShutBox,
    max_hear_distance = 11, --its louder cuz creakyness or smth
    open_sound = {name="office_door_open"},
    close_sound = {name="office_door_close"},
    knock_sound = {name="office_door_knock"},
    --TODO: update to use nodetimer
    on_state_change = function(doordata, current_state,pos, node, clicker, itemstack, pointed_thing) --if the door is closed, current_state will be closed, not opened
        if (not clicker:is_player()) then return end
        if (current_state == "closed") then
            local meta = minetest.get_meta(pos)
            local levelt = blockrooms.floors.levels["level_2"]
            if (meta:get_int("locked") == 0) then
                local level = meta:get_string("level")
                if (level == "") then
                    level = randomUtils.weightedRandom(levelt.validLevelWarps)
                    meta:set_string("level", level)
                end
                doors.default_open_behavior(doordata,pos)
                minetest.after(1, function(doordata, pos, clicker, level)
                    local n = minetest.get_node(pos)
                    if (n.name == "level2:office_door_dirty_warp") then return end
                    if (clicker:get_hp() == nil) then 
                        doors.default_close_behavior(doordata,pos)
                        return 
                    end --clicker no longer exists, since get_hp only returns NIL if the entity has left
                    blockrooms.floors.teleport_player_to_floor(clicker, level)
                end, doordata, pos, clicker, level)
            end
        else
            doors.default_close_behavior(doordata,pos) --allow it to be closed incase it gets stuck open
        end
    end
}


doors.create_door(office_door_data)

doors.create_door(office_door_data_warp)