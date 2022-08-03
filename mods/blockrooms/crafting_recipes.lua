minetest.register_craft({
    output = "blockrooms:sheet_metal 1",
    recipe = {
        {"blockrooms:iron_plate", "blockrooms:iron_plate","blockrooms:iron_plate"}
    }
})

minetest.register_craft({
    type = "shapeless",
    output = "blockrooms:sheet_metal_corner 4",
    recipe = {
        "blockrooms:sheet_metal",
    }
})

minetest.register_craft({
    type = "shapeless",
    output = "blockrooms:sheet_metal 1",
    recipe = {
        "blockrooms:sheet_metal_corner",
        "blockrooms:sheet_metal_corner",
        "blockrooms:sheet_metal_corner",
        "blockrooms:sheet_metal_corner"
    }
})