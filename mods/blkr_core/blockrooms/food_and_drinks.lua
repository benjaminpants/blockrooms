local S = minetest.get_translator()

minetest.register_craftitem("blockrooms:moss", {
    description = S("Moss"),
    inventory_image = "blockrooms_moss.png",
	on_use = function(itemstack, player, pointed_thing)
		if (blockrooms.change_player_stat(player,"hunger",4)) then
            blockrooms.change_player_stat(player,"sanity",-7)
			itemstack:take_item(1)
		end
		return itemstack
	end
})


minetest.register_craftitem("blockrooms:chips", {
    description = S("Chips"),
    inventory_image = "blockrooms_chips_bag.png",
	on_use = function(itemstack, player, pointed_thing)
		if (blockrooms.change_player_stat(player,"hunger",6)) then
			itemstack:take_item(1)
		end
		return itemstack
	end
})

minetest.register_craftitem("blockrooms:bandaid", {
    description = S("Bandaid"),
    inventory_image = "blockrooms_bandaid.png",
	on_use = function(itemstack, player, pointed_thing)
		if (blockrooms.change_player_stat(player,"health",3)) then
			itemstack:take_item(1)
		end
		return itemstack
	end
})


minetest.register_craftitem("blockrooms:empty_plastic_bottle", {
    description = S("Plastic Bottle"),
    inventory_image = "blockrooms_bottle_empty.png"
})

blockrooms.liquidsAPI.onLiquidRegistered(function(liquid)
	minetest.register_craftitem("blockrooms:plastic_bottle_" .. liquid.id, {
		description = S("@1\n@2",liquid.display_name,minetest.get_color_escape_sequence("#808080") .. S("Plastic Bottle")),
		inventory_image = "(" .. liquid.request_texture("waterbottle","blockrooms_bottle_filled.png") .. ")^blockrooms_bottle_empty.png",
		on_use = function(itemstack, user, pointed_thing)
			if (liquid.drinkable) then
				if (liquid.on_drink(user,1)) then
					if (itemstack:get_count() == 1) then
						return ItemStack("blockrooms:empty_plastic_bottle")
					else
						itemstack:take_item(1)
						local stack = ItemStack("blockrooms:empty_plastic_bottle")
            			user:get_inventory():add_item("main",stack)
						return itemstack
					end
				end
			end
		end
	})
end)

minetest.register_craftitem("blockrooms:empty_soda_bottle", {
    description = S("Soda Bottle"),
    inventory_image = "blockrooms_sodabottle_empty.png"
})

blockrooms.liquidsAPI.onLiquidRegistered(function(liquid)
	if not (liquid.valid_container_groups["any"] or liquid.valid_container_groups["plastic"]) then
		return
	end
	minetest.register_craftitem("blockrooms:soda_bottle_" .. liquid.id, {
		description = S("@1\n@2",liquid.display_name,minetest.get_color_escape_sequence("#808080") .. S("Soda Bottle")),
		inventory_image = "(" .. liquid.request_texture("waterbottle","blockrooms_bottle_filled.png") .. ")^blockrooms_sodabottle_empty.png",
		on_use = function(itemstack, user, pointed_thing)
			if (liquid.drinkable) then
				if (liquid.on_drink(user,1.8)) then
					if (itemstack:get_count() == 1) then
						return ItemStack("blockrooms:empty_soda_bottle")
					else
						itemstack:take_item(1)
						local stack = ItemStack("blockrooms:empty_soda_bottle")
            			user:get_inventory():add_item("main",stack)
						return itemstack
					end
				end
			end
		end
	})
end)