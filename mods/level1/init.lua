minetest.register_node("level1:ceiling", {
    description = "Unbreakable",
    tiles = {{name="level1_ceiling.png", align_style='world', scale=2}},
    inventory_image = "[inventorycube{level1_ceiling.png{level1_ceiling.png{level1_ceiling.png",
    sounds = blockrooms.node_sound_base({},"tin")
})