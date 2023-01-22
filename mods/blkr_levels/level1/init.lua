local S = minetest.get_translator()

local default_path = minetest.get_modpath("level1")

minetest.register_node("level1:ceiling", {
    description = S("Plaster Ceiling Tile (2x2)"),
    tiles = {{name="level1_ceiling.png", align_style='world', scale=2},{name="level1_ceiling.png", align_style='world', scale=2},"level1_ceiling_1x1.png"},
    drop = "level1:ceiling_single",
    inventory_image = "[inventorycube{level1_ceiling_preview.png{level1_ceiling_preview.png{level1_ceiling_preview.png",
    sounds = blockrooms.node_sound_base({},"tin")
})

minetest.register_node("level1:ceiling_single", {
    description = S("Plaster Ceiling Tile (1x1)"),
    tiles = {"level1_ceiling_1x1.png"},
    sounds = blockrooms.node_sound_base({},"tin")
})

minetest.register_craft({
	output = "level1:ceiling 4",
	type = "shapeless",
	recipe = {
		"level1:ceiling_single","level1:ceiling_single","level1:ceiling_single","level1:ceiling_single"
	}
})


minetest.register_node("level1:orange_tape_sl", {
    description = S("Orange Tape Side Left"),
    drawtype = "signlike",
    paramtype = "light",
    paramtype2 = "wallmounted",
    selection_box = {
        type = "wallmounted",
        wall_top    = {-0.5, 0.4375, -0.5, 0.5, 0.5, 0.5},
        wall_bottom = {-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
        wall_side   = {-0.5, -0.5, -0.5, -0.4375, 0.5, 0.5},
    },
    drop = "tape:tape_org 1",
    walkable = false,
    sunlight_propagates = true,
    tiles = {"level1_tape_side_l.png^[multiply:#FF8000"},
    is_ground_content = false,
    sounds = tape.node_sound_tape(),
    groups = {near_instant=2,}
    --sounds = backrooms.node_sound_defaults()
})

minetest.register_node("level1:orange_tape_sr", {
    description = S("Orange Tape Side Right"),
    drawtype = "signlike",
    paramtype = "light",
    paramtype2 = "wallmounted",
    selection_box = {
        type = "wallmounted",
        wall_top    = {-0.5, 0.4375, -0.5, 0.5, 0.5, 0.5},
        wall_bottom = {-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
        wall_side   = {-0.5, -0.5, -0.5, -0.4375, 0.5, 0.5},
    },
    drop = "tape:tape_org 1",
    walkable = false,
    sunlight_propagates = true,
    tiles = {"level1_tape_side_r.png^[multiply:#FF8000"},
    is_ground_content = false,
    sounds = tape.node_sound_tape(),
    groups = {near_instant=2}
    --sounds = backrooms.node_sound_defaults()
})

minetest.register_node("level1:concrete_f_painted", {
    description = S("Concrete (F Painted)"),
    tiles = {"blockrooms_concrete.png","blockrooms_concrete.png","blockrooms_concrete.png","blockrooms_concrete.png","blockrooms_concrete.png","blockrooms_concrete.png^level1_f_paint.png"},
    paramtype2 = "facedir",
    drop = "blockrooms:concrete",
    groups = minetest.registered_nodes["blockrooms:concrete"].groups,
    sounds = minetest.registered_nodes["blockrooms:concrete"].sounds
})

minetest.register_node("level1:concrete_dirty", {
    description = S("Concrete (Dirty)"),
    tiles = {"blockrooms_concrete.png","blockrooms_concrete.png","level1_concrete_dirty_side.png"},
    drop = "blockrooms:concrete",
    groups = minetest.registered_nodes["blockrooms:concrete"].groups,
    sounds = minetest.registered_nodes["blockrooms:concrete"].sounds
})

minetest.register_alias("level1:concrete_painted", "level1:concrete_f_painted")

minetest.register_node("level1:concrete_lightb", {
    description = S("Blueish Concrete"),
    tiles = {"level1_floor_concrete.png"},
    groups = minetest.registered_nodes["blockrooms:concrete"].groups,
    sounds = minetest.registered_nodes["blockrooms:concrete"].sounds
})

minetest.register_craft({
    type = "shapeless",
    output = "level1:concrete_lightb 1",
    recipe = {
        "blockrooms:concrete"
    }
})

minetest.register_craft({
    type = "shapeless",
    output = "blockrooms:concrete 1",
    recipe = {
        "level1:concrete_lightb"
    }
})

blockrooms.storage.create_storage({
    node_id = "level1:crate_special",
    node_definition = {
        description = S("Crate (Level 1)"),
        tiles = {"blockrooms_crate.png"},
        mesh = "crate.obj",
        drawtype = "mesh",
        groups = {},
        sounds = blockrooms.node_sound_base_custom_place({},"wood"),
        allow_metadata_inventory_put = function()
            return 0 --no
        end
    },
    storage_size = {4,1},
    gui_pos_offset = {2,2}
})

local lootTable = {
    max_items_range = {min = 1, max = 6},
    data = {
        {value={
            overrideFunc = function()
                return {
                    name="tape:tape_" .. colors.chooserandom().id,
                    item_range = {min = 1, max = 3},
                    max_duplicates = 3
                }
            end,
            name="tape_part"
        },
        weight=50},
        {value={
            name="tape:tapeless_roll",
            item_range = {min = 1, max = 3},
            max_duplicates = 2
        },
        weight=50},
        {value={
            name="blockrooms:paper",
            item_range = {min = 1, max = 3},
            max_duplicates = 4
        },
        weight=60},
        {value={
            name="blockrooms:plastic_bottle_dirty_almondwater",
            item_range = {min = 1, max = 1},
            max_duplicates = 1
        },
        weight=70},
        {value={
            name="blockrooms:empty_plastic_bottle",
            item_range = {min = 1, max = 1},
            max_duplicates = 2
        },
        weight=76},
        {value={
            name="blockrooms:chips",
            item_range = {min = 1, max = 4},
            max_duplicates = 1
        },
        weight=69},
        {value={
            name="blockrooms:money_penny",
            item_range = {min = 1, max = 21},
            max_duplicates = 4
        },
        weight=49},
        {value={
            name="blockrooms:money_quarter",
            item_range = {min = 1, max = 11},
            max_duplicates = 4
        },
        weight=48},
        {value={
            name="blockrooms:money_dollar",
            item_range = {min = 1, max = 3},
            max_duplicates = 2
        },
        weight=46},
        {value={
            name="blockrooms:bandaid",
            item_range = {min = 1, max = 3},
            max_duplicates = 1
        },
        weight=10}
    }
}

loot_tables.AddLootTable("l1_crate",lootTable)

local cs = minetest.registered_nodes["level1:crate_special"]

local oldoc = cs.on_construct

cs.on_construct = function(pos)
    oldoc(pos)
    loot_tables.FillInventory(minetest.get_meta(pos):get_inventory(),"l1_crate")
end


dofile(default_path .. "/generation.lua")