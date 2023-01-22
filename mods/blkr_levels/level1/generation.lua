local G = minetest.get_content_id

local S = minetest.get_translator()

local default_path = minetest.get_modpath("level1")

local c_concrete = G("blockrooms:concrete")
local c_concrete_light = G("level1:concrete_lightb")
local c_concrete_wet = G("blockrooms:concrete_wet")
local c_ceiling = G("level1:ceiling")
local c_unbreakable = G("blockrooms:unbreakable")
local c_air = G("air")

local leveldata = {
	internal_name = "level_1", --the internal name used by various internal functions. this should not change. ever. please dont change this after you release your mod.
	display_name = S("Level @1", "1"), --The external name, you can localize it if you want or just leave it.
	short_name = "1", --this should typically be the number, for instance if its Floor 0 this should be "0". Floor FUN would be "FUN" and whatnot.
	floor_slot = 1, --used for sorting.
	generator = nil, --a generator function, the function is basically just a hook for register_on_generated, but only called on certain conditions
	level_type = "normal", --the type of the floor, supports "normal", "enigmatic", and "sublevel" at the moment. set a floor as enigmatic if it should be ignored by stuff like the hub.
	--sublevel doesn't do anything at the moment, but will probably be used for sorting in the future.
	layers_to_allocate = 1, --how many "layers" should be allocated? layers in this case mean how many mapchunks tall should this floor be?
	spawn_offset = 2, --how high the player is spawned above the "ground" level
	--on_player_death = function(player) --a function that is called when a player dies on this floor, return true to do the default death handling, false to prevent it
	--on_player_spawn = function(player,previous_floor) --previous_floor is the internal name of the previous floor the player was on before being sent to this one, if left blank the default spawn code will be used.
	structures = {} --non standardized, structures are stored here so if any poor soul wants to mod this floor they can
}

leveldata.structures.empty = {"/schems/l1_pillar_solo.mts"}

leveldata.structures.important = {"/schems/l1_staircase.mts"}

leveldata.structures.corners = {"/schems/l1_corners_base.mts","/schems/l1_corners_lighted.mts","/schems/l1_corners_lightplate.mts","/schems/l1_corners_open.mts","/schems/l1_corners_plated.mts"}

leveldata.structures.sides = {"/schems/l1_side_door.mts","/schems/l1_side_lights.mts","/schems/l1_side_panel.mts","/schems/l1_side_simple.mts","/schems/l1_side_door_split.mts"}

for i=1, 2 do
	table.insert(leveldata.structures.empty,"/schems/l1_empty_spot.mts")
end

local generateFloor_Func = function(minp, maxp, seed, layer, vm, emin, emax, data, area, offset, generate_important)
	local size = area:getExtent()
	local chunktype = "standard"
	if (math.random(1,8) == 1) then
		chunktype = "large_area"
	end

	local import_x = math.random(1,math.floor(size.x / 8))
	local import_y = math.random(1,math.floor(size.z / 8))

	for x=1, size.x / 8 do
		for z=1, size.z / 8 do
			local vecPos = vector.new(minp.x + ((x - 1) * 8),minp.y + 2 + offset, minp.z + ((z - 1) * 8))
			if (chunktype == "standard") then
				if (math.random(1,3) == 1) then --less corners
					minetest.place_schematic(vecPos, default_path .. leveldata.structures.corners[math.random(1,#leveldata.structures.corners)], "random")
				else
					if (math.random(1,2) == 1) then
						minetest.place_schematic(vecPos, default_path .. leveldata.structures.sides[math.random(1,#leveldata.structures.sides)], "random")
					else
						minetest.place_schematic(vecPos, default_path .. leveldata.structures.empty[math.random(1,#leveldata.structures.empty)], "0")
					end
				end
			else
				if ((x ~= import_x or z ~= import_y) or not generate_important) then
					minetest.place_schematic(vecPos, default_path .. leveldata.structures.empty[math.random(1,#leveldata.structures.empty)], "0")
				else
					minetest.place_schematic(vecPos, default_path .. leveldata.structures.important[math.random(1,#leveldata.structures.important)], "random")
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

	generateFloor_Func(minp, maxp, seed, layer, vm, emin, emax, data, area, 0, true)
	generateFloor_Func(minp, maxp, seed, layer, vm, emin, emax, data, area, 6, false)

	data = vm:get_data() 

	for i in area:iter( minp.x, minp.y + 1 + 6, minp.z, maxp.x, minp.y + 1 + 6, maxp.z ) do 
		if data[i] == c_concrete then
			if (math.random(1,100) == 1) then
				data[i] = c_concrete_wet
			end
		end 
	end
	

end

leveldata.generator = generate_function



blockrooms.floors.add_level(leveldata)
