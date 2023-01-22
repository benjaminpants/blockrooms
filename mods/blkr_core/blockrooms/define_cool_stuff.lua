minetest.register_privilege("statmanip", {
description = "Allows manipulation of player stats (hunger/thirst/sanity, etc)",
give_to_singleplayer = false,
give_to_admin = true

})



blockrooms.increment_exhaustion = function(player, amount)
	local meta = player:get_meta()
	local exhau = meta:get_int("exhaustion")
	if ((exhau + amount) <= blockrooms.exhaustion_max) then
		meta:set_int("exhaustion",exhau + amount)
	else
		meta:set_int("exhaustion",0)
		blockrooms.change_player_stat(player,"hunger",math.ceil((((exhau + amount) - 100) * -1) / 2) - 1)
	end


end




blockrooms.change_player_stat = function(player,stat,val,reason) --the return value for this is whether or not it was able to actually use it
	if (stat == "health") then
		local hp_pre_change = player:get_hp()
		player:set_hp(player:get_hp() + val, reason)
		return hp_pre_change ~= player:get_hp()
	end
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
	if (value + val <= 0 and val ~= 0) then
		return false
	end
	meta:set_int(stat,value + increase)
	hb.change_hudbar(player, "br_" .. stat, meta:get_int(stat))
    return true
end

blockrooms.floors.get_floor_y_from_data = function(data,include_offset)
	local cur = blockrooms.floors.get_start_floor_y(data.starting_y)
	local off = 0
	if (include_offset) then
		off = (data.spawn_offset or 1)
	end
	return cur + off
end

blockrooms.floors.get_floor_y = function(floor_id,include_offset)
	return blockrooms.floors.get_floor_y_from_data(blockrooms.floors.levels[floor_id],include_offset)
end

blockrooms.floors.teleport_player_to_floor = function(player, floor)
	local meta = player:get_meta()
	local data = blockrooms.floors.levels[floor]
	if (data == nil) then return false end
	meta:set_string("floor",floor) --only send the player there if the data actually exists

	--call the teleport function for the specific floor if it exists
	if (data.on_player_spawn ~= nil) then
		data.on_player_spawn(player)
	else
		player:set_pos(vector.new(math.random(-8000,8000),blockrooms.floors.get_floor_y_from_data(data,true),math.random(-8000,8000)))
	end

	return true

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
	meta:set_int("exhaustion",0)
end)

minetest.register_on_joinplayer(function(player)
	local meta = player:get_meta()
	hb.init_hudbar(player, "br_hunger", meta:get_int("hunger"), blockrooms.hunger_max, false)
	hb.init_hudbar(player, "br_thirst", meta:get_int("thirst"), blockrooms.thirst_max, false)
	hb.init_hudbar(player, "br_sanity", meta:get_int("sanity"), blockrooms.sanity_max, false)
	player:hud_set_flags({minimap = false}) --the minimap literally doesnt work
	blockrooms.default_setsky(player)
	player:hud_set_hotbar_itemcount(8)
end)

minetest.register_on_dieplayer(function(player)
	local meta = player:get_meta()
	meta:set_int("thirst",blockrooms.thirst_max)
	meta:set_int("hunger",blockrooms.hunger_max)
	meta:set_int("sanity",blockrooms.sanity_max)
	meta:set_int("exhaustion",0)
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
	meta:set_int("thirst",blockrooms.thirst_max)
	meta:set_int("hunger",blockrooms.hunger_max)
	meta:set_int("sanity",blockrooms.sanity_max)
	meta:set_int("exhaustion",0)
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

minetest.register_chatcommand("refill_all", {
	params = "",
	description = "Refill the stats of the player.",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Player not found"
		end

		if (not minetest.check_player_privs(name, {statmanip = true})) then
			return false, "Missing privileges!"
		end
		local meta = player:get_meta()
		meta:set_int("thirst",blockrooms.thirst_max)
		meta:set_int("hunger",blockrooms.hunger_max)
		meta:set_int("sanity",blockrooms.sanity_max)
		meta:set_int("exhaustion",0)

		hb.change_hudbar(player, "br_hunger", blockrooms.hunger_max)
		hb.change_hudbar(player, "br_thirst", blockrooms.thirst_max)
		hb.change_hudbar(player, "br_sanity", blockrooms.sanity_max)
		
		return true, "Stats refilled."
	end,
})

minetest.register_chatcommand("teleport_to_floor", {
	params = "floor_id",
	description = "Teleport the player to a specific floor",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Player not found"
		end

		if (not minetest.check_player_privs(name, {teleport = true})) then
			return false, "Missing privileges!"
		end
		blockrooms.floors.teleport_player_to_floor(player,param)
		
		return true, "Teleported to floor!"
	end,
})