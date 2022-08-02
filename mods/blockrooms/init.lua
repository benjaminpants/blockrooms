local S = minetest.get_translator()

blockrooms = {}

blockrooms.default_floor = "example_floor"

blockrooms.rng_utils = {}

blockrooms.floors = {}

blockrooms.floors.levels = {}

blockrooms.floors.level_ids = {}

blockrooms.floors.next_valid_y = 0


--the below function adds the room id and stuff to the levels table, and increments next valid y, so that floors that need it can be more then 1 mapchunk high
blockrooms.floors.add_level = function(data)
	
	blockrooms.floors.levels[data.internal_name] = data
	
	--store the order in which they are added for later use, primarily to make sure iterating is consistent.
	table.insert(blockrooms.floors.level_ids,data.internal_name)
end

blockrooms.hunger_max = 100
blockrooms.thirst_max = 50
blockrooms.sanity_max = 100
blockrooms.exhaustion_max = 100

blockrooms.floors.get_start_floor_y = function(starting_y)
    return 48 + (starting_y - 387) * 80 --why reduce the height? it allows for squeezing as many levels as possible into one world.
end

blockrooms.default_setsky = function(player,color)
	if (color == nil) then
		color = "#050505"
	end
	player:set_sky({base_color = color,type="plain",clouds=false})
	player:set_sun({visible = false})
	player:set_moon({visible = false})
	player:set_stars({visible = false})
end

minetest.register_on_mods_loaded(function()
	table.sort(blockrooms.floors.level_ids, function(i1,i2)
		return blockrooms.floors.levels[i1].floor_slot < blockrooms.floors.levels[i2].floor_slot
	end)

	for i=1, #blockrooms.floors.level_ids do
		local data = blockrooms.floors.levels[blockrooms.floors.level_ids[i]]
		data.starting_y = blockrooms.floors.next_valid_y
	
		blockrooms.floors.next_valid_y = blockrooms.floors.next_valid_y + data.layers_to_allocate
	end
end)




minetest.register_item(":", {
	type = "none",
	wield_image = "blockrooms_hand.png",
	wield_scale = {x=1,y=1,z=3.5},
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 0,
		groupcaps = { --WE ARE NOT BOUND BY MINETEST GAME. WE CAN RIGHT THE WRONGS OF ITS SINS. 0 IS THE WEAKEST. STRONGNESS GOES UP AS THE NUMBER DOES.
			hand_breakable = {times={[8]=8.5,[7]=7,[6]=5.75,[5]=4.5,[4]=3.75,[3]=3.25,[2]=2.00,[1]=1.40}, uses=0, maxlevel=4},
			near_instant = {times={[8]=0.8,[7]=0.7,[6]=0.6,[5]=0.5,[4]=0.4,[3]=0.3,[2]=0.2,[1]=0.1}, uses=0, maxlevel=4}
		},
		damage_groups = {fleshy=1},
	}
})

hb.register_hudbar("br_thirst", 0xFFFFFF, "Thirst", { icon = "blockrooms_icon_thrist.png", bgicon = "blockrooms_bgicon_thrist.png", bar = "blockrooms_bar_thirst.png"}, blockrooms.thirst_max, blockrooms.thirst_max, false)

hb.register_hudbar("br_hunger", 0xFFFFFF, "Hunger", { icon = "blockrooms_icon_hunger.png", bgicon = "blockrooms_bgicon_hunger.png", bar = "blockrooms_bar_hunger.png"}, blockrooms.hunger_max, blockrooms.hunger_max, false)

hb.register_hudbar("br_sanity", 0xFFFFFF, "Sanity", { icon = "blockrooms_icon_sanity.png", bgicon = "blockrooms_bgicon_sanity.png", bar = "blockrooms_bar_sanity.png"}, blockrooms.sanity_max, blockrooms.sanity_max, false)

local default_path = minetest.get_modpath("blockrooms")

dofile(default_path .. "/sounds.lua")

minetest.register_node("blockrooms:replaceme", {
description = "REPLACE ME",
tiles = {"blockrooms_replaceme.png"},
groups = {hand_breakable=2},
sounds = blockrooms.node_sound_base_custom_place({},"wood")
})

minetest.register_node("blockrooms:unbreakable", {
description = "Unbreakable",
tiles = {"blockrooms_unbreakable.png"},
sounds = blockrooms.node_sound_base({},"tin")
})

--TODO: delete these. they are dumb.

minetest.register_node("blockrooms:replaceme_2", {
description = "REPLACE ME",
tiles = {"blockrooms_replaceme.png^blockrooms_icon_sanity.png"},
groups = {hand_breakable=2}
})

minetest.register_node("blockrooms:replaceme_3", {
description = "REPLACE ME",
tiles = {"blockrooms_replaceme.png^blockrooms_icon_hunger.png"},
groups = {hand_breakable=2}
})

dofile(default_path .. "/random_utils.lua")

dofile(default_path .. "/basic_prebuilt_generators.lua")

dofile(default_path .. "/define_cool_stuff.lua")

dofile(default_path .. "/food_and_drinks.lua")

dofile(default_path .. "/timers.lua")

dofile(default_path .. "/template.lua")

dofile(default_path .. "/generation.lua")

dofile(default_path .. "/sfinv.lua")

dofile(default_path .. "/exhaustion_hooks.lua")

dofile(default_path .. "/materials.lua")

dofile(default_path .. "/tools.lua")

dofile(default_path .. "/nodes.lua")

--add localizations for the following strings(mostly for the automatic localization creator) in the main file so its not scattered everywhere.

S("@1 Floor", "")