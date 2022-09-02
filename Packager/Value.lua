--!strict
--[[======================================================================

Value | Written by Devi (@Devollin) | 2022 | v1.0.0
	Description: Interface for creating custom values with changed events.
	
========================================================================]]


local Signal = require(script.Parent:WaitForChild("Signal"))


type Signal<b...> = Signal.Signal<b...>

export type Value<b...> = {
	WillChange: Signal<b...>,
	Changed: Signal<b...>,
	
	Set: <a>(self: a, b...) -> (),
	Get: <a>(self: a) -> (b...),
	Clone: <a>(self: a) -> (Value<b...>),
	Destroy: <a>(self: a) -> (),
}


local Value = {}


--[[**
Creates a new Value object.

@param [t:any] ... The initial values you want to store in the new Value object.

@returns [t:Value] The new Value object.
**--]]
function Value.new<b...>(...: b...): Value<b...>
	local deleted = false
	local value: any = table.pack(...)
	
	local object = {
		WillChange = Signal.new() :: Signal<b...>,
		Changed = Signal.new() :: Signal<b...>,
	}
	
	
	--[[**
	Updates the value(s) inside the Value object.
	
	@param [t:any] ... The new values you want to input.
	**--]]
	function object:Set(...: b...)
		if not deleted then
			object.WillChange:Fire(object:Get())
			
			value = table.pack(...)
			
			object.Changed:Fire(...)
		end
	end
	
	--[[**
	Returns all values inside of the Value object.
	
	@returns [t:any] ... All the values inside of the Value object.
	**--]]
	function object:Get(): (b...)
		if not deleted then
			return table.unpack(value)
		end
	end
	
	--[[**
	Returns a new Value object with the same values as the original.
	
	@returns [t:Value] The cloned Value object.
	**--]]
	function object:Clone(): Value<b...>
		return Value.new(table.unpack(value))
	end
	
	--[[**
	Destroys the Value object and makes it unusable.
	**--]]
	function object:Destroy()
		if deleted then
			return
		end
		
		deleted = true
		
		object.WillChange:Destroy()
		object.Changed:Destroy()
	end
	
	
	return object
end


return Value