--!strict
--[[================================================================================================

Util | Written by Devi (@Devollin) | 2022 | v1.0.2
	Description: A library of helpful general-use functions.

==================================================================================================]]


local interface = {}


--[=[
	@class Util
	A library of helpful general-use functions.
]=]

--[=[
	Returns the magnitude between the two vectors.
	@within Util
	
	:::note Consistency
	a AND b must be the same data type in order for this to work properly.
]=]
function interface:GetMagnitude(a: Vector2 | Vector3, b: Vector2 | Vector3): number
	local typeA = typeof(a)
	local typeB = typeof(b)
	
	if (typeA == "Vector2") and (typeB == "Vector2") then
		return (a :: Vector2 - b :: Vector2).Magnitude
	elseif (typeA == "Vector3") and (typeB == "Vector3") then
		return (a :: Vector3 - b :: Vector3).Magnitude
	end
	
	return 0
end

--[=[
	Returns a rounded number.
	
	@param number -- The number you want to round.
	@param place -- The place value you want to round to; defaults to 0.
	
	@return number -- Returns the number rounded to the given place value or 0.
	
	@within Util
]=]
function interface:RoundNumber(number: number, place: number?): number
	local adjust = 10 ^ (place or 0)
	
	return math.ceil((number * adjust) - 0.5) / adjust
end

--[=[
	Gets the hypotenuse between a and b.
	
	@return number -- The length of the hypotenuse.
	
	@within Util
]=]
function interface:FindHypotenuse(a: number, b: number): number
	return math.sqrt((a ^ 2) + (b ^ 2))
end

--[=[
	Returns the length of the dictionary.
	@within Util
]=]
function interface:GetDictionaryLength(dictionary: {}): number
	local length = 0
	
	for _ in pairs(dictionary) do
		length += 1
	end
	
	return length
end

--[=[
	Returns a new shallow-merged table of b into a.
	@within Util
]=]
function interface:TableMerge(a: {}, b: {}): {}
	local c = {}
	
	for index, value in pairs(a) do
		c[index] = value
	end
	
	for index, value in pairs(b) do
		c[index] = value
	end
	
	return c
end

--[=[
	Returns a deep-merged table of table b into table a.
	@within Util
]=]
function interface:DeepTableMerge(a: {}, b: {}): {}
	local c = {}
	
	for index, value in pairs(a) do
		if type(value) == "table" then
			if c[index] == nil then
				c[index] = interface:DeepTableMerge({}, value)
			else
				c[index] = interface:DeepTableMerge(c[index], value)
			end
		else
			c[index] = value
		end
	end
	
	for index, value in pairs(b) do
		if type(value) == "table" then
			if c[index] == nil then
				c[index] = interface:DeepTableMerge({}, value)
			else
				c[index] = interface:DeepTableMerge(c[index], value)
			end
		else
			c[index] = value
		end
	end
	
	return c
end

--[=[
	Returns a deep-copied table of table a.
	@within Util
]=]
function interface:DeepCloneTable(a: {}): {}
	local b = {}
	
	for index, value in pairs(a) do
		if type(value) == "table" then
			b[index] = interface:DeepCloneTable(value)
		else
			b[index] = value
		end
	end
	
	return b
end

--[=[
	Returns a copy of the given array, but with its contents shuffled.
	
	@within Util
]=]
function interface:ShuffleArray<a>(array: {a}): {a}
	local length = #array
	local shuffled = {}
	
	if length == 0 or length == 1 then
		return array
	else
		for index = 1, length - 1 do
			shuffled[index] = table.remove(array, math.random(1, #array)) :: a
		end
		
		shuffled[length] = table.remove(array, 1) :: a
		
		return shuffled
	end
end

--[=[
	Returns a random value picked out from the array.
	@within Util
]=]
function interface:RandomPickFromArray<a>(array: {a}): a
	return array[math.random(1, #array)]
end

--[=[
	Creates an object or applies given properties to a given object, and returns it.
	
	@param object -- An instance, or string defining what instance to create.
	@param properties -- A dictionary of properties to apply to the instance.
	
	@return Instance Returns the given object or specified object with the properties applied to it.
	
	@within Util
]=]
function interface:Synth(object: string | Instance, properties: {[string]: any}): Instance
	local final =
		if typeof(object) == "Instance" then object
		else Instance.new(object)
	
	for name, property in pairs(properties) do
		local success, result = pcall(function()
			if name ~= "Parent" then
				final[name] = property
			end
		end)
		
		if not success then
			warn("Failed to set property of name: \"" .. property .. "\"!")
		end
	end
	
	if (final.Parent ~= game) and (properties.Parent) then
		final.Parent = properties.Parent
	end
	
	return final
end

--[=[
	Returns the given objects with the properties applied to each instance.
	
	@param properties -- A dictionary of properties to apply to the instances.
	
	@within Util
]=]
function interface:ApplyToGroup(objects: {[any]: Instance}, properties: {[string]: any})
	for _, new in pairs(objects) do
		interface:Synth(new, properties)
	end
end

--[=[
	Returns the volume of the part, or 0 if it cannot be calculated.
	
	@return number -- The volume of 'part', or 0 if there is no part.
	
	@within Util
]=]
function interface:GetVolumeOfPart(part: BasePart?): number
	if part == nil then
		return 0
	else
		local physicalProperties = part.CustomPhysicalProperties or PhysicalProperties.new(part.Material)
		
		if part.Massless or physicalProperties.Density == 0 then
			return 0
		end
		
		return part:GetMass() / physicalProperties.Density
	end
end

--[=[
	Welds a model together.
	
	@param corePart -- The part to weld every other part to.
	@param ignore -- A table of instances to ignore when welding.
	
	@within Util
]=]
function interface:Weld(model: Model, corePart: BasePart, ignore: {[any]: BasePart}?)
	local ignoreList = {}
	
	if ignore then
		for _, value in pairs(ignore) do
			if value and typeof(value) == "Instance" then
				if value:IsA("BasePart") then
					table.insert(ignoreList, value)
				end
				
				for _, descendant in pairs(value:GetDescendants()) do
					if descendant:IsA("BasePart") then
						table.insert(ignoreList, descendant)
					end
				end
			end
		end
	end
	
	for _, descendant in pairs(model:GetDescendants()) do
		if descendant:IsA("BasePart") and (descendant ~= corePart) and (not table.find(ignoreList, descendant)) then
			local weld = Instance.new("WeldConstraint")
			weld.Part0 = corePart
			weld.Part1 = descendant
			weld.Name = descendant.Name
			weld.Parent = corePart
			
			descendant.Anchored = false
		end
	end
end

--[=[
	Reconsiles the data from modifiers into either the value of the list of index name, or data indexed as Default in list.
	@within Util
]=]
function interface:Presets(list: {[string]: any}, name: string?, modifiers: {[string]: any}): {[string]: any}
	modifiers = modifiers or {}
	
	local preset = if name then list[name] else list.Default
	local result = {}
	
	for index, value in pairs(list.Default) do
		local capture = modifiers[string.gsub(index, "%l", "")]
		
		if capture ~= nil then
			result[index] = capture
		else
			if preset[index] ~= nil then
				result[index] = preset[index]
			else
				if modifiers[index] ~= nil then
					result[index] = modifiers[index]
				else
					result[index] = value
				end
			end
		end
	end
	
	return result
end


return interface