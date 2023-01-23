local S = minetest.get_translator()

minetest.register_tool("blockrooms:sharp_glass_shard", {
	description = S("Sharpened Glass Shard"),
	inventory_image = "blockrooms_glass_shard_sharp.png",
	tool_capabilities = {
		full_punch_interval = 0.2,
		max_drop_level=0,
		groupcaps={
			papery={times={[1]=1.5, [2]=3, [3]=4, [4]=5}, uses=1, maxlevel=1}
		},
		damage_groups = {fleshy=1},
	},
	after_use = function(itemstack, user, node, digparams)
		if (user == nil) then
			itemstack:add_wear(digparams.wear)
        	return itemstack
		end
		if (math.random(1,4) == 1) then
			if (user:is_player()) then
				blockrooms.change_player_stat(user,"health",-3,"blood_loss")
			end
		end
		itemstack:add_wear(digparams.wear)
        return itemstack
	end,
})

colors.foreach(function(color)
	minetest.register_tool("blockrooms:sharp_glass_shard_" .. color.id, {
		description = S("@1 Taped Glass Shard", color.name),
		inventory_image = "blockrooms_glass_shard_sharp.png^(blockrooms_shard_tape.png^[multiply:#" .. color.rgb .. ")",
		tool_capabilities = {
			full_punch_interval = 0.2,
			max_drop_level=0,
			groupcaps={
				papery={times={[1]=1.5, [2]=3, [3]=4, [4]=5}, uses=2, maxlevel=1}
			},
			damage_groups = {fleshy=1},
		},
	})
	minetest.register_craft({
		output = "blockrooms:sharp_glass_shard_" .. color.id .. " 1",
		type = "shapeless",
		recipe = {
			"blockrooms:sharp_glass_shard",
			"tape:tape_" .. color.id
		}
	})

   --[[ minetest.register_node("blockrooms:concrete_" .. color.id, {
        description = S("@1 Painted Concrete",color.name),
        tiles = {"blockrooms_concrete_colorable.png^[multiply:#" .. color.rgb},
        groups = minetest.registered_nodes["blockrooms:concrete"].groups,
        sounds = minetest.registered_nodes["blockrooms:concrete"].sounds
    })]]
end)

--you only need a single glass shard. for now. 
--TODO: make it so punching with a glass shard creates a sharp glass shard
minetest.register_craft({
	output = "blockrooms:sharp_glass_shard 1",
	type = "shapeless",
	recipe = {
		"blockrooms:glass_shard"
	}
})