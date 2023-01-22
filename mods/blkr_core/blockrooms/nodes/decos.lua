local S = minetest.get_translator()

local office_door_data = {
    id = "blockrooms:office_door",
    name = S("Office Door"),
    texture = "blockrooms_office_door.png",
    wield_image = "blockrooms_office_door_item.png",
    model = "door_handle",
    sounds = blockrooms.node_sound_base({},"tin"),
    groups = {},
    boxes = doors.boxes.OneByTwo,
    max_hear_distance = 9,
    open_sound = {name="office_door_open"},
    close_sound = {name="office_door_close"},
    knock_sound = {name="office_door_knock"}
}


doors.create_door(office_door_data)