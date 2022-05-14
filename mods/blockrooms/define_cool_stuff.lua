blockrooms.change_player_stat = function(player,stat,val) --the return value for this is whether or not it was able to actually use it
	local isneg = val < 0
	local meta = player:get_meta()
	local value = meta:get_int(stat)
	local increase = val
	if (not isneg) then
	local statmax = 100
	if (stat == "hunger") then
		statmax = blockrooms.hunger_max
	elseif (stat == "thirst") then
		statmax = blockrooms.thirst_max
	elseif (stat == "sanity") then
		statmax = blockrooms.sanity_max
	end
	if (value + val >= statmax) then 
		increase = statmax - value
	end
	else
		if (value + val < 0) then
			increase = -value
		end
	end
	if (increase <= 0 and not isneg) then return false end
	meta:set_int(stat,value + increase)
	hb.change_hudbar(player, "br_" .. stat, meta:get_int(stat))
    return true
end

minetest.register_on_newplayer(function(player)
	local meta = player:get_meta()
	meta:set_int("floor",0) --placeholder
	meta:set_int("thirst",50)
	meta:set_int("hunger",100)
	meta:set_int("sanity",100)
end)

minetest.register_on_joinplayer(function(player)
	local meta = player:get_meta()
	hb.init_hudbar(player, "br_hunger", meta:get_int("hunger"), 100, false)
	hb.init_hudbar(player, "br_thirst", meta:get_int("thirst"), 50, false)
	hb.init_hudbar(player, "br_sanity", meta:get_int("sanity"), 100, false)
end)

minetest.register_on_dieplayer(function(player)
	local meta = player:get_meta()
	meta:set_int("thirst",50)
	meta:set_int("floor",0) --placeholder
	meta:set_int("hunger",100)
	meta:set_int("sanity",100)
	--minetest.chat_send_all(player:get_player_name() .. " died.")
end)