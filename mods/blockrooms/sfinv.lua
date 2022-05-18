local formspec = {"label[0.3,0.5;Welcome to the Backrooms!]","label[0.3,1.1;This area is a placeholder, but eventually it will contain information about\n the current floor you're on.]"}


sfinv.register_page("blockrooms:guide", {
    title = "Guide",
    get = function(self, player, context)
        return sfinv.make_formspec(player, context,
                formspec[1] .. "\n" .. formspec[2], true)
    end
})