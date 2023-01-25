local S = minetest.get_translator()

tubes = {}

tubes.createTile = function(tTube,tHole,type)
    if (type == "S") then
        return { 
            tTube,
            tTube,
            tTube,
            tTube,
            tHole,
            tHole
        }
    else
        return { -- Top, base, right, left, front, back
            tTube,
            tHole,
            tTube,
            tTube,
            tTube,
            tHole
	    }
    end
end

tubes.createTileData = function(tTube,tHole)
    return {
        A={
            tiles = tubes.createTile(tTube,tHole,"A"),
            drawtype = "nodebox",
            node_box = {
                type = "fixed",
                fixed = {
                    {-2/8, -4/8, -2/8,  2/8, 2/8,  2/8},
                    {-2/8, -2/8, -4/8,  2/8, 2/8, -2/8},
                },
            }
        },
        S={
            tiles = tubes.createTile(tTube,tHole,"S"),
            drawtype = "nodebox",
            node_box = {
                type = "fixed",
                fixed = {
                    {-2/8, -2/8, -4/8,  2/8, 2/8, 4/8},
                },
            }
        }
    }
end

tubes.createTubeEasy = function(tubeData,nodeData, tileDatas, id) --easily creates tubes, handles models and stuff
    local tubeDataUp = table.copy(tubeData)
    local nodeDataUp = table.copy(nodeData)

    local Tube = tubelib2.Tube:new(tubeData)

    --after dig
    if (nodeDataUp.after_dig_node ~= nil) then
        local old_afterdig = nodeDataUp.after_dig_node
        nodeDataUp.after_dig_node = function(pos, oldnode, oldmetadata, digger)
            Tube:after_dig_tube(pos, oldnode, oldmetadata)
            old_afterdig(pos, placer, itemstack, pointed_thing)
        end
    else
        nodeDataUp.after_dig_node = function(pos, oldnode, oldmetadata, digger)
            Tube:after_dig_tube(pos, oldnode, oldmetadata)
        end
    end

    nodeDataUp.sunlight_propagates = true

    nodeDataUp.paramtype2 = "facedir" -- important!
	nodeDataUp.paramtype = "light"
	nodeDataUp.use_texture_alpha = "clip"

    local nodeDataS = table.copy(nodeDataUp)

    nodeDataS.tiles = tileDatas.S.tiles
    nodeDataS.drawtype = tileDatas.S.drawtype
    if (nodeDataS.drawtype == "nodebox") then
        nodeDataS.node_box = tileDatas.S.node_box
    elseif (nodeDataS.drawtype == "mesh") then
        nodeDataS.mesh = tileDatas.S.mesh
    end

    if (nodeDataS.after_place ~= nil) then
        local old_afterplace = nodeDataS.after_place
        nodeDataS.after_place_node = function(pos, placer, itemstack, pointed_thing)
            if not Tube:after_place_tube(pos, placer, pointed_thing) then
                minetest.remove_node(pos)
                return true
            end
            return old_afterplace(pos, placer, itemstack, pointed_thing)
        end
    else
        nodeDataS.after_place_node = function(pos, placer, itemstack, pointed_thing)
            if not Tube:after_place_tube(pos, placer, pointed_thing) then
                minetest.remove_node(pos)
                return true
            end
            return false
        end
    end

    minetest.register_node(id .. "S", nodeDataS)

    local nodeDataA = table.copy(nodeDataUp)

    nodeDataA.tiles = tileDatas.A.tiles
    nodeDataA.drawtype = tileDatas.A.drawtype
    if (nodeDataA.drawtype == "nodebox") then
        nodeDataA.node_box = tileDatas.A.node_box
    elseif (nodeDataA.drawtype == "mesh") then
        nodeDataA.mesh = tileDatas.A.mesh
    end

    nodeDataA.groups["not_in_creative_inventory"] = 1

    nodeDataA.description = nodeDataA.description .. " (Corner)"

    nodeDataA.drop = nodeDataS.drop or (id .. "S")

    minetest.register_node(id .. "A", nodeDataA)
    
end

--[[Test tubes
local Tube = tubelib2.Tube:new({
    -- North, East, South, West, Down, Up
-- dirs_to_check = {1,2,3,4}, -- horizontal only
-- dirs_to_check = {5,6},  -- vertical only
dirs_to_check = {1,2,3,4,5,6},
max_tube_length = 999,
show_infotext = true,
primary_node_names = {"tubes:tubeS", "tubes:tubeA"},
secondary_node_names = {},
after_place_tube = function(pos, param2, tube_type, num_tubes, tbl)
    minetest.swap_node(pos, {name = "tubes:tube"..tube_type, param2 = param2})
end,
--debug_info = debug_info,
})

--]]

--tubelib2_tube

tubes.createTubeEasy(
    {
        -- North, East, South, West, Down, Up
    -- dirs_to_check = {1,2,3,4}, -- horizontal only
    -- dirs_to_check = {5,6},  -- vertical only
    dirs_to_check = {1,2,3,4,5,6},
    max_tube_length = math.huge,
    show_infotext = true,
    secondary_node_names = {},
    after_place_tube = function(pos, param2, tube_type, num_tubes, tbl)
        minetest.swap_node(pos, {name = "tubes:test_tube" .. tube_type, param2 = param2})
    end,
    primary_node_names = {"tubes:test_tubeS", "tubes:test_tubeA"}
    --debug_info = debug_info,
    },
    {
        description = "TUBULAR",
        groups = {}
    },
    tubes.createTileData("tubelib2_tube.png","tubelib2_hole.png"),
    "tubes:test_tube"
)