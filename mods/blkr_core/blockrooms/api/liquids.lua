blockrooms.liquidsAPI = {}

local S = minetest.get_translator()

--[[
    request_textures that NEED to be implemented properly:
    flow_texture --a texture that is to be used in liquid display guages if they exist
]]


--[[
    {
    color = "FFFFFF",
    id = "exampleLiquid",
    display_name = S("Example Liquid"),
    drinkable = true, --if this fluid is "drinkable"
    groups = {water=1},
    valid_container_groups = {any=true}, --any is a special case that allows this liquid to be in ANY container.
    minimal_mb = 25, --only needed if this liquid is drinkable. this determines the amount of MB required to get a full 1 multiplier
    on_drink = function(player,mult)
        return blockrooms.change_player_stat(player,"thirst",math.floor(8 * mult)) --return true if the drink action was performed
    end,
    request_texture = function(type, default_base) --whenever asked for a texture, this function will be called.
        return default_base .. "^[multiply:#" .. "FFFFFF"
    end
    }

]]

blockrooms.liquidsAPI.liquids = {}
blockrooms.liquidsAPI.liquidsList = {}

blockrooms.liquidsAPI.liquidRegisterListeners = {}

blockrooms.liquidsAPI.getLiquidStorage = function(item_name)
    local item = minetest.registered_items[item_name]
    return item._milibuckets or 0
end

blockrooms.liquidsAPI.onLiquidRegistered = function(func)
    if (func == nil) then
        for i=1, #blockrooms.liquidsAPI.liquidRegisterListeners do
            for j=1, #blockrooms.liquidsAPI.liquidsList do
                local liqr = blockrooms.liquidsAPI.liquidRegisterListeners[i]
                local id = blockrooms.liquidsAPI.liquidsList[j].id
                if (liqr.processed[id] ~= false) then --has this registeree already handled this liquid before? if not then run
                    liqr.func(blockrooms.liquidsAPI.liquidsList[j])
                    liqr.processed[id] = true
                end
            end
        end
    else
        local processed = {}
        table.insert(blockrooms.liquidsAPI.liquidRegisterListeners,{func=func,processed=processed})
        for i=1, #blockrooms.liquidsAPI.liquidsList do
            func(blockrooms.liquidsAPI.liquidsList[i])
            processed[blockrooms.liquidsAPI.liquidsList[i].id] = true
        end
    end
end

blockrooms.liquidsAPI.attemptDrink = function(user, liquid, totalmB)
    if (liquid.drinkable) then
        local mult = totalmB / liquid.minimal_mb
        return liquid.on_drink(user,mult)
    end
    return false
end

blockrooms.liquidsAPI.addLiquid = function(liquiddata)
    blockrooms.liquidsAPI.liquids[liquiddata.id] = liquiddata
    table.insert(blockrooms.liquidsAPI.liquidsList,liquiddata)
    blockrooms.liquidsAPI.onLiquidRegistered() --call all funcs that registered
end