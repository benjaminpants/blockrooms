colors = {}
--below defines colors, the ID does not have to be 3 characters in length but its cool to do so anyway
--if you want your server to be cool add more colors here, or don't, you probably shouldn't because each color can significantly increase the amount of items/nodes
--hey if your low on ids you can also remove colors here too
colors.colors = {
    {name="Red",id="red",rgb="FF0000"},
    {name="Green",id="grn",rgb="00FF00"},
    {name="Blue",id="blu",rgb="0000FF"},
    {name="Yellow",id="ylw",rgb="FFFF00"},
    {name="Orange",id="org",rgb="FF8000"},
    {name="Magenta",id="mag",rgb="FF00FF"},
    {name="Purple",id="prp",rgb="8000FF"},
    {name="White",id="wht",rgb="FFFFFF"},
    {name="Gray",id="gry",rgb="999999"},
    {name="Black",id="blk",rgb="18181E"},
    {name="Brown",id="brn",rgb="7A4025"},
    {name="Cream",id="crm",rgb="E5B285"}
}

colors.hextorgb = function(hex) --grabbed from https://gist.github.com/jasonbradley/4357406 with minor adjustments
    return {tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))}
end

colors.chooserandom = function()
    return colors.colors[math.random(1,#colors.colors)]
end

colors.foreach = function(func)
    for i=1, #colors.colors do
        func(colors.colors[i])
    end
end