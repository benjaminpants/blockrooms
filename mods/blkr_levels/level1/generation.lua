local G = minetest.get_content_id

local default_path = minetest.get_modpath("level1")

local c_concrete = G("blockrooms:concrete")
local c_concrete_light = G("level1:concrete_lightb")
local c_concrete_wet = G("blockrooms:concrete_wet")
local c_ceiling = G("level1:ceiling")
local c_unbreakable = G("blockrooms:unbreakable")
local c_air = G("air")

local create_wall = function(area, data, minp, sx,sz,wx,wh, material)
	for i in area:iter( minp.x + sx, minp.y + 2, minp.z + sz, minp.x + sx + wx, minp.y + 6, minp.z + sz + wh ) do 
		if data[i] == c_air then
			data[i] = material
		end 
	end

end

local schematic_list_empty_random = {"/schems/l1_pillar_solo.mts"}

local schematic_list_important_structures = {"/schems/l1_staircase.mts"}

local corners_list = {"/schems/l1_corners_base.mts","/schems/l1_corners_lighted.mts","/schems/l1_corners_lightplate.mts","/schems/l1_corners_open.mts","/schems/l1_corners_plated.mts"}

local sides_list = {"/schems/l1_side_door.mts","/schems/l1_side_lights.mts","/schems/l1_side_panel.mts","/schems/l1_side_simple.mts"}

for i=1, 2 do
	table.insert(schematic_list_empty_random,"/schems/l1_empty_spot.mts")
end

local generateFloor_Func = function(minp, maxp, seed, layer, vm, emin, emax, data, area, offset)
	local size = area:getExtent()


	for x=1, size.x / 8 do
		for z=1, size.z / 8 do
			local vecPos = vector.new(minp.x + ((x - 1) * 8),minp.y + 2 + offset, minp.z + ((z - 1) * 8))
			if (chunktype == "standard") then
				if (math.random(1,2) == 1) then
					minetest.place_schematic(vecPos, default_path .. corners_list[math.random(1,#corners_list)], "random")
				else
					if (math.random(1,2) == 1) then
						minetest.place_schematic(vecPos, default_path .. sides_list[math.random(1,#sides_list)], "random")
					else
						minetest.place_schematic(vecPos, default_path .. schematic_list_empty_random[math.random(1,#schematic_list_empty_random)], "0")
					end
				end
			else
				if (math.random(1,128) ~= 1) then
					minetest.place_schematic(vecPos, default_path .. schematic_list_empty_random[math.random(1,#schematic_list_empty_random)], "0")
				else
					minetest.place_schematic(vecPos, default_path .. schematic_list_important_structures[math.random(1,#schematic_list_important_structures)], "random")
				end
			end
		end
	end

end


local generate_function = function(minp, maxp, seed, layer)

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip") 
	local data = vm:get_data() 
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}

	math.randomseed(seed)

	local chunktype = "standard"
	if (math.random(1,16) == 1) then
		chunktype = "large_area"
	end

	for i in area:iter( minp.x, minp.y + 1, minp.z, maxp.x, minp.y + 1, maxp.z ) do 
		if data[i] == c_air then
			if (math.random(1,100) == 1) then
				data[i] = c_concrete_wet
			else
				data[i] = c_concrete
			end
		end 
	end


	vm:set_data(data)

	vm:set_lighting{day=0, night=0} 
	
	vm:calc_lighting() 

	vm:write_to_map()

	generateFloor_Func(minp, maxp, seed, layer, vm, emin, emax, data, area, 0)
	

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
