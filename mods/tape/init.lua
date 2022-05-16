
local S = minetest.get_translator()

minetest.register_craftitem("tape:tapeless_roll", {
    description = S("Empty Tape Roll"),
    inventory_image = "tape_tape_roll.png"
})


colors.foreach(function(color)

    minetest.register_craftitem("tape:tape_" .. color.id, {
        description = S("@1 Tape Piece", color.name),
        inventory_image = "tape_tape_piece.png^[multiply:#" .. color.rgb,
        groups = {tape_piece=1},
        stack_max = 16
    })

    minetest.register_node("tape:tape_cross_" .. color.id, {
        description = S("@1 Taped Cross", color.name),
        drawtype = "signlike",
        paramtype = "light",
        paramtype2 = "wallmounted",
        selection_box = {
			type = "wallmounted",
			wall_top    = {-0.5, 0.4375, -0.5, 0.5, 0.5, 0.5},
			wall_bottom = {-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
			wall_side   = {-0.5, -0.5, -0.5, -0.4375, 0.5, 0.5},
		},
        drop = "tape:tape_" .. color.id .. " 4",
        walkable = false,
        sunlight_propagates = true,
        tiles = {"tape_tape_cross.png^[multiply:#" .. color.rgb},
        is_ground_content = false,
        groups = {near_instant=1, not_in_creative_inventory=1}
        --sounds = backrooms.node_sound_defaults()
        })


    minetest.register_craftitem("tape:tape_roll_" .. color.id, {
        description = S("@1 Tape Roll", color.name),
        inventory_image = "(tape_tape_roll.png)^(tape_tape_tape.png^[multiply:#" .. color.rgb .. ")",
        groups = {tape=1},
        stack_max = 8,
        on_place = function(itemstack, placer, pointed_thing)
            local inv = placer:get_inventory()
            minetest.item_place_node(ItemStack("tape:tape_cross_" .. color.id),placer,pointed_thing)
            if (itemstack:get_count() == 1 and not inv:contains_item("main", ItemStack("tape:tapeless_roll"))) then --if there is only one roll and aren't any other already existing rolls
                return ItemStack("tape:tapeless_roll")
            else
                itemstack:take_item()
                inv:add_item("main",ItemStack("tape:tapeless_roll"))
                return itemstack
            end
        end
    })

    local piece = "tape:tape_" .. color.id
    minetest.register_craft({
        output="tape:tape_roll_" .. color.id .. " 1",
        recipe={
            {piece,"",piece},
            {"","tape:tapeless_roll",""},
            {piece,"",piece}
        }
    })


end)