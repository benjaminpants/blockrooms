local S = minetest.get_translator()

local G = minetest.get_content_id --to shorten code for the sake of my sanity.

local c_unbreakable = G("blockrooms:unbreakable")

local c_carpet = G("level0:carpet")

local c_carpet_wet = G("level0:carpet_wet")

local c_ceiling = G("level0:ceiling_tile")

local c_light = G("level0:light")

local c_air = G("air")

local c_unbreakable = G("blockrooms:unbreakable")

local weighted_wall_types = {{{"level0:arrow_wallpaper","level0:trim_arrow_wallpaper"},2500}, {{"level0:dots_wallpaper","level0:trim_dots_wallpaper"},100}, {{"level0:stripes_wallpaper","level0:trim_stripes_wallpaper"},200}}


local generic_wall_data = {
	main_block = c_wall_arrow,
	trim_block = c_wall_arrow_trim,
	randomly_carve = true,


}

local function GenerateRandomWallData(rng_carve)
	local data = {}
	data.randomly_carve = rng_carve
	local wall_types = blockrooms.rng_utils.choosechance(weighted_wall_types)
	data.main_block = wall_types[1]
	data.trim_block = wall_types[2]

	if (math.random(1,12) ~= 1) then
		data.trim_block = nil
	end

	return data
end



local function GenerateWall(startx, direction, seed, area, data, width,maxp, wall_data)
	local move_x = 0
	local move_z = 0
	local height = 4
	local moss_chance = 5
	if (blockrooms.rng_utils.percentage(2)) then --chance for a wall to be double mossy
		moss_chance = 10
	end
	if (blockrooms.rng_utils.percentage(1)) then
		height = 3 --those weird lower hanging walls are rare but do happen.
	end
	if (direction == "x") then
		move_x = 1
	else
		move_z = 1
	end
	local append = ""
	for j=0, width do
		if (blockrooms.rng_utils.percentage(71)) or (not wall_data.randomly_carve) then
			local offset = (j * 2)
			local offset_2 = ((j * 2) + 1)
			if (wall_data.trim_block ~= nil and j ~= width) then --before anyone asks, i made this just so it matches the original image where the trim ends before the wall completly ends
				for i in area:iter( startx.x + (offset * move_x), startx.y + 1, startx.z + (offset * move_z), startx.x + (offset_2 * move_x), startx.y + (height - 1), startx.z + (offset_2 * move_z) ) do 
					if (blockrooms.rng_utils.percentage(moss_chance)) then
						append = "_moss"
					else
						append = ""
					end
					data[i] = G(wall_data.main_block .. append)
				end
				for i in area:iter( startx.x + (offset * move_x), startx.y, startx.z + (offset * move_z), startx.x + (offset_2 * move_x), startx.y, startx.z + (offset_2 * move_z) ) do 
					data[i] = G(wall_data.trim_block)
				end
			else
				for i in area:iter( startx.x + (offset * move_x), startx.y, startx.z + (offset * move_z), startx.x + (offset_2 * move_x), startx.y + (height - 1), startx.z + (offset_2 * move_z) ) do 
					if (blockrooms.rng_utils.percentage(moss_chance)) then
						append = "_moss"
					else
						append = ""
					end
					data[i] = G(wall_data.main_block .. append)
				end
			end
		end
	end

    return data
end

local function GenerateRoom(startx, seed, area, data, maxp)
	if (blockrooms.rng_utils.percentage(99)) then
    	GenerateWall(startx, "x", seed, area, data, 4, maxp, GenerateRandomWallData(true))
	end
	if (blockrooms.rng_utils.percentage(99)) then
		GenerateWall(startx, "z", seed, area, data, 4, maxp, GenerateRandomWallData(true))
	end

	if (blockrooms.rng_utils.percentage(99)) then
		data[area:index(startx.x + 4, startx.y + 4, startx.z + 4)] = c_light
		data[area:index(startx.x + 5, startx.y + 4, startx.z + 4)] = c_light
	end

    return data
end



local main_generate_function = function(minp, maxp, seed, layer)
    local vm, emin, emax = minetest.get_mapgen_object("voxelmanip") 
	local data = vm:get_data() 
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}

	math.randomseed(seed)

	
	for j=0, 8 do
		for	i=0, 8 do
			GenerateRoom(vector.new(minp.x + (i * 9), minp.y + 2, minp.z + (j * 9)), seed, area, data)
		end
	end

	for i in area:iter( minp.x, minp.y, minp.z, maxp.x, minp.y, maxp.z) do 
		data[i] = c_unbreakable
	end

	for i in area:iter( minp.x, minp.y + 1, minp.z, maxp.x, minp.y + 1, maxp.z) do
		if (blockrooms.rng_utils.percentage(3)) then
			data[i] = c_carpet_wet
		else
			data[i] = c_carpet
		end
	end

	for i in area:iter( minp.x, minp.y + 6, minp.z, maxp.x, minp.y + 6, maxp.z) do
		if (data[i] == c_air) then
			data[i] = c_ceiling
		end
	end
	for i in area:iter( minp.x, minp.y + 7, minp.z, maxp.x, minp.y + 7, maxp.z) do 
		data[i] = c_unbreakable
	end

	
    vm:set_data(data)

	vm:set_lighting{day=0, night=0} 
	
	vm:calc_lighting() 

	vm:write_to_map() 

end



blockrooms.floors.add_level({
	internal_name = "level_0", 
	display_name = S("Level @1", "0"), --The external name, you can localize it if you want or just leave it.
	short_name = "0", --this should typically be the number, for instance if its Floor 0 this should be "0". Floor FUN would be "FUN" and whatnot.
	floor_slot = 0, --used for sorting.
	generator = main_generate_function, --a generator function, the function is basically just a hook for register_on_generated, but only called on certain conditions
	level_type = "normal", --the type of the floor, supports "normal", "enigmatic", and "sublevel" at the moment. set a floor as enigmatic if it should be ignored by stuff like the hub.
	--sublevel doesn't do anything at the moment, but will probably be used for sorting in the future.
	spawn_offset = 2,
	layers_to_allocate = 1 --how many "layers" should be allocated? layers in this case mean how many mapchunks tall should this floor be?
	--on_player_death = function(player) --a function that is called when a player dies on this floor, return true to do the default death handling, false to prevent it
	--on_player_spawn = function(player,previous_floor) --previous_floor is the internal name of the previous floor the player was on before being sent to this one, if left blank the default spawn code will be used.
})

blockrooms.default_floor = "level_0" 