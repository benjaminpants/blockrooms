-- This file adds a command for generating the schemedit usage help readme
-- file, in Markdown format. The text is extracted from the metadata of
-- the items. This is only used for development purposes, after the
-- help text of any of the items was changed.

-- How to use: Temporarily set MAKE_README to true in init.lua, then
-- start the game as admin and run “/make_schemedit_readme”. Copy the
-- generated file back to the mod directory (USAGE.md).

-- Everything here is intentionally NOT translated because it is for text
-- files only.


-- Extract text from item definition
local get_text = function(item, field)
	local text = minetest.registered_items[item][field]

	-- Remove translation escapes
	text = string.gsub(text, "\x1BE", "")
	text = string.gsub(text, "\x1B%(T@schemedit%)", "")

	-- Fix Markdown syntax error
	text = string.gsub(text, "schematic_override", "`schematic_override`")
	return text
end


-- Schemedit items to generate the readme from
local items = { "creator", "probtool", "void" }

minetest.register_chatcommand("make_schemedit_readme", {
	description = "Generate the schemedit usage help readme file",
	privs = {server=true},
	func = function(name, param)

		local readme = "## Usage help".."\n"
		readme = readme .. "In this section you'll learn how to use the items of this mod.".."\n"
		readme = readme .. "Note: If you have the `doc` and `doc_items` mods installed, you can also access the same help texts in-game (possibly translated).".."\n\n"

		local entries = {}
		for i=1, #items do
			local item = items[i]
			local desc = get_text("schemedit:"..item, "description")
			local longdesc = get_text("schemedit:"..item, "_doc_items_longdesc")
			local usagehelp = get_text("schemedit:"..item, "_doc_items_usagehelp")

			readme = readme .. "### "..desc.."\n"
			readme = readme .. longdesc .."\n\n"
			readme = readme .. "#### Usage\n"
			readme = readme .. usagehelp
			if i < #items then
				readme = readme .. "\n\n\n"
			end
		end

		local path = minetest.get_worldpath().."/schemedit_readme.md"
		local file = io.open(path, "w")
		if not file then
			return false, "Failed to open file!"
		end
		local ok = file:write(readme)
		file:close()
		if ok then
			return true, "File written to: "..path
		else 
			return false, "Failed to write file!"
		end
	end
})
