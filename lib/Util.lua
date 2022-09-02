--!strict
--[[======================================================================

Util | Written by Devi (@Devollin) | 2022 | v1.0.0
	Description: Library of helpful general-use functions.

========================================================================]]


local interface = {}


--[[**
Returns the magnitude between the two vectors.
Note: 'a' AND 'b' must be the same data type.

@param [t:Vector2|Vector3] a
@param [t:Vector2|Vector3] b

@returns [t:number] The magnitude between points 'a' and 'b'.
**--]]
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

--[[**
Returns a rounded number
Note: 'a' AND 'b' must be the same data type.

@param [t:number] number The number you want to round.
@param [t:number?] place The place value you want to round to; defaults to 0.

@returns [t:number] Returns the number rounded to a given place value or 0.
**--]]
function interface:RoundNumber(number: number, place: number?): number
	local adjust = 10 ^ (place or 0)
	
	return math.ceil((number * adjust) - 0.5) / adjust
end

--[[**
Gets the hypotenuse between a and b.

@param [t:number] a
@param [t:number] b

@returns [t:number] The length of the hypotenuse.
**--]]
function interface:FindHypotenuse(a: number, b: number): number
	return math.sqrt((a ^ 2) + (b ^ 2))
end

--[[**
Returns the length of 'dictionary'.

@param [t:{[any]:any}] dictionary

@returns [t:number] The length of the dictionary.
**--]]
function interface:GetDictionaryLength(dictionary: {[any]: any}): number
	local length = 0
	
	for _ in pairs(dictionary) do
		length += 1
	end
	
	return length
end

--[[**
Returns a shallow-merged table of 'b' into 'a'.

@param [t:{[any]:any}] a
@param [t:{[any]:any}] b

@returns [t: {[any]:any}] The merged table of 'a' and 'b'.
**--]]
function interface:TableMerge(a: {[any]: any}, b: {[any]: any})
	local c = {}
	
	for index, value in pairs(a) do
		c[index] = value
	end
	
	for index, value in pairs(b) do
		c[index] = value
	end
	
	return c
end

--[[**
Returns a deep-merged table of table 'b' into table 'a'.

@param [t:{[any]:any}] a
@param [t:{[any]:any}] b

@returns [t:{[any]:any}] The merged table of 'a' and 'b'.
**--]]
function interface:DeepTableMerge(a: {[any]: any}, b: {[any]: any}): {[any]: any}
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

--[[**
Returns a deep-copied table of table 'a'.

@param [t:{[any]:any}] a

@returns [t:{[any]:any}] A deep-copy of table 'a'.
**--]]
function interface:DeepCloneTable(a: {[any]: any}): {[any]: any}
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

--[[**
Returns a new, shuffled array.

@param [t:{[number]:any}] array The array (not dictionary) you want to shuffle.

@returns [t:{[number]:any}] A copy of array with its contents shuffled.
**--]]
function interface:ShuffleArray(array: {[number]: any}): {[number]: any}
	local length = #array
	local shuffled = {}
	
	if length == 0 or length == 1 then
		return array
	else
		for index = 1, length - 1 do
			shuffled[index] = table.remove(array, math.random(1, #array))
		end
		
		shuffled[length] = table.remove(array, 1)
		
		return shuffled
	end
end

--[[**
Returns a random value picked out from the array.

@param [t:{[number]:any}] array

@returns [t:any] Value picked from the array.
**--]]
function interface:RandomPickFromArray(array: {[number]: any}): any
	return array[math.random(1, #array)]
end

--[[**
Creates an object or applies given properties to a given object, and returns it.

@param [t:string|Instance] object An instance, or string defining what instance to create.
@param [t:{[string]:any}] properties A dictionary of properties to apply to the instance.

@returns [t:Instance] Returns the given object or specified object with the properties applied to it.
**--]]
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

--[[**
Returns the given objects with the properties applied to each instance.

@param [t:{[any]:Instance}] objects An table of instances.
@param [t:{[string]:any}] properties A dictionary of properties to apply to the instance.
**--]]
function interface:ApplyToGroup(objects: {[any]: Instance}, properties: {[string]: any})
	local instances = {}
	
	for _, new in pairs(objects) do
		if typeof(new) == "Instance" then
			table.insert(instances, interface:Synth(new, properties))
		end
	end
end

--[[**
Returns the volume of the part, or 1 if it cannot be calculated.

@param [t:BasePart?] part The part you want to get the volume of.

@returns [t:number] The volume of 'part', or 0 if there is no part.
**--]]
function interface:GetVolumeOfPart(part: BasePart?): number
	if part == nil then
		return 0
	else
		local physicalProperties = part.CustomPhysicalProperties or PhysicalProperties.new(part.Material)
		
		if part.Massless or physicalProperties.Density == 0 then
			return 1
		end
		
		return (part:GetMass() / physicalProperties.Density)
	end
end

--[[**
Welds a model together.

@param [t:Model] model The model to weld together.
@param [t:BasePart] corePart The part to weld every other part to.
@param [t:{[any]:BasePart}?] ignore A table of instances to ignore when welding.
**--]]
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


return interface