local S = minetest.get_translator()

minetest.register_node("level1:ceiling", {
    description = "Unbreakable",
    tiles = {{name="level1_ceiling.png", align_style='world', scale=2}},
    inventory_image = "[inventorycube{level1_ceiling.png{level1_ceiling.png{level1_ceiling.png",
    sounds = blockrooms.node_sound_base({},"tin")
})


minetest.register_node("level1:orange_tape_sl", {
    description = S("Orange Tape Side Left"),
    drawtype = "signlike",
    paramtype = "light",
    paramtype2 = "wallmounted",
    selection_box = {
        type = "wallmounted",
        wall_top    = {-0.5, 0.4375, -0.5, 0.5, 0.5, 0.5},
        wall_bottom = {-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
        wall_side   = {-0.5, -0.5, -0.5, -0.4375, 0.5, 0.5},
    },
    drop = "tape:tape_org 1",
    walkable = false,
    sunlight_propagates = true,
    tiles = {"level1_tape_side_l.png^[multiply:#FF8000"},
    is_ground_content = false,
    groups = {near_instant=1}
    --sounds = backrooms.node_sound_defaults()
})

minetest.register_node("level1:orange_tape_sr", {
    description = S("Orange Tape Side Right"),
    drawtype = "signlike",
    paramtype = "light",
    paramtype2 = "wallmounted",
    selection_box = {
        type = "wallmounted",
        wall_top    = {-0.5, 0.4375, -0.5, 0.5, 0.5, 0.5},
        wall_bottom = {-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
        wall_side   = {-0.5, -0.5, -0.5, -0.4375, 0.5, 0.5},
    },
    drop = "tape:tape_org 1",
    walkable = false,
    sunlight_propagates = true,
    tiles = {"level1_tape_side_r.png^[multiply:#FF8000"},
    is_ground_content = false,
    groups = {near_instant=1}
    --sounds = backrooms.node_sound_defaults()
})