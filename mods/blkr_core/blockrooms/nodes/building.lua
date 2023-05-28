local S = minetest.get_translator()

minetest.register_node("blockrooms:bricks", {
    description = S("Bricks"),
    tiles = {"blockrooms_bricks.png"},
    groups = {cracky=3},
    sounds = blockrooms.node_sound_base_custom_place({},"wood") --placeholder
})

minetest.register_node("blockrooms:bricks_prison", {
    description = S("Orange Bricks"),
    tiles = {"blockrooms_bricks_prison.png"},
    groups = {cracky=3},
    sounds = blockrooms.node_sound_base_custom_place({},"wood") --placeholder
})