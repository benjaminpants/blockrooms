local S = minetest.get_translator()


minetest.register_craftitem("blockrooms:glass_shard", {
    description = S("Glass Shard"),
    inventory_image = "blockrooms_glass_shard.png"
})

minetest.register_craftitem("blockrooms:paper", {
    description = S("Paper"),
    inventory_image = "blockrooms_paper.png"
})

minetest.register_craftitem("blockrooms:pin", {
    description = S("Pin"),
    inventory_image = "blockrooms_pin.png"
})

minetest.register_tool("blockrooms:pencil", {
    description = S("Pencil"),
    groups = {writing=1}, --the pencil can write, but its not permanent
    inventory_image = "blockrooms_pencil.png",
    wield_image = "blockrooms_pencil.png^[transformFY",
    _on_write = function(player,itemstack)
        itemstack:add_wear(65535 * 0.1)
        minetest.sound_play({name="blockrooms_write_pencil"}, {
            pos = player:get_pos(),
            gain = 0.4,
            max_hear_distance = 4,
            pitch = 1 + (math.random(-6,6) * 0.01)
        }, true)
        return itemstack
    end
})

minetest.register_tool("blockrooms:pen", {
    description = S("Pen"),
    groups = {writing=2}, --the pen can write and its permanent. good luck fixing typos LOSERS
    inventory_image = "blockrooms_pen.png",
    wield_image = "blockrooms_pen.png^[transformFY",
    _on_write = function(player,itemstack)
        itemstack:add_wear(65535 * 0.05)
        minetest.sound_play({name="blockrooms_write_pen"}, {
            pos = player:get_pos(),
            gain = 0.1,
            max_hear_distance = 4,
            pitch = 1 + (math.random(-6,6) * 0.01)
        }, true)
        return itemstack
    end
})

--too tired/sick rn but todo:
--move this to the nodes section...
minetest.register_node("blockrooms:pinned_paper", {
    description = S("Pinned Paper"),
    drawtype = "signlike",
    paramtype = "light",
    paramtype2 = "wallmounted",
    wield_image = "blockrooms_paper_pin_written.png",
    inventory_image = "blockrooms_paper_pin_written.png",
    selection_box = {
        type = "wallmounted",
        wall_top    = {-0.5, 0.4375, -0.5, 0.5, 0.5, 0.5},
        wall_bottom = {-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
        wall_side   = {-0.5, -0.5, -0.5, -0.4375, 0.5, 0.5},
    },
    walkable = false,
    sunlight_propagates = true,
    tiles = {"blockrooms_paper_pinned_written.png"},
    is_ground_content = false,
    sounds = blockrooms.node_sound_soft({},"paper"),
    groups = {near_instant=8},
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec", [[
            formspec_version[6]
            size[8,8]
            field[0.1,0.5;7.8,6.8;writePrompt;Note:;]
        ]])
        meta:set_int("permanent",0)
        meta:set_string("infotext", "")
    end,
    on_receive_fields = function(pos, formname, fields, sender)
        local attempted_text = fields["writePrompt"] --the text the person attempted to write
        if (attempted_text == "") then return end
        local itemName = sender:get_wielded_item():get_name()
        local registeredItem = minetest.registered_items[itemName]
        if (registeredItem ~= nil) then
            if (registeredItem.groups["writing"] == 0) or (registeredItem.groups["writing"] == nil) then --this is NOT a writing utensil..
                minetest.chat_send_player(sender:get_player_name(), S("You need a writing utensil to write on this!"))
                return
            end
            local meta = minetest.get_meta(pos)
            meta:set_string("infotext", attempted_text)
            if (registeredItem.groups["writing"] == 2) then --the markings ARE permanent.
                meta:set_int("permanent",1)
                meta:set_string("formspec","") --no more formspec
            end
            if (registeredItem._on_write ~= nil) then
                sender:set_wielded_item(registeredItem._on_write(sender,sender:get_wielded_item()))
            end
        end
    end,
    preserve_metadata = function(pos, oldnode, oldmeta, drops)
        local drop = drops[1]
        local dropMeta = drop:get_meta()
        if ((oldmeta["infotext"] == "" or oldmeta["infotext"] == nil) or (oldmeta["permanent"] == 0 or oldmeta["permanent"] == nil)) then
            return nil --nothings been changed, so don't set meta here, which would cause things to not stack.
        end
        dropMeta:set_int("permanent",oldmeta["permanent"])
        dropMeta:set_string("infotext",oldmeta["infotext"])
        dropMeta:set_string("description", S("Pinned Note\n@1",oldmeta["infotext"] or ""))
    end,
    after_place_node = function(pos, placer, itemstack, pointed_thing)
        local meta = itemstack:get_meta()
        local blockmeta = minetest.get_meta(pos)
        if (meta:get_int("permanent") == 1) then
            blockmeta:set_int("permanent",1)
            blockmeta:set_string("formspec","")
        end
        blockmeta:set_string("infotext",meta:get_string("infotext"))
    end
})

minetest.register_craft({
    type = "shapeless",
    output = "blockrooms:pinned_paper 1",
    recipe = {
        "blockrooms:paper",
        "blockrooms:pin"
    }
})

minetest.register_craftitem("blockrooms:iron_plate", {
    description = S("Iron Plate"),
    inventory_image = "blockrooms_iron_plate.png"
})

--useless unless you can melt them down

minetest.register_craftitem("blockrooms:money_penny", {
    description = S("Pennies"),
    inventory_image = "blockrooms_pennies.png"
})

minetest.register_craftitem("blockrooms:money_quarter", {
    description = S("Quarters"),
    inventory_image = "blockrooms_quarters.png"
})

minetest.register_craftitem("blockrooms:money_dollar", {
    description = S("Dollar Bill"),
    inventory_image = "blockrooms_dollar.png"
})