# Schematic Editor [`schemedit`]

## Version
1.4.3

## Description
This is a mod which allows you to edit and export schematics (`.mts` files).

This mod works in Minetest 5.0.0 or later, but recommended is version 5.1.0
or later.

It supports node probabilities, forced node placement and slice probabilities.

It adds 3 items:

* Schematic Creator: Used to mark a region and export or import it as schematic
* Schematic Void: Marks a position in a schematic which should not replace anything when placed as a schematic
* Schematic Node Probability Tool: Set per-node probabilities and forced node placement

Note: The import feature requires Minetest 5.1.0 or later.

It also adds these server commands:

* `placeschem` to place a schematic
* `mts2lua` to convert .mts files to .lua files (Lua code)

There's also a setting `schemedit_export_lua` to enable automatic export to .lua files.

## Usage help
This mod assumes you already have a basic understanding about how schematics in Minetest work.
If not, refer to the Minetest Lua API documentation to understand more about schematics.

To learn how to use all the items in this mod, read `USAGE.md`.

You can also find the same help texts in-game if you if you use the optional Help modpack
(mods `doc` and `doc_items`).

## License of everything
MIT License
