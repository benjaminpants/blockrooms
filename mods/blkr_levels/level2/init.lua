local S = minetest.get_translator()

minetest.register_node("level2:concrete_gritty", {
    description = S("Concrete (Gritty)"),
    tiles = {{name="level2_concrete_dirty.png", align_style="world", scale=4}},
    --drop = "blockrooms:concrete",
    groups = minetest.registered_nodes["blockrooms:concrete"].groups,
    sounds = minetest.registered_nodes["blockrooms:concrete"].sounds
})