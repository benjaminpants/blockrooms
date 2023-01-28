blockrooms.floors = {}

blockrooms.floors.levels = {}

blockrooms.floors.level_ids = {}

blockrooms.floors.next_valid_y = 0


--the below function adds the room id and stuff to the levels table, and increments next valid y, so that floors that need it can be more then 1 mapchunk high
blockrooms.floors.add_level = function(data)
	
	blockrooms.floors.levels[data.internal_name] = data
	
	--store the order in which they are added for later use, primarily to make sure iterating is consistent.
	table.insert(blockrooms.floors.level_ids,data.internal_name)
end

blockrooms.floors.get_start_floor_y = function(starting_y)
    return 48 + (starting_y - 387) * 80 --why reduce the height? it allows for squeezing as many levels as possible into one world.
end

blockrooms.default_setsky = function(player,color)
	if (color == nil) then
		color = "#050505"
	end
	player:set_sky({base_color = color,type="plain",clouds=false})
	player:set_sun({visible = false})
	player:set_moon({visible = false})
	player:set_stars({visible = false})
end

--assigns all level IDS to valid floors
--TODO: make it so this saves the starting floors starting y in a config file in the world so when new levels are added they don't spawn in completely the wrong spot
minetest.register_on_mods_loaded(function()
	table.sort(blockrooms.floors.level_ids, function(i1,i2)
		return blockrooms.floors.levels[i1].floor_slot < blockrooms.floors.levels[i2].floor_slot
	end)

	for i=1, #blockrooms.floors.level_ids do
		local data = blockrooms.floors.levels[blockrooms.floors.level_ids[i]]
		data.starting_y = blockrooms.floors.next_valid_y
	
		blockrooms.floors.next_valid_y = blockrooms.floors.next_valid_y + data.layers_to_allocate
	end
end)

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

blockrooms.floors.get_player_on_floor = function(floorname)
	local players = minetest.get_connected_players()
	local players_on_floor = {}
	for i=1, #players do
		if (players[i]:get_meta():get_string("floor") == floorname) then
			table.insert(players_on_floor,players[i])
		end
	end
	return players_on_floor
end

minetest.register_globalstep(function(dtime)
	for i=1, #blockrooms.floors.level_ids do
		local data = blockrooms.floors.levels[blockrooms.floors.level_ids[i]]
		if (data.globalstep ~= nil) then
			data.globalstep(dtime) --run the floors globalstep
		end
	end
end)