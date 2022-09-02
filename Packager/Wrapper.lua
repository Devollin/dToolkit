--!strict
--[[======================================================================

Wrapper | Written by Algoritmi | 2020 | v1.0.0
	Description: A function used to wrap instances with custom attributes.
	
========================================================================]]


--[[**
Applies a wrapper to the given userdata.

@param [t:any] userdata The userdata to apply the wrapper to.
@param [t:{[any]:any}] attributes The array to be applied to the wrapper.

@returns [t:any] The wrapped userdata.
**--]]
return function (userdata: any, attributes: {[any]: any}): any
	local wrapper = {}
	
	for _, attribute in pairs(attributes) do
		local passthrough = {}
		
		local passthrough_FENV = setmetatable({}, {
			__index = function(t, i)
				if passthrough[i] then
					return passthrough
				elseif i == "self" then
					return wrapper
				else
					return getfenv(2)[i]
				end
			end,
			__newindex = function(t, i, v)
				passthrough[i] = v
			end
		})
		
		if typeof(attribute) == "function" then
			setfenv(attribute, passthrough_FENV :: any)
		end
	end
	
	return setmetatable(wrapper, {
		__index = function (t, i)
			local success = pcall(function()
				return userdata[i]
			end)
			
			if i == "self" then
				return userdata
			end
			
			if attributes[i] ~= nil then
				return attributes[i]
			end
			
			if success then
				return userdata[i]
			end
			
			return
		end,
		
		__newindex = function (t, i, v)
			local success = pcall(function()
				userdata[i] = v
			end)
			
			if not success then
				rawset(t, i, v)
			end
		end
	})
end