local S = minetest.get_translator()

minetest.register_node("blockrooms:concrete", {
    description = S("Concrete"),
    tiles = {"blockrooms_concrete.png"},
    groups = {cracky=3},
    sounds = blockrooms.node_sound_base_custom_place({},"wood") --placeholder
})

minetest.register_node("blockrooms:rock", {
    description = S("Rock"),
    tiles = {"blockrooms_rock.png"},
    groups = {cracky=3},
    sounds = blockrooms.node_sound_base_custom_place({},"wood") --placeholder
})

minetest.register_node("blockrooms:sheet_metal", {
    description = S("Sheet Metal"),
    tiles = {"blockrooms_fan_metal.png"},
    drawtype = "nodebox",
    groups = {metal=3},
    paramtype = "light",
    paramtype2 = "facedir",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5000, -0.5000, 0.3750, -0.3750, 0.5000, 0.4375},
            {-0.3750, -0.5000, 0.4375, -0.2500, 0.5000, 0.5000},
            {-0.2500, -0.5000, 0.3750, -0.1250, 0.5000, 0.4375},
            {-0.1250, -0.5000, 0.4375, 0.000, 0.5000, 0.5000},
            {0.000, -0.5000, 0.3750, 0.1250, 0.5000, 0.4375},
            {0.1250, -0.5000, 0.4375, 0.2500, 0.5000, 0.5000},
            {0.2500, -0.5000, 0.3750, 0.3750, 0.5000, 0.4375},
            {0.3750, -0.5000, 0.4375, 0.5000, 0.5000, 0.5000}
        }
    },
    sounds = blockrooms.node_sound_base({},"tin")
})

minetest.register_node("blockrooms:sheet_metal_corner", {
    description = S("Sheet Metal Corner"),
    tiles = {"blockrooms_fan_metal.png"},
    drawtype = "nodebox",
    groups = {metal=3},
    paramtype = "light",
    paramtype2 = "facedir",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5000, -0.5000, -0.5000, -0.3750, 0.5000, -0.3750}
        }
    },
    sounds = blockrooms.node_sound_base({},"tin")
})

stairs.register_stair(
    "concrete",
    "blockrooms:concrete",
    minetest.registered_nodes["blockrooms:concrete"].groups,
    {"blockrooms_concrete.png"},
    S("Concrete Stairs"),
    minetest.registered_nodes["blockrooms:concrete"].sounds,
    false

)

stairs.register_slab(
    "concrete",
    "blockrooms:concrete",
    minetest.registered_nodes["blockrooms:concrete"].groups,
    {"blockrooms_concrete.png"},
    S("Concrete Slab"),
    minetest.registered_nodes["blockrooms:concrete"].sounds,
    false

)


colors.foreach(function(color)
    minetest.register_node("blockrooms:concrete_" .. color.id, {
        description = S("@1 Painted Concrete",color.name),
        tiles = {"blockrooms_concrete_colorable.png^[multiply:#" .. color.rgb},
        groups = minetest.registered_nodes["blockrooms:concrete"].groups,
        sounds = minetest.registered_nodes["blockrooms:concrete"].sounds
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
    groups = minetest.registered_nodes["blockrooms:concrete"].groups,
    sounds = minetest.registered_nodes["blockrooms:concrete"].sounds
})