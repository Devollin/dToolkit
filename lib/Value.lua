--!strict
--[[================================================================================================

Value | Written by Devi (@Devollin) | 2022 | v1.1.0
	Description: Interface for creating custom values with changed events.
	
==================================================================================================]]


local Signal = require(script.Parent:WaitForChild("Signal"))


export type Signal<a...> = Signal.Signal<a...>
export type InternalSignal<a...> = Signal.InternalSignal<a...>
export type Connection<a...> = Signal.Connection<a...>
export type InternalConnection<a...> = Signal.InternalConnection<a...>

export type Value<a...> = {
	ClassName: "Value",
	WillChange: InternalSignal<a...>,
	Changed: InternalSignal<a...>,
	
	Set: (self: Value<a...>, a...) -> (),
	Get: (self: Value<a...>) -> (a...),
	Clone: (self: Value<a...>) -> (Value<a...>),
	RawSet: (self: Value<a...>, a...) -> (),
	Destroy: (self: Value<a...>) -> (),
}

export type InternalValue<a...> = {
	ClassName: "Value",
	WillChange: InternalSignal<a...>,
	Changed: InternalSignal<a...>,
	
	Get: (self: InternalValue<a...>) -> (a...),
	Clone: (self: InternalValue<a...>) -> (Value<a...>),
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
	
	:::info
	There is an alternative type named InternalValue, which can be used for classes built using it! The primary difference
	is that InternalValue drops the :Set(), :Destroy(), and :RawSet() methods, but only from the type, not the object.
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
function Value.new<a...>(...: a...): Value<a...>
	local deleted = false
	local value: any = table.pack(...)
	
	local object = {
		ClassName = "Value" :: "Value",
	}
	object.WillChange = Signal.new() :: Signal<a...>
	object.Changed = Signal.new() :: Signal<a...>
	
	
	--[=[
		Updates the value(s) inside the Value object.
		
		```lua
		state:Set(true, false)
		```
		
		@within Value
	]=]
	function object.Set(self: Value<a...>, ...: a...)
		if not deleted then
			(object.WillChange :: any):Fire((object :: any):Get())
			
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
	function object.Get(self: Value<a...>): (a...)
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
	function object.Clone(self: Value<a...>): Value<a...>
		return Value.new(table.unpack(value)) :: any
	end
	
	--[=[
		Sets the value of the Value object without firing Changed or WillChange.
		
		@within Value
	]=]
	function object.RawSet(self: Value<a...>, ...: a...)
		value = table.pack(...)
	end
	
	--[=[
		Destroys the Value object and makes it unusable.
		
		```lua
		copiedState:Destroy()
		```
		
		@within Value
	]=]
	function object.Destroy(self: Value<a...>)
		if deleted then
			return
		end
		
		deleted = true
		
		object.WillChange:Destroy()
		object.Changed:Destroy()
	end
	
	
	return (object :: any) :: Value<a...>
end


return Value