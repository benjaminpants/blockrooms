blockrooms.stats = {}

blockrooms.stats.thirstDrainTime = 6
blockrooms.stats.hungerDrainTime = 3
blockrooms.stats.sanityDrainTime = 1


--TODO: all this code is stupid and it was directly ported from the OG "Minetest Backrooms"


blockrooms.stats.reduceStat = function(stat)
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
				player:set_hp(player:get_hp() - 6, "thirst_gone")
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

blockrooms.stats.reduceStatSanity = function(stat)
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
			blockrooms.increment_exhaustion(player,math.random(0,1))
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


blockrooms.stats.reduceStatThirst = function()
    minetest.after(blockrooms.stats.thirstDrainTime, blockrooms.stats.reduceStatThirst)
	blockrooms.stats.reduceStat("thirst")
end

blockrooms.stats.attemptHeal = function()
    minetest.after(blockrooms.stats.hungerDrainTime, blockrooms.stats.attemptHeal)
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

blockrooms.stats.reduceSanity = function()
    minetest.after(blockrooms.stats.hungerDrainTime, blockrooms.stats.reduceSanity)
	local players = minetest.get_connected_players()
	for _, player in pairs(players) do
		if (player:get_hp() == 0) then return end
		blockrooms.increment_exhaustion(player,math.random(0,2)) --bring back hunger depletion over time, just make it very slow.
	end
	blockrooms.stats.reduceStatSanity("sanity")
end


minetest.after(blockrooms.stats.thirstDrainTime, blockrooms.stats.reduceStatThirst)

minetest.after(blockrooms.stats.hungerDrainTime, blockrooms.stats.attemptHeal)

minetest.after(blockrooms.stats.sanityDrainTime, blockrooms.stats.reduceSanity)

--minetest.register_globalstep(playertic)