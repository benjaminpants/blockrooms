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
--TODO: make it so this saves to a config file in the world so when new levels are added they don't completely die
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