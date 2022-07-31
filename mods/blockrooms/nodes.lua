local S = minetest.get_translator()

minetest.register_node("blockrooms:concrete", {
    description = S("Concrete"),
    tiles = {"blockrooms_concrete.png"},
    groups = {hand_breakable=2, cracky=3},
    sounds = blockrooms.node_sound_base_custom_place({},"wood") --placeholder
})

stairs.register_stair(
    "concrete",
    "blockrooms:concrete",
    {hand_breakable=2, cracky=3},
    {"blockrooms_concrete.png"},
    S("Concrete Stairs"),
    blockrooms.node_sound_base_custom_place({},"wood"),
    false

)

stairs.register_slab(
    "concrete",
    "blockrooms:concrete",
    {hand_breakable=2, cracky=3},
    {"blockrooms_concrete.png"},
    S("Concrete Slab"),
    blockrooms.node_sound_base_custom_place({},"wood"),
    false

)


colors.foreach(function(color)
    minetest.register_node("blockrooms:concrete_" .. color.id, {
        description = S("@1 Painted Concrete",color.name),
        tiles = {"blockrooms_concrete_colorable.png^[multiply:#" .. color.rgb},
        groups = {hand_breakable=2, cracky=3},
        sounds = blockrooms.node_sound_base_custom_place({},"wood") --placeholder
    })
end)


minetest.register_node("blockrooms:concrete_wet", {
    description = S("Wet Concrete"),
    tiles = {"blockrooms_concrete.png^blockrooms_water_stain.png","blockrooms_concrete.png"},
    drop = "blockrooms:concrete",
    on_rightclick = function(pos,node,clicker,itemstack)
        if (not minetest.is_player(clicker)) then return end
        if (minetest.is_protected(pos, clicker)) then
            return
        end
        if (blockrooms.change_player_stat(clicker,"thirst",6)) then
            blockrooms.change_player_stat(clicker,"sanity",-4)
            minetest.set_node(pos, {name="blockrooms:concrete"})
		end
    end,
    groups = {soft=1},
    sounds = blockrooms.node_sound_soft({},"wood") --placeholder
})