local S = minetest.get_translator()

local office_door_data = {
    id = "blockrooms:office_door",
    name = S("Office Door"),
    texture = "blockrooms_office_door.png",
    wield_image = "m_doors_template_item.png",
    model = "door_knob", --TODO: implement office door model
    sounds = blockrooms.node_sound_base({},"tin"),
    groups = {},
    boxes = doors.boxes.OneByTwo,
    max_hear_distance = 9,
    open_sound = {name="wooden_door_open"},
    close_sound = {name="wooden_door_close"},
    knock_sound = {name="door_wood_knock"}
}


doors.create_door(office_door_data)