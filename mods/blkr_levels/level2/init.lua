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