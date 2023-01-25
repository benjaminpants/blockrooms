local S = minetest.get_translator()


local almondWater = {
    color = "C6E7FF",
    id = "almondwater",
    display_name = S("Almond Water"),
    drinkable = true, --if this fluid is "drinkable"
    groups = {water=1},
    minimal_mb = 25,
    valid_container_groups = {any=true}, --any is a special case that allows this liquid to be in ANY container.
    on_drink = function(player,mult)
        return blockrooms.change_player_stat(player,"thirst",math.floor(8 * mult)) --return true if the drink action was performed
    end,
    request_texture = function(type, default_base) --whenever asked for a texture, this function will be called.
        return default_base .. "^[multiply:#" .. "C6E7FF"
    end
}

blockrooms.liquidsAPI.addLiquid(almondWater)


local normalWater = {
    color = "C6D7FF",
    id = "normalwater",
    display_name = S("Water"),
    drinkable = true, --if this fluid is "drinkable"
    groups = {water=1},
    minimal_mb = 25,
    valid_container_groups = {any=true}, --any is a special case that allows this liquid to be in ANY container.
    on_drink = function(player,mult)
        local did_drink = blockrooms.change_player_stat(player,"thirst",math.ceil(13 * mult))
        if (did_drink) then
            blockrooms.change_player_stat(player,"sanity",math.floor(5 * mult))
		end
        return did_drink
    end,
    request_texture = function(type, default_base) --whenever asked for a texture, this function will be called.
        return default_base .. "^[multiply:#" .. "C6D7FF"
    end
}

blockrooms.liquidsAPI.addLiquid(normalWater)

local cola = {
    color = "190009",
    id = "cola",
    display_name = S("Cola"),
    drinkable = true, --if this fluid is "drinkable"
    minimal_mb = 25,
    valid_container_groups = {any=true}, --any is a special case that allows this liquid to be in ANY container.
    on_drink = function(player,mult)
        local did_drink = blockrooms.change_player_stat(player,"thirst",math.ceil(4 * mult))
        if (did_drink) then
            blockrooms.change_player_stat(player,"sanity",math.floor(3 * (mult * 1.1)))
		end
        return did_drink
    end,
    request_texture = function(type, default_base) --whenever asked for a texture, this function will be called.
        return default_base .. "^[multiply:#" .. "190009"
    end
}

blockrooms.liquidsAPI.addLiquid(cola)


local dirtyAlmondWater = {
    color = "B1C8E0",
    id = "dirty_almondwater",
    display_name = S("Dirty Almond Water"),
    groups = {water=1},
    minimal_mb = 25,
    drinkable = true, --if this fluid is "drinkable"
    valid_container_groups = {any=true}, --any is a special case that allows this liquid to be in ANY container.
    on_drink = function(player,mult)
        local did_drink = blockrooms.change_player_stat(player,"thirst",math.floor(4.5 * mult))
        if (did_drink) then
            blockrooms.change_player_stat(player,"sanity",math.floor(-2 * (mult * 1.8)))
		end
        return did_drink
    end,
    request_texture = function(type, default_base) --whenever asked for a texture, this function will be called.
        if (type == "waterbottle") then
            return "blockrooms_bottle_dirty.png^[multiply:#" .. "B1C8E0"
        end
        return default_base .. "^[multiply:#" .. "B1C8E0"
    end
}

blockrooms.liquidsAPI.addLiquid(dirtyAlmondWater)

tubes.createTubeEasy(
    {
        -- North, East, South, West, Down, Up
    -- dirs_to_check = {1,2,3,4}, -- horizontal only
    -- dirs_to_check = {5,6},  -- vertical only
    dirs_to_check = {1,2,3,4,5,6},
    max_tube_length = math.huge,
    show_infotext = false,
    secondary_node_names = {},
    after_place_tube = function(pos, param2, tube_type, num_tubes, tbl)
        minetest.swap_node(pos, {name = "blockrooms:water_pipe" .. tube_type, param2 = param2})
    end,
    primary_node_names = {"blockrooms:water_pipeS", "blockrooms:water_pipeA"}
    --debug_info = debug_info,
    },
    {
        description = S("Water Pipe"),
        groups = {blunt=2},
        sounds = blockrooms.node_sound_base({},"tin")
    },
    tubes.createTileData("blockrooms_copper_pipe.png","blockrooms_copper_pipe_hole.png"),
    "blockrooms:water_pipe"
)