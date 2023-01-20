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
