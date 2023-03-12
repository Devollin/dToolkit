--!strict
--[[================================================================================================

Signal | Written by ???; Modified by Devi (@Devollin) | 2022 | v1.1.0
	Description: Lua-side duplication of the API of events on Roblox objects.
		Signals are needed for to ensure that for local events objects are passed by reference
		rather than by value where possible, as the BindableEvent objects always pass signal
		arguments by value, meaning tables will be deep copied. Roblox's deep copy method parses to
		a non-lua table compatable format.
	
==================================================================================================]]


export type SimpleSignal<a...> = {
	ClassName: "SimpleSignal",
	
	Fire: (self: SimpleSignal<a...>, a...) -> (),
	Connect: (self: SimpleSignal<a...>, (a...) -> ()) -> (RBXScriptConnection),
	Wait: (self: SimpleSignal<a...>) -> (a...),
	Destroy: (self: SimpleSignal<a...>) -> (),
}

export type InternalSimpleSignal<a...> = {
	ClassName: "SimpleSignal",
	
	Connect: (self: InternalSimpleSignal<a...>, (a...) -> ()) -> (RBXScriptConnection),
	Wait: (self: InternalSimpleSignal<a...>) -> (a...),
}


local SimpleSignal = {}


--[=[
	@class SimpleSignal
	Signal class based on BindableEvents.
	
	```lua
	local newSimpleSignal: SimpleSignal<boolean, string> = SimpleSignal.new()
	
	local newConnection = newSimpleSignal:Connect(function(foo, bar)
		if foo then
			print(bar)
		else
			print(bar:reverse())
		end
	end)
	
	newSimpleSignal:Fire(true, "boot")
	
	newConnection:Disconnect()
	```
]=]

--[=[
	Constructs a new signal.
	
	```lua
	local newSimpleSignal: SimpleSignal<boolean, string> = SimpleSignal.new()
	```
	
	@within SimpleSignal
]=]
function SimpleSignal.new<a...>(): SimpleSignal<a...>
	local event: BindableEvent = Instance.new("BindableEvent")
	local argCount: any = nil -- Prevent edge case of :Fire("A", nil) --> "A" instead of "A", nil
	local argData: any = nil
	
	local object = {ClassName = "SimpleSignal" :: "SimpleSignal"}
	
	
	--[=[
		Fire the event with the given arguments. All handlers will be invoked. Handlers follow Roblox signal conventions.
		
		```lua
		newSimpleSignal:Fire(true, "boot")
		```
		
		@param ... -- Variable arguments to pass to handler
		
		@within SimpleSignal
	]=]
	function object.Fire(self: SimpleSignal<a...>, ...: a...)
		argData = table.pack(...)
		argCount = select("#", ...)
		
		event:Fire()
		
		argData = nil
		argCount = nil
	end
	
	--[=[
		Connect a new handler to the event. Returns a connection object that can be disconnected.
		
		```lua
		local newConnection = newSimpleSignal:Connect(function(foo, bar)
			if foo then
				print(bar)
			else
				print(bar:reverse())
			end
		end)
		```
		
		@param callback -- Function handler called with arguments passed when :Fire(...) is called.
		
		@return RBXScriptConnection -- Connection object that can be disconnected.
		
		@within SimpleSignal
	]=]
	function object.Connect(self: SimpleSignal<a...>, callback: (a...) -> ()): RBXScriptConnection
		return event.Event:Connect(function()
			callback(unpack(argData, 1, argCount))
		end)
	end
	
	--[=[
		Wait for `:Fire(...)` to be called, and return the arguments it was given.
		
		```lua
		task.spawn(function()
			task.wait(5)
			
			newSimpleSignal:Fire(false, "bar")
		end)
		
		local foo, bar = newSimpleSignal:Wait()
		```
		
		@return any... -- Variable arguments from connection
		
		@within SimpleSignal
	]=]
	function object.Wait(self: SimpleSignal<a...>): (a...)
		event.Event:Wait()
		
		assert(argData, "Missing arg data, likely due to :TweenSize/Position corrupting threadrefs.")
		
		return unpack(argData, 1, argCount)
	end
	
	--[=[
		Disconnects all connected events to the signal. Voids the signal as unusable.
		
		```lua
		newSimpleSignal:Destroy()
		```
		
		@within SimpleSignal
	]=]
	function object.Destroy(self: SimpleSignal<a...>)
		table.clear(object)
		
		event:Destroy()
		event = nil :: any
		argData = nil
		argCount = nil
	end
	
	
	return object
end


return SimpleSignal