loot_tables = {}

loot_tables.LootTables = {}

loot_tables.AddLootTable = function(id,data)
    local dat = table.copy(data)
    loot_tables.LootTables[id] = dat
end

loot_tables.FillInventory = function(invref, table_id)
    local tab = loot_tables.LootTables[table_id]
    local size = invref:get_size("main")
    local available_slots = {}
    for i=1, size do
        table.insert(available_slots,i)
    end

    local attempted_max_items = math.min(math.random(tab.max_items_range.min,tab.max_items_range.max),size) --how many items to attempt to put in the inventory

    local i = 0

    local retries = 0

    local instanceCount = {}

    while ((i < attempted_max_items) and not (retries > 200)) do
        i = i + 1
        if (#available_slots == 1) then --are we about to run out of available slots? if so, set i to be the biggest value so this is the last iteration
            i = attempted_max_items
        end
        local curItem = randomUtils.weightedRandom(tab.data)
        local curItemName = curItem.name
        curItemNameForMaxAmount = curItem.name
        if (curItem.overrideFunc ~= nil) then --if there is an override function, run it
            curItem = curItem.overrideFunc()
            curItemName = curItem.name
        end

        if (instanceCount[curItemNameForMaxAmount] ~= nil) then --if item count is not defined, set it to one, otherwise, increment it by one
            instanceCount[curItemNameForMaxAmount] = instanceCount[curItemNameForMaxAmount] + 1
        else
            instanceCount[curItemNameForMaxAmount] = 1
        end
        if (instanceCount[curItemNameForMaxAmount] > curItem.max_duplicates) then --if we've reached the cap for this entry
            i = i - 1 --retry
            instanceCount[curItemNameForMaxAmount] = instanceCount[curItemNameForMaxAmount] - 1
            retries = retries + 1
        else
            local curItemAmount = math.random(curItem.item_range.min,curItem.item_range.max)
            local stack = ItemStack(curItemName)
            stack:set_count(curItemAmount)
            invref:set_stack("main",table.remove(available_slots,math.random(1,#available_slots)),stack) --add it to the inv
        end
    end
end

loot_tables.exampleLootTable = {
    max_items_range = {min = 1, max = 4}, --the range of items that can be in this loot table
    data = {
        {value={
            overrideFunc = nil, --its set to nil here, but its a function that returns a value(the value itself, so dont do value={}), allowing you to do whatever you want. each item is stored using the same max_duplicates index
            name="blockrooms:rock", --the actual item
            item_range = {min = 1, max = 3}, --the potential count of said item
            max_duplicates = 4 --the max amount of duplicates
            --the total number of potential items is item_range.max * max_duplicates
        },
        weight=10}
    }
}


loot_tables.AddLootTable("example",loot_tables.exampleLootTable)