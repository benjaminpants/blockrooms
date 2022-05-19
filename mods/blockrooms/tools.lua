local S = minetest.get_translator()

minetest.register_tool("blockrooms:sharp_glass_shard", {
	description = S("Sharpened Glass Shard"),
	inventory_image = "blockrooms_glass_shard_sharp.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level=0,
		groupcaps={
			papery={times={[1]=1.5, [2]=3, [3]=4, [4]=5}, uses=6, maxlevel=1}
		},
		damage_groups = {fleshy=2},
	},
})

minetest.register_craft({
	output = "blockrooms:sharp_glass_shard 1",
	type = "shapeless",
	recipe = {
		"blockrooms:glass_shard","blockrooms:glass_shard"
	}
})