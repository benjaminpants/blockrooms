blockrooms = {}

blockrooms.default_floor = "example_floor"

blockrooms.rng_utils = {}

blockrooms.floors = {}

blockrooms.floors.levels = {}

blockrooms.floors.level_ids = {}

blockrooms.floors.next_valid_y = 0


--the below function adds the room id and stuff to the levels table, and increments next valid y, so that floors that need it can be more then 1 mapchunk high
blockrooms.floors.add_level = function(data)
	data.starting_y = blockrooms.floors.next_valid_y
	
	blockrooms.floors.next_valid_y = blockrooms.floors.next_valid_y + data.layers_to_allocate
	
	blockrooms.floors.levels[data.internal_name] = data
	
	--store the order in which they are added for later use, primarily to make sure iterating is consistent.
	blockrooms.floors.level_ids[#blockrooms.floors.level_ids + 1] = (#blockrooms.floors.level_ids + 1)
end

blockrooms.hunger_max = 100
blockrooms.thirst_max = 50
blockrooms.sanity_max = 100

blockrooms.floors.get_start_floor_y = function(starting_y)
    return 48 + starting_y * 80
end



minetest.register_node("blockrooms:replaceme", {
description = "REPLACE ME",
tiles = {"blockrooms_replaceme.png"},
groups = {hand_breakable=1}
})

minetest.register_node("blockrooms:unbreakable", {
description = "Unbreakable",
tiles = {"blockrooms_unbreakable.png"},
groups = {hand_breakable=1} --hehe its breakable but thats for testing purposes.
})

--TODO: delete these. they are dumb.

minetest.register_node("blockrooms:replaceme_2", {
description = "REPLACE ME",
tiles = {"blockrooms_replaceme.png^blockrooms_icon_sanity.png"},
groups = {hand_breakable=1}
})

minetest.register_node("blockrooms:replaceme_3", {
description = "REPLACE ME",
tiles = {"blockrooms_replaceme.png^blockrooms_icon_hunger.png"},
groups = {hand_breakable=1}
})

minetest.register_item(":", {
	type = "none",
	wield_image = "blockrooms_hand.png",
	wield_scale = {x=1,y=1,z=2.5},
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 0,
		groupcaps = { --WE ARE NOT BOUND BY MINETEST GAME. WE CAN RIGHT THE WRONGS OF ITS SINS. 0 IS THE WEAKEST. STRONGNESS GOES UP AS THE NUMBER DOES.
			hand_breakable = {times={[3]=7.00,[2]=4.00,[1]=1.40, [0]=0.6}, uses=0, maxlevel=3}
		},
		damage_groups = {fleshy=1},
	}
})

hb.register_hudbar("br_thirst", 0xFFFFFF, "Thirst", { icon = "blockrooms_icon_thrist.png", bgicon = "blockrooms_bgicon_thrist.png", bar = "blockrooms_bar_thirst.png"}, 50, 50, false)

hb.register_hudbar("br_hunger", 0xFFFFFF, "Hunger", { icon = "blockrooms_icon_hunger.png", bgicon = "blockrooms_bgicon_hunger.png", bar = "blockrooms_bar_hunger.png"}, 100, 100, false)

hb.register_hudbar("br_sanity", 0xFFFFFF, "Sanity", { icon = "blockrooms_icon_sanity.png", bgicon = "blockrooms_bgicon_sanity.png", bar = "blockrooms_bar_sanity.png"}, 100, 100, false)

local default_path = minetest.get_modpath("blockrooms")

dofile(default_path .. "/random_utils.lua")

dofile(default_path .. "/basic_prebuilt_generators.lua")

dofile(default_path .. "/define_cool_stuff.lua")

dofile(default_path .. "/timers.lua")

dofile(default_path .. "/template.lua")

dofile(default_path .. "/generation.lua")

