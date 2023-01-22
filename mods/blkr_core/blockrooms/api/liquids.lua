blockrooms.liquidsAPI = {}

local S = minetest.get_translator()

--[[
    request_textures that NEED to be implemented properly:
    flow_texture --a texture that is to be used in liquid display guages if they exist
]]


blockrooms.liquidsAPI.liquids = {}
blockrooms.liquidsAPI.liquidsList = {}

blockrooms.liquidsAPI.liquidRegisterListeners = {}

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

blockrooms.liquidsAPI.addLiquid = function(liquiddata)
    blockrooms.liquidsAPI.liquids[liquiddata.id] = liquiddata
    table.insert(blockrooms.liquidsAPI.liquidsList,liquiddata)
    blockrooms.liquidsAPI.onLiquidRegistered() --call all funcs that registered
end