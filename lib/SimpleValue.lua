--!strict
--[[================================================================================================

SimpleValue | Written by Devi (@Devollin) | 2023 | v1.0.0
	Description: Interface for creating custom values with changed events.
	
==================================================================================================]]


local Signal = require(script.Parent:WaitForChild("Signal"))


export type Signal<a> = Signal.Signal<a, a>
export type InternalSignal<a> = Signal.InternalSignal<a, a>
export type Connection<a> = Signal.Connection<a>
export type InternalConnection<a> = Signal.InternalConnection<a>

export type SimpleValue<a> = {
	ClassName: "SimpleValue",
	OnlyUpdateIfDifferent: boolean,
	Changed: InternalSignal<a>,
	
	Set: (self: SimpleValue<a>, a) -> (),
	Get: (self: SimpleValue<a>) -> (a),
	Clone: (self: SimpleValue<a>) -> (SimpleValue<a>),
	RawSet: (self: SimpleValue<a>, a) -> (),
	Destroy: (self: SimpleValue<a>) -> (),
}

export type InternalSimpleValue<a> = {
	ClassName: "SimpleValue",
	OnlyUpdateIfDifferent: boolean,
	Changed: InternalSignal<a>,
	
	Get: (self: InternalSimpleValue<a>) -> (a),
	Clone: (self: InternalSimpleValue<a>) -> (SimpleValue<a>),
}


--[=[
	@class SimpleValue
	An object used to store a single state, and trigger every [Connection] listening to its [Signal] members.
	
	```lua
	local state = SimpleValue.new(false)
	
	state.Changed:Connect(function(newValue, oldValue)
		print(newValue, oldValue)
	end)
	
	state:Set(true)
	
	task.wait(1)
	
	local copiedState = state:Clone()
	
	print("This is the current state:", copiedState:Get())
	
	copiedState:Destroy()
	```
	
	:::caution String Literals
	It should be noted that for one reason or another, SimpleValue is not able to typecheck string literals properly.
	
	:::info
	There is an alternative type named InternalSimpleValue, which can be used for classes built using it! The primary
	difference is that InternalSimpleValue drops the :Set(), :Destroy(), and :RawSet() methods, but only from the type, not
	the object.
]=]

--[=[
	@prop OnlyUpdateIfDifferent boolean
	Enabling this makes it so future attempts to use :Set() or :RawSet() are first compared to the current value; if they
	are determined to be the same value, then it will not fire the .Changed [Signal].
	
	```lua
	state.OnlyUpdateIfDifferent = true
	```
	
	@tag Event
	@within SimpleValue
]=]

--[=[
	@prop Changed Signal<a, a>
	Is fired after the value changes for [SimpleValue]. The first passed item is the new value, the second is the old value.
	
	```lua
	state.Changed:Connect(function(newValue, oldValue)
		print(newValue, oldValue)
	end)
	```
	
	@tag Event
	@within SimpleValue
]=]
local SimpleValue = {}


--[=[
	Creates a new SimpleValue object. This will also determine the types for the object, if they were not strictly given.
	
	```lua
	local state = SimpleValue.new(false)
	```
	
	@param init -- The initial value you want to store in the new SimpleValue object.
	
	@within SimpleValue
]=]
function SimpleValue.new<a>(init: a): SimpleValue<a>
	local object = {ClassName = "SimpleValue" :: "SimpleValue"}
	object.OnlyUpdateIfDifferent = false
	object.Changed = Signal.new()
	
	local value = init
	
	
	--[=[
		Updates the value inside the SimpleValue object.
		
		```lua
		state:Set(true)
		```
		
		@within SimpleValue
	]=]
	function object.Set(self: SimpleValue<a>, newValue: a)
		if (not object.OnlyUpdateIfDifferent) or (newValue ~= value) then
			local oldValue = value
			
			value = newValue
			
			object.Changed:Fire(newValue, oldValue)
		end
	end
	
	--[=[
		Returns the value of the SimpleValue object.
		
		```lua
		print(state:Get())
		```
		
		@within SimpleValue
	]=]
	function object.Get(self: SimpleValue<a>): a
		return value
	end
	
	--[=[
		Returns a new SimpleValue object with the same value as the original.
		
		```lua
		local copiedState = state:Clone()
		```
		
		@within SimpleValue
	]=]
	function object.Clone(self: SimpleValue<a>): SimpleValue<a>
		return SimpleValue.new(value)
	end
	
	--[=[
		Sets the value of the SimpleValue object without firing Changed.
		
		@within SimpleValue
	]=]
	function object.RawSet(self: SimpleValue<a>, newValue: a)
		value = newValue
	end
	
	--[=[
		Destroys the SimpleValue object and makes it unusable.
		
		```lua
		copiedState:Destroy()
		```
		
		@within SimpleValue
	]=]
	function object.Destroy(self: SimpleValue<a>)
		object.Changed:Destroy()
		
		value = nil :: any
		
		table.clear(object)
	end
	
	
	return (object :: any) :: SimpleValue<a>
end


return SimpleValue