
local c_replaceable = minetest.get_content_id("blockrooms:replaceme")
local c_replaceablea = minetest.get_content_id("blockrooms:replaceme_2")
local c_replaceableb = minetest.get_content_id("blockrooms:replaceme_3")
local c_unbreakable = minetest.get_content_id("blockrooms:unbreakable")
local c_air = minetest.get_content_id("air")


local test_function = function(minp, maxp, seed, layer)

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip") 
	local data = vm:get_data() 
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}

	math.randomseed(seed)
	data = blockrooms.generators.basic_floor_and_ceiling(minp, maxp, data, 0,4,false,false)


	for i in area:iter( minp.x, minp.y +8, minp.z, minp.x, minp.y + 8, minp.z ) do 
		--data[i] = c_replaceableb
	end


	--minetest world gen is awful and forces me to write spaghetti code
	--setting the data to the same value twice causes minetest to have a stroke and refuse to 
	--replace it properly so i have to manually write code to make sure nothing ever overlaps an already placed tile
	blockrooms.generators.make_wall(minp,maxp, data, vector.new(minp.x,minp.y + 1,minp.z), "x", 1, 3)
	for k=0, 9 do
		for i=0, 7 do
			for j=0, 4 do
				local anti_clipping_offset = 0
				if (i==7 and j == 4) then
					anti_clipping_offset = 1
				end
				if (math.random(1,4) ~= 1) then
					data = blockrooms.generators.make_wall(minp,maxp, data, vector.new(minp.x + (i * 10) + (j * 2) + 1,minp.y + 1,minp.z + (k * 8)), "x", 2 - anti_clipping_offset, 3)
				end
			end
		end
	end


	for k=0, 9 do
		for i=0, 7 do
			for j=0, 4 do
				local anti_clipping_offset = 0
				if (i==7 and j == 4 and k == 0) then
					anti_clipping_offset = 1
				end
				if (math.random(1,4) ~= 1) then
					data = blockrooms.generators.make_wall(minp,maxp, data, vector.new(minp.x + (k * 8),minp.y + 1,minp.z + 1 + (i * 10) + (j * 2)), "z", 2 - anti_clipping_offset, 3)
				end
			end
		end
	end

	

	for i in area:iter( minp.x, minp.y, minp.z, maxp.x, maxp.y, maxp.z ) do 
		if data[i] == c_replaceable then
			data[i] = c_unbreakable
		end 
	end
	
	vm:set_data(data)

	vm:set_lighting{day=0, night=0} 
	
	vm:calc_lighting() 

	vm:write_to_map() 

end









local testdata = {
	internal_name = "example_floor", --the internal name used by various internal functions. this should not change. ever. please dont change this after you release your mod.
	display_name = "Floor EXAMPLE", --The external name, you can localize it if you want or just leave it.
	short_name = "EXAMPLE", --this should typically be the number, for instance if its Floor 0 this should be "0". Floor FUN would be "FUN" and whatnot.
	floor_slot = 0, --used for sorting.
	generator = test_function, --a generator function, the function is basically just a hook for register_on_generated, but only called on certain conditions
	level_type = "normal", --the type of the floor, supports "normal", "enigmatic", and "sublevel" at the moment. set a floor as enigmatic if it should be ignored by stuff like the hub.
	--sublevel doesn't do anything at the moment, but will probably be used for sorting in the future.
	layers_to_allocate = 1 --how many "layers" should be allocated? layers in this case mean how many mapchunks tall should this floor be?
	--on_player_death = function(player) --a function that is called when a player dies on this floor, return true to do the default death handling, false to prevent it
	--on_player_spawn = function(player,previous_floor) --previous_floor is the internal name of the previous floor the player was on before being sent to this one, if left blank the default spawn code will be used.
}

blockrooms.floors.add_level(testdata)
