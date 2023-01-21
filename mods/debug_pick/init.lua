local S = minetest.get_translator()

minetest.register_tool("debug_pick:pick", {
    description = S("Debug Pick"),
	inventory_image = "debug_pick_the_funny_pick.png",
	wield_scale = {x=1,y=1,z=1},
	tool_capabilities = {
		full_punch_interval = 0.1,
		max_drop_level = 3,
		groupcaps = {
			debug_pick = {times={[3]=1}, uses=0, maxlevel=3}
		},
		damage_groups = {fleshy=9999},
	}
})

minetest.register_on_mods_loaded(function()
    for i, thing in pairs(minetest.registered_nodes) do
		if (thing.groups) then
            local group_clone = thing.groups --is this necessary?
            group_clone["debug_pick"] = 3
			minetest.override_item(i, {groups = group_clone})
		end
	end
end)