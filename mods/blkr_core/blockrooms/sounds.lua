function blockrooms.node_sound_base(table,type)
	table = table or {}
	table.footstep = table.footstep or
			{name = "blockrooms_footstep_" .. type, gain = 0.25}
    table.dig = table.dig or
        {name = "blockrooms_dig_" .. type, gain = 0.5}
	table.dug = table.dug or
			{name = "blockrooms_dig_" .. type, gain = 1.0}
	table.place = table.place or
			{name = "blockrooms_dig_" .. type, gain = 0.9}
	return table
end

function blockrooms.node_sound_base_shatter(table,type)
	table = table or {}
	table.footstep = table.footstep or
			{name = "blockrooms_footstep_" .. type, gain = 0.25}
    table.dig = table.dig or
        {name = "blockrooms_dig_" .. type, gain = 0.5}
	table.dug = table.dug or
			{name = "blockrooms_dug_" .. type, gain = 1.0}
	table.place = table.place or
			{name = "blockrooms_dig_" .. type, gain = 0.9}
	return table
end

function blockrooms.node_sound_soft(table,type)
	table = table or {}
	table.footstep = table.footstep or
			{name = "blockrooms_footstep_" .. type, gain = 0.06}
    table.dig = table.dig or
        {name = "blockrooms_dig_" .. type, gain = 0.3}
	table.dug = table.dug or
			{name = "blockrooms_dig_" .. type, gain = 0.7}
	table.place = table.place or
			{name = "blockrooms_dig_" .. type, gain = 0.6}
	return table
end

function blockrooms.node_sound_base_custom_place(table,type)
	table = table or {}
	table.footstep = table.footstep or
			{name = "blockrooms_footstep_" .. type, gain = 0.25}
    table.dig = table.dig or
        {name = "blockrooms_dig_" .. type, gain = 0.5}
	table.dug = table.dug or
			{name = "blockrooms_dig_" .. type, gain = 1.0}
	table.place = table.place or
			{name = "blockrooms_place_" .. type, gain = 0.9}
	return table
end