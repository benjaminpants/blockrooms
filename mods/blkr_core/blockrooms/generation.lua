local c_replaceable = minetest.get_content_id("blockrooms:replaceme")
local c_air = minetest.get_content_id("air")


minetest.register_on_generated(function(minp, maxp, seed)
	for i=1, #blockrooms.floors.level_ids do
		--minetest.chat_send_all(i)
		local v = blockrooms.floors.levels[blockrooms.floors.level_ids[i]]
		for y=1, v.layers_to_allocate do
			--minetest.chat_send_all("text:" .. y)
			if (minp.y == blockrooms.floors.get_start_floor_y((v.starting_y - 1) + y)) then
				v.generator(minp,maxp,seed, y)
			end
		end
	end
end)