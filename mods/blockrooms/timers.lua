local thirstdrain = 6
local hungerdrain = 3
local sanitydrain = 1



local function reduce_stat(stat)
	local players = minetest.get_connected_players()
    for _, player in pairs(players) do
		if (player:get_hp() == 0) then return end
		local meta = player:get_meta()
		local statstate = meta:get_int(stat)
		
		if (statstate == nil) then return end
		local value = 1
		
		if (statstate == 0) then
			if (stat == "hunger") then
				player:set_hp(player:get_hp() - 1, "hunger_gone")
				return
			end
			if (stat == "thirst") then
				player:set_hp(player:get_hp() - math.random(1,3), "thirst_gone")
				return
			end
		end
		
		if (stat == "hunger") then
			local hp = player:get_hp()
			if (hp < 20) then
				player:set_hp(math.min(hp + 2,20))
				value = 2
			end
		end
		if (statstate - value < 0) then
			value = statstate
		end
		meta:set_int(stat,statstate - value)
		hb.change_hudbar(player, "br_" .. stat, statstate - value)
	end
end

local function reduce_stat_sanity(stat)
	local players = minetest.get_connected_players()
    for _, player in pairs(players) do
		if (player:get_hp() == 0) then return end
		local meta = player:get_meta()
		local statstate = meta:get_int(stat)
		if (statstate == nil) then return end
		if (statstate == 0) then
			player:set_hp(0, "insane")
			return
		end
		local value = 1
		local pos = {x = math.round(player:get_pos().x), y = math.round(player:get_pos().y + 1), z = math.round(player:get_pos().z)}
		local light = minetest.get_node_light(pos)
		if (light == nil) then return end
		if (light == 0) then
			value = -1
		end
		if ((statstate + value) > blockrooms.sanity_max) then
			meta:set_int(stat,blockrooms.sanity_max)
			hb.change_hudbar(player, "br_" .. stat, blockrooms.sanity_max)
			return
		end
		meta:set_int(stat,statstate + value)
		hb.change_hudbar(player, "br_" .. stat, statstate + value)
	end
end


local function reducethirst()
    minetest.after(thirstdrain, reducethirst)
	reduce_stat("thirst")
end

local function attemptheal()
    minetest.after(hungerdrain, attemptheal)
	local players = minetest.get_connected_players()
    for _, player in pairs(players) do
		local hp = player:get_hp()
		if (hp < 20) then
			if (blockrooms.change_player_stat(player,"hunger",-2)) then
				player:set_hp(math.min(hp + 2,20))
			end
		end
	end
end

local function reducesanity()
    minetest.after(sanitydrain, reducesanity)
	reduce_stat_sanity("sanity")
end

--BELOW IS DISABLED SINCE I HAVENT REIMPLEMENTED FLOORS
local function playertic(time)
	local players = minetest.get_connected_players()
    for _, player in pairs(players) do
		local meta = player:get_meta()
		local floor = meta:get_int("floor")
		if (blockrooms.floordata[floor] ~= nil) then
			if (blockrooms.floordata[floor].floor_tic ~= nil) then
				blockrooms.floordata[floor].floor_tic(player)
			end
		end
	end
end


--TODO: Re-enable stat drain once food items are re-implemented. Possibly disable stat drain if the player is in creative mode or has the "no_drain" permission.

minetest.after(thirstdrain, reducethirst)

minetest.after(hungerdrain, attemptheal)

minetest.after(sanitydrain, reducesanity)

--minetest.register_globalstep(playertic)