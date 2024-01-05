minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
    if (placer == nil) then return end
    if (not placer:is_player()) then return end
    blockrooms.increment_exhaustion(placer,6)


end)


minetest.register_on_dignode(function(pos, oldnode, digger)
    if (digger == nil) then return end
    if (not digger:is_player()) then return end
    blockrooms.increment_exhaustion(digger,4)

end)