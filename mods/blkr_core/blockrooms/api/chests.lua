local S = minetest.get_translator()

blockrooms.storage = {}

blockrooms.storage.example_storage = {
    node_id = "blockrooms:chest_test2",
    node_definition = {
        description = S("Chest Test2"),
        tiles = {"blockrooms_fan_metal.png"},
        groups = {cracky=3},
        sounds = blockrooms.node_sound_base_custom_place({},"wood"),
    },
    storage_size = {4,1},
    gui_pos_offset = {2,2}
}


blockrooms.storage.create_storage = function(storage_data)
    local data = table.copy(storage_data)
    local off_x = data.gui_pos_offset[1]
    local off_y = data.gui_pos_offset[2]
    local size_x = data.storage_size[1]
    local size_y = data.storage_size[2]
    local inventor = {
        main = {}
    }
    for i=1, (size_x*size_y) do
        inventor.main[i] = ""
    end
    data.node_definition.on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec",
                "size[8,9]"..
                "list[context;main;0,0;" .. size_y .. "," .. size_x .. ";]"..
                "list[current_player;main;0,5;8,4;]")
        local inv = meta:get_inventory()
        inv:set_size("main", size_x*size_y)
        meta:from_table({
            inventory = inventor,
            fields = {
                formspec = "size[8,9]list[context;main;" .. off_x .. "," .. off_y .. ";" .. size_x .. "," .. size_y .. ";]list[current_player;main;0,5;8,4;]"
            }
        })
    end
    minetest.register_node(data.node_id,data.node_definition)
end

blockrooms.storage.create_storage({
    node_id = "blockrooms:crate",
    node_definition = {
        description = S("Crate"),
        tiles = {"blockrooms_crate.png"},
        mesh = "crate.obj",
        drawtype = "mesh",
        groups = {choppy=2},
        sounds = blockrooms.node_sound_base_custom_place({},"wood"),
    },
    storage_size = {4,1},
    gui_pos_offset = {2,2}
})