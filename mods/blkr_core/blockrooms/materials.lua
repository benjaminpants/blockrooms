local S = minetest.get_translator()


minetest.register_craftitem("blockrooms:glass_shard", {
    description = S("Glass Shard"),
    inventory_image = "blockrooms_glass_shard.png"
})

minetest.register_craftitem("blockrooms:paper", {
    description = S("Paper"),
    inventory_image = "blockrooms_paper.png"
})

minetest.register_craftitem("blockrooms:iron_plate", {
    description = S("Iron Plate"),
    inventory_image = "blockrooms_iron_plate.png"
})

--useless unless you can melt them down

minetest.register_craftitem("blockrooms:money_penny", {
    description = S("Pennies"),
    inventory_image = "blockrooms_pennies.png"
})

minetest.register_craftitem("blockrooms:money_quarter", {
    description = S("Quarters"),
    inventory_image = "blockrooms_quarters.png"
})

minetest.register_craftitem("blockrooms:money_dollar", {
    description = S("Dollar Bill"),
    inventory_image = "blockrooms_dollar.png"
})