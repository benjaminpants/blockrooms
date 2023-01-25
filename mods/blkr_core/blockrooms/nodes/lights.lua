local S = minetest.get_translator()

--decided to move this over here.
minetest.register_node("blockrooms:light_block", {
    description = S("Light Block"),
    tiles = {"blockrooms_ceiling_light.png"},
    paramtype = "light",
    light_source = 12,
    groups = {hand_breakable=4,blunt=1},
    drop = "blockrooms:glass_shard 2",
    on_dig = function(pos,node,player)
        if (not minetest.check_player_privs(player, {creative=true})) then
            player:set_hp(player:get_hp() - 2, "glass_break")
        end
        minetest.node_dig(pos,node,player)
    end,
    sounds = blockrooms.node_sound_base_shatter({},"glass")
})

minetest.register_node("blockrooms:hanging_light", {
    description = S("Hanging Light"),
    tiles = {"blockrooms_light_ceil.png"},
    mesh = "light_ceil_hang.obj",
    drawtype = "mesh",
    paramtype2 = "facedir",
    paramtype = "light",
    light_source = 6,
    groups = {blunt=2},
    drop = "blockrooms:glass_shard 2",
    on_dig = function(pos,node,player)
        if (not minetest.check_player_privs(player, {creative=true})) then
            player:set_hp(player:get_hp() - 2, "glass_break")
        end
        minetest.node_dig(pos,node,player)
    end,
    sounds = blockrooms.node_sound_base_shatter({},"glass"),
    selection_box = {
        type = "fixed",
        fixed = {-0.2, -0.01, -0.3, 0.2, 0.5, 0.3},
    },
    collision_box = {
        type = "fixed",
        fixed = {-0.2, -0.01, -0.3, 0.2, 0.5, 0.3},
    }
})

minetest.register_node("blockrooms:floodlight", {
	description = S("Floodlight"),
	tiles = { "blockrooms_floodlight.png", "blockrooms_floodlight_back.png", "blockrooms_floodlight_side.png", "blockrooms_floodlight_side.png", "blockrooms_floodlight_topbot.png", "blockrooms_floodlight_topbot.png" },
	drawtype = "nodebox",
	is_ground_content = false,
	sunlight_propagates = true,
    paramtype = "light",
    light_source = 14,
    paramtype2 = "wallmounted",
	node_box = {
        type = "fixed",
        fixed = {
            {-0.1250, -0.5000, -0.5000, 0.1250, -0.3750, 0.5000}
        }
    },
    inventory_image = "blockrooms_floodlight_item.png",
    sounds = blockrooms.node_sound_base_shatter({},"glass"),
	groups = { hand_breakable = 7},
})

--compat
minetest.register_alias("level1:floodlight", "blockrooms:floodlight")