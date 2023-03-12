--!strict
--[[================================================================================================

SimpleFunction | Written by Devi (@Devollin) | 2023 | v1.0.0
	Description: Lua-side duplication of the API of BindableFunctions.
	
==================================================================================================]]


export type SimpleFunction<a..., b...> = {
	ClassName: "SimpleFunction",
	Invoke: (self: SimpleFunction<a..., b...>, a...) -> (b...),
	OnInvoke: (self: SimpleFunction<a..., b...>, callback: (a...) -> (b...)) -> (),
	Destroy: (self: SimpleFunction<a..., b...>) -> (),
}

export type InternalSimpleFunction<a..., b...> = {
	ClassName: "SimpleFunction",
	Invoke: (self: InternalSimpleFunction<a..., b...>, a...) -> (b...),
}


--[=[
	@class SimpleFunction
	A class based on BindableFunctions.
]=]
local SimpleFunction = {}


--[=[
	Constructs a new SimpleFunction.
	
	```lua
	local newSimpleFunction = SimpleFunction.new() :: SimpleFunction<string..., bool>
	```
	
	@within SimpleFunction
]=]
function SimpleFunction.new<a..., b...>(onInvoke: ((a...) -> (b...))?): SimpleFunction<a..., b...>
	local onInvoke: (a...) -> (b...) = onInvoke :: any
	
	local object = {ClassName = "SimpleFunction" :: "SimpleFunction"}
	
	--[=[
		Invokes the callback set with SimpleFunction:OnInvoke(), and returns the results.
		
		```lua
		local isMyFavorite = newSimpleFunction:Invoke("Dogs", "Cats", "Sheep", "Goats")
		```
		
		@within SimpleFunction
	]=]
	function object.Invoke(self: SimpleFunction<a..., b...>, ...: a...): (b...)
		if not onInvoke then
			error("Callback has not been set for this SimpleFunction!")
		end
		
		return onInvoke(...)
	end
	
	--[=[
		Sets the callback to be used when SimpleFunction:Invoke() is called.
		
		```lua
		newSimpleFunction:OnInvoke(function(...)
			return table.find({...}, "Cats") ~= nil
		end)
		```
		
		@within SimpleFunction
	]=]
	function object.OnInvoke(self: SimpleFunction<a..., b...>, callback: (a...) -> (b...))
		onInvoke = callback
	end
	
	--[=[
		Destroys the SimpleFunction. Voids it as unusable.
		
		```lua
		newSimpleFunction:Destroy()
		```
		
		@within SimpleFunction
	]=]
	function object.Destroy(self: SimpleFunction<a..., b...>)
		onInvoke = nil :: any
		
		table.clear(object)
	end
	
	
	return object
end


return SimpleFunction