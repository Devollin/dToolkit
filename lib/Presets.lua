--!strict
--[[======================================================================

Presets | Written by Devi (@Devollin) | 2022 | v1.0.0
	Description: A helper function used for managing preset lists and
	their contents.

========================================================================]]


--[[**
Reconsiles the data from modifiers into either the value of the list of index name, or data indexed as Default in list.

@param [t:{[string]:any}] list
@param [t:string?] name
@param [t:{[string]:any}] modifiers

@returns [t:{[string]:any}]
**--]]
return function(list: {[string]: any}, name: string?, modifiers: {[string]: any}): {[string]: any}
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