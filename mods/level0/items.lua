local S = minetest.get_translator()

minetest.register_craftitem("level0:moss_cluster", {
    description = S("Moss Cluster"),
    inventory_image = "level0_moss_cluster.png",
	on_place = function(itemstack, placer, pointed_thing)
        local node = minetest.get_node(pointed_thing.under)
        if (not minetest.is_player(placer)) then return end
        if (minetest.is_protected(pos, placer)) then
            return
        end
        if (minetest.registered_nodes[node.name].groups["can_have_moss_cluster"] ~= nil) then
            minetest.set_node(pointed_thing.under,{name = node.name .. "_moss_cluster"})
            itemstack:take_item(1)
            return itemstack
        end
    end
})

minetest.register_craftitem("level0:moss_bit", {
    description = S("Moss Bit"),
    inventory_image = "level0_moss_bit.png",
	on_use = function(itemstack, player, pointed_thing)
		if (blockrooms.change_player_stat(player,"hunger",2)) then
            blockrooms.change_player_stat(player,"sanity",-5)
			itemstack:take_item(1)
		end
		return itemstack
	end
})
