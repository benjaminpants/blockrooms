
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
	for i in area:iter( minp.x, minp.y, minp.z, maxp.x, minp.y, maxp.z ) do 
		if data[i] == c_air then
			data[i] = c_replaceable
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
