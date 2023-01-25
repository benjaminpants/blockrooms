local default_path = minetest.get_modpath("level2")

local c_unbreakable = G("blockrooms:unbreakable")

local total_structures = 13


local main_func = function(minp, maxp, seed, layer)
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip") 
	local data = vm:get_data() 
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}

	math.randomseed(seed)
	
	vm:set_data(data)

	vm:set_lighting{day=0, night=0} 
	
	vm:calc_lighting() 

	vm:write_to_map() 


    --no more parallel universe

    if (minp.x ~= -32) then return end

    local schemSize = 80 / 5

    for z=0, 15 do
        local vec = vector.new(minp.x + 32, minp.y + 1, minp.z + (z * 5))
        if (math.random(1,4) ~= 1) then
            minetest.place_schematic(vec, default_path .. "/schems/l2_hall_main_" .. math.random(1,3) .. ".mts", "0")
        else
            minetest.place_schematic(vec, default_path .. "/schems/l2_hall_main_" .. math.random(4,total_structures) .. ".mts", "0")
        end
    end

end



local leveltwodata = {
	internal_name = "level_2", --the internal name used by various internal functions. this should not change. ever. please dont change this after you release your mod.
	display_name = "Level 2", --The external name, you can localize it if you want or just leave it.
	short_name = "2", --this should typically be the number, for instance if its Floor 0 this should be "0". Floor FUN would be "FUN" and whatnot.
	floor_slot = 2, --used for sorting.
	generator = main_func, --a generator function, the function is basically just a hook for register_on_generated, but only called on certain conditions
	level_type = "normal", --the type of the floor, supports "normal", "enigmatic", and "sublevel" at the moment. set a floor as enigmatic if it should be ignored by stuff like the hub.
	--sublevel doesn't do anything at the moment, but will probably be used for sorting in the future.
	layers_to_allocate = 1, --how many "layers" should be allocated? layers in this case mean how many mapchunks tall should this floor be?
	--spawn_offset = 1 --how high the player is spawned above the "ground" level
	--on_player_death = function(player) --a function that is called when a player dies on this floor, return true to do the default death handling, false to prevent it
	--on_player_spawn = nil--previous_floor is the internal name of the previous floor the player was on before being sent to this one, if left blank the default spawn code will be used.
	--globalstep = function(dtime) --the global step function to be called on this floor
}

leveltwodata.on_player_spawn = function(player, previous_floor)
    local y = blockrooms.floors.get_floor_y_from_data(leveltwodata,true)
    player:set_pos(vector.new(2.5,y + 0.5,40))
end

blockrooms.floors.add_level(leveltwodata)
