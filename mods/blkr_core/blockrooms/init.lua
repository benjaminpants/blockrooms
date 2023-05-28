local S = minetest.get_translator()

local default_path = minetest.get_modpath("blockrooms")


blockrooms = {}

blockrooms.default_floor = "example_floor"

dofile(default_path .. "/sounds.lua")

dofile(default_path .. "/api/floors.lua")

dofile(default_path .. "/api/chests.lua")

dofile(default_path .. "/api/liquids.lua")

--some game constants
blockrooms.hunger_max = 100
blockrooms.thirst_max = 80 --the old thirst value was 50 which was. STUPID. to say the least.
blockrooms.sanity_max = 100
blockrooms.exhaustion_max = 100

minetest.register_item(":", {
	type = "none",
	wield_image = "blockrooms_hand.png",
	wield_scale = {x=1,y=1,z=3.5},
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 8, --anything with hand_breakable or near_instance should pretty much always drop
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

dofile(default_path .. "/nodes/stones.lua")

dofile(default_path .. "/nodes/lights.lua")

dofile(default_path .. "/nodes/building.lua")

dofile(default_path .. "/nodes/decos.lua")

dofile(default_path .. "/crafting_recipes.lua")

dofile(default_path .. "/liquid_definitions.lua")

--add localizations for the following strings(mostly for the automatic localization creator) in the main file so its not scattered everywhere.

S("Level @1", "")