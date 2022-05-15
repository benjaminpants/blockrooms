blockrooms.rng_utils.choosechance = function(weightedlist) --weightedlist is a table of {value, weight} pairs
	local currentweight = 0
	local maxweight = 0
	local currentoutcome = weightedlist[1][1]
	for i=1, #weightedlist do
		maxweight = maxweight + weightedlist[i][2]
	end
	currentweight = math.random(0,maxweight)
	for i=1, #weightedlist do
		if (weightedlist[i][2] > currentweight) then
			currentoutcome = weightedlist[i][1]
			break
		else
			currentweight = currentweight - weightedlist[i][2]
		end
	end
	return currentoutcome
end

blockrooms.rng_utils.percentage = function(value)
	local yes = math.random(1,100)
	return (value >= yes)
end