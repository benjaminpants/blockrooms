local S = minetest.get_translator()

minetest.register_node("blockrooms:floodlight", {
	description = S("Floodlight"),
	tiles = { "blockrooms_floodlight.png", "blockrooms_floodlight_back.png", "blockrooms_floodlight_side.png", "blockrooms_floodlight_side.png", "blockrooms_floodlight_topbot.png", "blockrooms_floodlight_topbot.png" },
	drawtype = "nodebox",
	is_ground_content = false,
	sunlight_propagates = true,
    paramtype = "light",
    light_source = 14,
    paramtype2 = "wallmounted",
	node_box = {
        type = "fixed",
        fixed = {
            {-0.1250, -0.5000, -0.5000, 0.1250, -0.3750, 0.5000}
        }
    },
    inventory_image = "blockrooms_floodlight_item.png",
    sounds = blockrooms.node_sound_base_shatter({},"glass"),
	groups = { hand_breakable = 7},
})

--compat
minetest.register_alias("level1:floodlight", "blockrooms:floodlight")