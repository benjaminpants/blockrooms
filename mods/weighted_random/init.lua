weighted_random = {}

--This must be ran before attempting to weight any object.
weighted_random.ConvertToProperWeights = function(weighted_list)
	local total_weight = 0
	for i=1, #weighted_list do
		total_weight = total_weight + weighted_list[i].weight
	end
	if (total_weight == 0) then
		error("Total Weight is 0!")
	end
	for i=1, #weighted_list do
		weighted_list[i].weight = weighted_list[i].weight / total_weight
		weighted_list[i].weight = 1 - weighted_list[i].weight
		weighted_list[i].actual_weight = weighted_list[i].weight
	end
end

weighted_random.ReturnToActual = function(weighted_list)
	for i=1, #weighted_list do
		weighted_list[i].weight = weighted_list[i].actual_weight
	end
end


weighted_random.WeightedRandom = function(weighted_list)
	local i = 1
	while i < (#weighted_list * 100) do
		local rn = math.random()
		i = i + 1
		if (i > #weighted_list) then
			i = 1
		end
		local current_item = weighted_list[i]
		if (current_item.weight > 1) then
			error("Attempted to WeightedRandom an unconverted list!")
		end
		if (current_item.weight <= 0) then
			weighted_random.ReturnToActual(weighted_list)
			return current_item.value
		else
			current_item.weight = current_item.weight - rn
		end
	end
	error("Unable to complete weighted list!")
	
end