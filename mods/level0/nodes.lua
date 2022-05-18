

local S = minetest.get_translator()


--this isnt for people to add extra wallpapers its just to avoid a ton of copy and pasted code
local wallpapers = {{"level0_wallpaper.png","Arrow Wallpaper", "arrow_wallpaper"}, {"level0_wallpaper_dots.png","Dots Wallpaper", "dots_wallpaper"}, {"level0_wallpaper_lines.png","Stripes Wallpaper", "stripes_wallpaper"}}


for i=1, #wallpapers do
    minetest.register_node("level0:" .. wallpapers[i][3], {
    description = S(wallpapers[i][2]),
    tiles = {"level0_wallpaper_top.png", "level0_wallpaper_top.png", wallpapers[i][1]},
    groups = {papery=1}
    })
    minetest.register_node("level0:" .. wallpapers[i][3] .. "_moss", {
    description = S("Moss covered @1",S(wallpapers[i][2])),
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
    end
    })
    minetest.register_node("level0:trim_" .. wallpapers[i][3], {
        description = S("@1 Trim", S(wallpapers[i][2])),
        tiles = {wallpapers[i][1],wallpapers[i][1],wallpapers[i][1] .. "^level0_trim.png"},
        groups = {papery=1}
    })
end


--level0:arrow_wallpaper,level0:dots_wallpaper,level0:lines_wallpaper

minetest.register_node("level0:carpet", {
    description = S("Carpet"),
    tiles = {"level0_carpet.png"},
    groups = {soft=1}
})

minetest.register_node("level0:ceiling_tile", {
    description = S("Ceiling Tile"),
    tiles = {"level0_ceil.png"},
    groups = {blunt=3},
})

minetest.register_node("level0:light", {
description = S("Fluorescent Tube Light"),
tiles = {"level0_ceiling_light.png"},
paramtype = "light",
light_source = 12,
groups = {hand_breakable=2},
--drop = "backrooms:glass_shard 3",
on_dig = function(pos,node,player)
    player:set_hp(player:get_hp() - 2, "glass_break")
    minetest.node_dig(pos,node,player)
end
})