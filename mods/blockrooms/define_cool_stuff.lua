blockrooms.change_player_stat = function(player,stat,val) --the return value for this is whether or not it was able to actually use it
	local isneg = val < 0
	local meta = player:get_meta()
	local value = meta:get_int(stat)
	local increase = val
	if (not isneg) then
	local statmax = 100
	if (stat == "hunger") then
		statmax = blockrooms.hunger_max
	elseif (stat == "thirst") then
		statmax = blockrooms.thirst_max
	elseif (stat == "sanity") then
		statmax = blockrooms.sanity_max
	end
	if (value + val >= statmax) then 
		increase = statmax - value
	end
	else
		if (value + val < 0) then
			increase = -value
		end
	end
	if (increase <= 0 and not isneg) then return false end
	meta:set_int(stat,value + increase)
	hb.change_hudbar(player, "br_" .. stat, meta:get_int(stat))
    return true
end

blockrooms.floors.teleport_player_to_floor = function(player, floor)
	local meta = player:get_meta()
	meta:set_string("floor",floor)
	local data = blockrooms.floors.levels[floor]
	if (data == nil) then return end
	--call the teleport function for the specific floor if it exists
	if (data.on_player_spawn ~= nil) then
		data.on_player_spawn(player)
	else
		player:set_pos(vector.new(math.random(-8000,8000),blockrooms.floors.get_start_floor_y(data.starting_y) + (data.spawn_offset or 1),math.random(-8000,8000)))
	end

end


minetest.register_on_newplayer(function(player)
	local meta = player:get_meta()
	if (blockrooms.default_floor == "unknown") then
		error("Default floor is unset. Make sure that all files are in the right place.")
	end
	blockrooms.floors.teleport_player_to_floor(player,blockrooms.default_floor)
	meta:set_int("thirst",blockrooms.thirst_max)
	meta:set_int("hunger",blockrooms.hunger_max)
	meta:set_int("sanity",blockrooms.sanity_max)
end)

minetest.register_on_joinplayer(function(player)
	local meta = player:get_meta()
	hb.init_hudbar(player, "br_hunger", meta:get_int("hunger"), blockrooms.hunger_max, false)
	hb.init_hudbar(player, "br_thirst", meta:get_int("thirst"), blockrooms.thirst_max, false)
	hb.init_hudbar(player, "br_sanity", meta:get_int("sanity"), blockrooms.sanity_max, false)
	player:hud_set_flags({minimap = false}) --the minimap literally doesnt work
	player:hud_set_hotbar_itemcount(5)
	local inv = player:get_inventory()
	inv:set_size("armor", 3*4)
end)

minetest.register_on_dieplayer(function(player)
	local meta = player:get_meta()
	meta:set_int("thirst",blockrooms.thirst_max)
	meta:set_int("hunger",blockrooms.hunger_max)
	meta:set_int("sanity",blockrooms.sanity_max)
	--get the floor and handle the ondeath event
	local floor = blockrooms.floors.levels[meta:get_string("floor")]
	if (floor == nil) then
		--do nothing
	else
		if (floor.on_player_death ~= nil) then
			if (not floor.on_player_death(player)) then
				return
			end
		end
	end
	--minetest.chat_send_all(player:get_player_name() .. " died.")
end)


minetest.register_on_respawnplayer(function(player)
	local meta = player:get_meta()
	blockrooms.floors.teleport_player_to_floor(player,meta:get_string("floor"))
	return true
end)

blockrooms.use_item_plus_output = function(output, itemstack, player) --i would use this for the tape but like dependencies break it soo
	local inv = player:get_inventory()
	if (minetest.check_player_privs(player, {creative=true})) then
		return itemstack
	end
	if (itemstack:get_count() == 1 and not inv:contains_item("main", ItemStack(output))) then --if there is only one roll and aren't any other already existing rolls
		return ItemStack(output)
	else
		itemstack:take_item()
		inv:add_item("main",ItemStack(output))
		return itemstack
	end

end