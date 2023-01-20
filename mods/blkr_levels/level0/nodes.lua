

local S = minetest.get_translator()


--this isnt for people to add extra wallpapers its just to avoid a ton of copy and pasted code
local wallpapers = {{"level0_wallpaper.png","Arrow Wallpaper", "arrow_wallpaper"}, {"level0_wallpaper_dots.png","Dots Wallpaper", "dots_wallpaper"}, {"level0_wallpaper_lines.png","Stripes Wallpaper", "stripes_wallpaper"}}


for i=1, #wallpapers do
    --the main block
    minetest.register_node("level0:" .. wallpapers[i][3], {
    description = S(wallpapers[i][2]),
    tiles = {"level0_wallpaper_top.png", "level0_wallpaper_top.png", wallpapers[i][1]},
    groups = {papery=1,can_have_moss=1, can_have_moss_cluster=1, can_have_moss_bit=1},
    sounds = blockrooms.node_sound_soft({},"paper")
    })

    --the block with moss
    minetest.register_node("level0:" .. wallpapers[i][3] .. "_moss", {
    description = S("Moss Covered @1",S(wallpapers[i][2])),
    drop = "level0:" .. wallpapers[i][3],
    tiles = {"level0_wallpaper_top.png", "level0_wallpaper_top.png", wallpapers[i][1] .. "^blockrooms_moss_overlay.png"},
    groups = {papery=1},
    on_rightclick = function(pos,node,clicker,itemstack)
        if (not minetest.is_player(clicker)) then return end
        if (minetest.is_protected(pos, clicker)) then
            return
        end
        if (node ~= nil) then
            minetest.set_node(pos, {name="level0:" .. wallpapers[i][3]})
            local stack = ItemStack("blockrooms:moss")
            clicker:get_inventory():add_item("main",stack)
        end
    end,
    sounds = blockrooms.node_sound_soft({},"paper")
    })

    --the block with a moss bit
    minetest.register_node("level0:" .. wallpapers[i][3] .. "_moss_bit", {
    description = S("Moss Bit Covered @1",S(wallpapers[i][2])),
    drop = "level0:" .. wallpapers[i][3],
    tiles = {"level0_wallpaper_top.png", "level0_wallpaper_top.png", wallpapers[i][1] .. "^level0_moss_bit_overlay.png"},
    groups = {papery=1},
    on_rightclick = function(pos,node,clicker,itemstack)
        if (not minetest.is_player(clicker)) then return end
        if (minetest.is_protected(pos, clicker)) then
            return
        end
        if (node ~= nil) then
            minetest.set_node(pos, {name="level0:" .. wallpapers[i][3]})
            local stack = ItemStack("level0:moss_bit")
            clicker:get_inventory():add_item("main",stack)
        end
    end,
    sounds = blockrooms.node_sound_soft({},"paper")
    })


    --the block with moss cluster
    minetest.register_node("level0:" .. wallpapers[i][3] .. "_moss_cluster", {
    description = S("@1 Moss Cluster",S(wallpapers[i][2])),
    drop = "level0:" .. wallpapers[i][3],
    tiles = {"level0_wallpaper_top.png", "level0_wallpaper_top.png", wallpapers[i][1] .. "^level0_moss_cluster_overlay.png"},
    groups = {papery=1,moss_cluster=1},
    on_rightclick = function(pos,node,clicker,itemstack)
        if (not minetest.is_player(clicker)) then return end
        if (minetest.is_protected(pos, clicker)) then
            return
        end
        if (node ~= nil) then
            minetest.set_node(pos, {name="level0:" .. wallpapers[i][3]})
            --local stack = ItemStack("blockrooms:moss")
            --clicker:get_inventory():add_item("main",stack)
            --you dont get the moss cluster back, you can remove it but you wont get it back.
        end
    end,
    sounds = blockrooms.node_sound_soft({},"paper")
    })

    --the block with trim
    minetest.register_node("level0:trim_" .. wallpapers[i][3], {
        description = S("@1 Trim", S(wallpapers[i][2])),
        tiles = {"level0_wallpaper_top.png","level0_wallpaper_top.png",wallpapers[i][1] .. "^level0_trim.png"},
        groups = {papery=1},
        sounds = blockrooms.node_sound_soft({},"paper")
    })
end


--level0:arrow_wallpaper,level0:dots_wallpaper,level0:lines_wallpaper

minetest.register_node("level0:carpet", {
    description = S("Carpet"),
    tiles = {"level0_carpet.png"},
    groups = {soft=1},
    sounds = blockrooms.node_sound_soft({},"carpet")
})

minetest.register_node("level0:carpet_wet", {
    description = S("Wet Carpet"),
    tiles = {"level0_carpet.png^blockrooms_water_stain.png","level0_carpet.png"},
    drop = "level0:carpet",
    on_rightclick = function(pos,node,clicker,itemstack)
        if (not minetest.is_player(clicker)) then return end
        if (minetest.is_protected(pos, clicker)) then
            return
        end
        if (blockrooms.change_player_stat(clicker,"thirst",6)) then
            blockrooms.change_player_stat(clicker,"sanity",-4)
            minetest.set_node(pos, {name="level0:carpet"})
		end
    end,
    groups = {soft=1},
    sounds = blockrooms.node_sound_soft({},"carpet")
})

minetest.register_node("level0:ceiling_tile", {
    description = S("Ceiling Tile"),
    tiles = {"level0_ceil.png"},
    groups = {blunt=3},
})

minetest.register_node("level0:light", {
description = S("Block Light"),
tiles = {"level0_ceiling_light.png"},
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

minetest.register_abm({
    label = "Moss Cluster Growth",

    nodenames = {"group:moss_cluster"},

    neighbors = {"group:can_have_moss_cluster"},

    interval = 12.0,

    chance = 10,

    action = function(pos, node)
        local positions, nodes_count = minetest.find_nodes_in_area(
		vector.add(pos, -1), vector.add(pos, 1), {"group:can_have_moss_bit"})
        local poz = positions[math.random(1,#positions)]
        local node_id = minetest.get_node(poz).name
        minetest.set_node(poz,{name=node_id .. "_moss_bit"})
    end


})