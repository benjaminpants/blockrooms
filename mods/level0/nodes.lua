

local S = minetest.get_translator()


--this isnt for people to add extra wallpapers its just to avoid a ton of copy and pasted code
local wallpapers = {{"level0_wallpaper.png","Arrow Wallpaper", "arrow_wallpaper"}, {"level0_wallpaper_dots.png","Dots Wallpaper", "dots_wallpaper"}, {"level0_wallpaper_lines.png","Lines Wallpaper", "lines_wallpaper"}}


for i=1, #wallpapers do
    minetest.register_node("level0:" .. wallpapers[i][3], {
    description = S(wallpapers[i][2]),
    tiles = {wallpapers[i][1]},
    groups = {papery=1}
    })
    minetest.register_node("level0:trim_" .. wallpapers[i][3], {
        description = S("@1 Trim", S(wallpapers[i][2])),
        tiles = {wallpapers[i][1],wallpapers[i][1],wallpapers[i][1] .. "^level0_trim.png"},
        groups = {papery=1}
    })
end

minetest.register_node("level0:carpet", {
    description = "Carpet",
    tiles = {"level0_carpet.png"},
    groups = {soft=1}
})

minetest.register_node("level0:ceiling_tile", {
    description = "Ceiling Tile",
    tiles = {"level0_ceil.png"},
    groups = {blunt=3},
})