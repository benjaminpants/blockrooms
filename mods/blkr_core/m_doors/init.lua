local S = minetest.get_translator()

--i'll end up rewriting this entire thing AGAIN later

doors = {}

doors.boxes = {}
doors.boxes.OneByTwo = {}
doors.boxes.OneByTwo.size = vector.new(1,2,0) --Z is ignored
doors.boxes.OneByTwo.closed = {type="fixed",fixed={-0.5, -0.5, -0.1, 0.5, 1.5, 0.1}}
doors.boxes.OneByTwo.opened = {type="fixed",fixed={-0.5, -0.5, -0.06, -0.365, 1.5, 0.95}}

doors.example_door_data = {
    id = "m_doors:test_door",
    name = S("Example Door"),
    texture = "m_doors_template.png",
    wield_image = "m_doors_template_item.png",
    model = "door_knob",
    sounds = {},--blockrooms.node_sound_base_custom_place({},"wood"),
    groups = {},
    boxes = doors.boxes.OneByTwo,
    max_hear_distance = 8,
    open_sound = {name="wooden_door_open"},
    close_sound = {name="wooden_door_close"},
    knock_sound = {name="wooden_door_knock"},
    on_state_change = nil, --function(doordata,current_state,pos, node, clicker, itemstack, pointed_thing) --if the door is closed, current_state will be CLOSED, not OPEN
    post_node_data = nil --function(state,data)
}

--[[doors.example_door_data_again = {
    id = "m_doors:test_door_handle",
    name = S("Example Door With Handle"),
    texture = "m_doors_handle_template.png",
    wield_image = "m_doors_template_item.png",
    model = "door_handle",
    sounds = {},--blockrooms.node_sound_base_custom_place({},"wood"),
    groups = {},
    boxes = doors.boxes.OneByTwo,
    max_hear_distance = 8,
    open_sound = {name="wooden_door_open"},
    close_sound = {name="wooden_door_close"},
    knock_sound = {name="wooden_door_knock"}
}--]]


doors.default_open_behavior = function(doordata,pos)
    local n = minetest.get_node(pos)
    minetest.swap_node(pos, {name=doordata.id .. "_opened", param2=n.param2})
    minetest.sound_play(doordata.open_sound, {
        pos = pos,
        gain = 1.0,
        max_hear_distance = doordata.max_hear_distance
    }, true)
end

doors.default_close_behavior = function(doordata,pos)
    local n = minetest.get_node(pos)
    minetest.swap_node(pos, {name=doordata.id, param2=n.param2})
    minetest.sound_play(doordata.close_sound, {
        pos = pos,
        gain = 1.0,
        max_hear_distance = doordata.max_hear_distance
    }, true)
end

doors.default_knock_behavior = function(doordata,pos)
    minetest.sound_play(doordata.knock_sound, {
        pos = pos,
        gain = 1.0,
        max_hear_distance = doordata.max_hear_distance,
        pitch = 1 + (math.random(-3,3) * 0.02)
    }, true)
    return nil
end

doors.create_door = function(doordata)
    local closed_id = doordata.id
    local opened_id = doordata.id .. "_opened"

    local closed_data = {
        description = doordata.name,
        tiles = {doordata.texture},
        drawtype = "mesh",
        paramtype = "light",
        paramtype2 = "facedir",
        wield_image = doordata.wield_image,
        inventory_image = doordata.wield_image,
        buildable_to = false,
        mesh = doordata.model .. "_closed.obj",
        groups = doordata.groups,
        selection_box = doordata.boxes.closed,
        collision_box = doordata.boxes.closed,
        sounds = doordata.sounds,
        on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
            if (doordata.on_state_change ~= nil) then
                return doordata.on_state_change(doordata,"closed",pos, node, clicker, itemstack, pointed_thing)
            end
            return doors.default_open_behavior(doordata,pos)
        end,
        on_punch = function(pos)
            return doors.default_knock_behavior(doordata,pos)
        end
    }

    if (doordata.post_node_data ~= nil) then
        doordata.post_node_data("closed",closed_data)
    end

    minetest.register_node(closed_id, closed_data)
    
    local groupcopy = table.copy(doordata.groups)
    groupcopy.not_in_creative_inventory = 1

    local opened_data = {
        description = doordata.name .. " (Open)",
        tiles = {doordata.texture},
        drawtype = "mesh",
        paramtype = "light",
        paramtype2 = "facedir",
        buildable_to = false,
        mesh = doordata.model .. "_opened.obj",
        groups = groupcopy,
        selection_box = doordata.boxes.opened,
        collision_box = doordata.boxes.opened,
        sounds = doordata.sounds,
        drop = closed_id,
        on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
            if (doordata.on_state_change ~= nil) then
                return doordata.on_state_change(doordata,"opened",pos, node, clicker, itemstack, pointed_thing)
            end
            return doors.default_close_behavior(doordata,pos)
        end
    }

    if (doordata.post_node_data ~= nil) then
        doordata.post_node_data("opened",opened_data)
    end

    minetest.register_node(opened_id, opened_data)

end

doors.create_door(doors.example_door_data)

--doors.create_door(doors.example_door_data_again)