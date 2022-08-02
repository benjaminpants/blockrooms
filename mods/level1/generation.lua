local G = minetest.get_content_id

local default_path = minetest.get_modpath("level1")

local c_concrete = G("blockrooms:concrete")
local c_ceiling = G("level1:ceiling")
local c_unbreakable = G("blockrooms:unbreakable")
local c_air = G("air")


local generate_function = function(minp, maxp, seed, layer)

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip") 
	local data = vm:get_data() 
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}

	math.randomseed(seed)
	for i in area:iter( minp.x, minp.y, minp.z, maxp.x, minp.y, maxp.z ) do 
		if data[i] == c_air then
			data[i] = c_unbreakable
		end 
	end
	for i in area:iter( minp.x, minp.y + 1, minp.z, maxp.x, minp.y + 1, maxp.z ) do 
		if data[i] == c_air then
			data[i] = c_concrete
		end 
	end

	for i in area:iter( minp.x, minp.y + 7, minp.z, maxp.x, minp.y + 7, maxp.z ) do 
		if data[i] == c_air then
			data[i] = c_ceiling
		end 
	end
	for i in area:iter( minp.x, minp.y + 8, minp.z, maxp.x, minp.y + 8, maxp.z ) do 
		if data[i] == c_air then
			data[i] = c_unbreakable
		end 
	end

	
	
	vm:set_data(data)

	vm:set_lighting{day=0, night=0} 
	
	vm:calc_lighting() 

	vm:write_to_map()

	local offset = 0

	for i=1, math.random(1,3) do
		minetest.place_schematic(vector.new(minp.x + math.random(0,70) + offset,minp.y + 2, minp.z + math.random(0,70)), default_path .. "/schems/level1_bridge_thing.mts", "random")
	end

	for j=1, 6 do
		offset = offset + math.random(10, 15)
		for i=1, 8 do
			if (math.random(1,20) ~= 1) then
				minetest.place_schematic(vector.new(minp.x + 4 + offset,minp.y + 2, minp.z + 4 + (i * 10)), default_path .. "/schems/level1_pillar.mts", 0)
			end
		end
	end

end









local testdata = {
	internal_name = "level_1", --the internal name used by various internal functions. this should not change. ever. please dont change this after you release your mod.
	display_name = "Level 1", --The external name, you can localize it if you want or just leave it.
	short_name = "1", --this should typically be the number, for instance if its Floor 0 this should be "0". Floor FUN would be "FUN" and whatnot.
	floor_slot = 1, --used for sorting.
	generator = generate_function, --a generator function, the function is basically just a hook for register_on_generated, but only called on certain conditions
	level_type = "normal", --the type of the floor, supports "normal", "enigmatic", and "sublevel" at the moment. set a floor as enigmatic if it should be ignored by stuff like the hub.
	--sublevel doesn't do anything at the moment, but will probably be used for sorting in the future.
	layers_to_allocate = 1, --how many "layers" should be allocated? layers in this case mean how many mapchunks tall should this floor be?
	spawn_offset = 2 --how high the player is spawned above the "ground" level
	--on_player_death = function(player) --a function that is called when a player dies on this floor, return true to do the default death handling, false to prevent it
	--on_player_spawn = function(player,previous_floor) --previous_floor is the internal name of the previous floor the player was on before being sent to this one, if left blank the default spawn code will be used.
}

blockrooms.floors.add_level(testdata)
