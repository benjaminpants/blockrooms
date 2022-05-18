sfinv.register_page("blockrooms:hello", {
    title = "Hello!",
    get = function(self, player, context)
        return sfinv.make_formspec(player, context,
                "list[current_player;armor;0,0;3,4;]", true)
    end
})