
local c_replaceable = minetest.get_content_id("blockrooms:replaceme")
local c_replaceablea = minetest.get_content_id("blockrooms:replaceme_2")
local c_replaceableb = minetest.get_content_id("blockrooms:replaceme_3")
local c_air = minetest.get_content_id("air")


local test_function = function(minp, maxp, seed, layer)

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip") 
	local data = vm:get_data() 
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	for i in area:iter( minp.x, minp.y, minp.z, maxp.x, minp.y, maxp.z ) do 
		if data[i] == c_air then
			if (layer == 2) then
				data[i] = c_replaceablea
			else
				data[i] = c_replaceable
			end
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
	floor_slot = 0, --a not super important internal id, mostly used for sorting, multiple floors can share the same floor slot but its not recommended. Floor slots should be the same as the number in the floor's name
	generator = test_function, --a generator function, the function is basically just a hook for register_on_generated, but only called on certain conditions
	layers_to_allocate = 2 --how many "layers" should be allocated? layers in this case mean how many mapchunks tall should this floor be?
}

blockrooms.floors.add_level(testdata)
