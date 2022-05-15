local c_replaceable = minetest.get_content_id("blockrooms:replaceme")
local c_unbreakable = minetest.get_content_id("blockrooms:unbreakable")
local c_air = minetest.get_content_id("air")

blockrooms.generators = {}

blockrooms.generators.basic_floor_and_ceiling = function(minp, maxp, seed, starty,ceiling_height, unbreakable_floor, unbreakable_ceiling)
    local vm, emin, emax = minetest.get_mapgen_object("voxelmanip") 
	local data = vm:get_data() 
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
    local offset = 0

    --if enabled, create the unbreakable floor
    --offset is used to bring everything up by 1 to make room for the unbreakable floor
    if (unbreakable_floor) then
        offset = 1
        for i in area:iter( minp.x, minp.y + starty, minp.z, maxp.x, minp.y + starty, maxp.z ) do 
            if data[i] == c_air then
                data[i] = c_unbreakable
            end 
        end
    end

    --create the floor
	for i in area:iter( minp.x, minp.y + starty + offset, minp.z, maxp.x, minp.y + starty + offset, maxp.z ) do 
		if data[i] == c_air then
			data[i] = c_replaceable
		end 
	end

    --create the ceiling
    local ch = minp.y + starty + ceiling_height + offset
    for i in area:iter( minp.x, ch, minp.z, maxp.x, ch, maxp.z ) do 
		if data[i] == c_air then
			data[i] = c_replaceable
		end 
	end

    if (unbreakable_ceiling) then
        for i in area:iter( minp.x, ch + 1, minp.z, maxp.x, ch + 1, maxp.z ) do 
            if data[i] == c_air then
                data[i] = c_unbreakable
            end 
        end
    end
	
	vm:set_data(data)

    return data
end


blockrooms.generators.basic_walls = function(minp, maxp, seed, data)

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip") 
	local data = vm:get_data() 
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
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