randomUtils = {}

randomUtils.weightedRandom = function(weightedlist) --weightedlist is a table of {value, weight} pairs
	local currentweight = 0
	local maxweight = 0
	local currentoutcome = weightedlist[1].value
	for i=1, #weightedlist do
		maxweight = maxweight + weightedlist[i].weight
	end
	currentweight = math.random(0,maxweight)
	for i=1, #weightedlist do
		if (weightedlist[i].weight > currentweight) then
			currentoutcome = weightedlist[i].value
			break
		else
			currentweight = currentweight - weightedlist[i].weight
		end
	end
	return currentoutcome
end

randomUtils.percentage = function(value)
	local yes = math.random(1,100)
	return (value >= yes)
end