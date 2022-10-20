--!strict
--[[================================================================================================

Value | Written by Devi (@Devollin) | 2022 | v1.0.0
	Description: Interface for creating custom values with changed events.
	
==================================================================================================]]


local Signal = require(script.Parent:WaitForChild("Signal"))


type Signal<b...> = Signal.Signal<b...>

export type Value<b...> = {
	ClassName: "Value",
	WillChange: Signal<b...>,
	Changed: Signal<b...>,
	
	Set: <a>(self: a, b...) -> (),
	Get: <a>(self: a) -> (b...),
	Clone: <a>(self: a) -> (Value<b...>),
	RawSet: <a>(self: a, b...) -> (),
	Destroy: <a>(self: a) -> (),
}


--[=[
	@class Value
	An object used to store states, and trigger every [Connection] listening to its [Signal] members.
	
	```lua
	local state = Value.new(false, true)
	
	state.WillChange:Connect(function(foo, bar)
		print(foo, bar)
	end)
	
	state.Changed:Connect(function(foo, bar)
		print(foo, bar)
	end)
	
	state:Set(true, false)
	
	task.wait(1)
	
	local copiedState = state:Clone()
	
	print("These are the current states:", copiedState:Get())
	
	copiedState:Destroy()
	```
	
	:::caution String Literals
	It should be noted that for one reason or another, Value is not able to typecheck string literals properly.
]=]

--[=[
	@prop WillChange Signal<b...>
	Is fired before the value changes for [Value].
	
	```lua
	state.WillChange:Connect(function(foo, bar)
		print(foo, bar)
	end)
	```
	
	@tag Event
	@within Value
]=]
--[=[
	@prop Changed Signal<b...>
	Is fired after the value changes for [Value].
	
	```lua
	state.Changed:Connect(function(foo, bar)
		print(foo, bar)
	end)
	```
	
	@tag Event
	@within Value
]=]
local Value = {}


--[=[
	Creates a new Value object. This will also determine the types for the object, if they were not strictly given.
	
	```lua
	local state = Value.new(false, true)
	```
	
	@param ... -- The initial values you want to store in the new Value object.
	
	@within Value
]=]
function Value.new<b...>(...: b...): Value<b...>
	local deleted = false
	local value: any = table.pack(...)
	
	local object = {}
	object.ClassName = "Value"
	object.WillChange = Signal.new() :: Signal<b...>
	object.Changed = Signal.new() :: Signal<b...>
	
	
	--[=[
		Updates the value(s) inside the Value object.
		
		```lua
		state:Set(true, false)
		```
		
		@within Value
	]=]
	function object:Set(...: b...)
		if not deleted then
			object.WillChange:Fire(object:Get())
			
			value = table.pack(...)
			
			object.Changed:Fire(...)
		end
	end
	
	--[=[
		Returns all values inside of the Value object.
		
		```lua
		print(state:Get())
		```
		
		@within Value
	]=]
	function object:Get(): (b...)
		if not deleted then
			return table.unpack(value)
		end
	end
	
	--[=[
		Returns a new Value object with the same values as the original.
		
		```lua
		local copiedState = state:Clone()
		```
		
		@within Value
	]=]
	function object:Clone(): Value<b...>
		return Value.new(table.unpack(value))
	end
	
	--[=[
		Sets the value of the Value object without firing Changed or WillChange.
		
		@within Value
	]=]
	function object:RawSet(...: b...)
		value = table.pack(...)
	end
	
	--[=[
		Destroys the Value object and makes it unusable.
		
		```lua
		copiedState:Destroy()
		```
		
		@within Value
	]=]
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