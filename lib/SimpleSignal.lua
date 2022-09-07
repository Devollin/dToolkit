--!strict
--[[================================================================================================

Signal | Written by ???; Modified by Devi (@Devollin) | 2022 | v1.0.0
	Description: Lua-side duplication of the API of events on Roblox objects.
		Signals are needed for to ensure that for local events objects are passed by reference
		rather than by value where possible, as the BindableEvent objects always pass signal
		arguments by value, meaning tables will be deep copied. Roblox's deep copy method parses to
		a non-lua table compatable format.
	
==================================================================================================]]


export type Signal<b...> = {
	Fire: <a>(self: a, b...) -> (),
	Connect: <a>(self: a, (b...) -> ()) -> (RBXScriptConnection?),
	Wait: <a>(self: a) -> (b...),
	Destroy: <a>(self: a) -> (),
}


local Signal = {}


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
function Signal.new<b...>(): Signal<b...>
	local event: BindableEvent? = Instance.new("BindableEvent")
	
	local argCount: any = nil -- Prevent edge case of :Fire("A", nil) --> "A" instead of "A", nil
	local argData: any = nil
	
	local object = {}
	
	
	--[=[
		Fire the event with the given arguments. All handlers will be invoked. Handlers follow Roblox signal conventions.
		
		```lua
		newSimpleSignal:Fire(true, "boot")
		```
		
		@param ... -- Variable arguments to pass to handler
		
		@within SimpleSignal
	]=]
	function object:Fire(...: b...)
		if event then
			argData = table.pack(...)
			argCount = select("#", ...)
			
			event:Fire()
			
			argData = nil
			argCount = nil
		end
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
		
		@return RBXScriptConnection? -- Connection object that can be disconnected.
		
		@within SimpleSignal
	]=]
	function object:Connect(callback: (b...) -> ()): RBXScriptConnection?
		if event then
			return event.Event:Connect(function()
				callback(unpack(argData, 1, argCount))
			end)
		end
		
		return
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
	function object:Wait(): (b...)
		if event then
			event.Event:Wait()
			
			assert(argData, "Missing arg data, likely due to :TweenSize/Position corrupting threadrefs.")
			
			return unpack(argData, 1, argCount)
		end
	end
	
	--[=[
		Disconnects all connected events to the signal. Voids the signal as unusable.
		
		```lua
		newSimpleSignal:Destroy()
		```
		
		@within SimpleSignal
	]=]
	function object:Destroy()
		if event then
			event:Destroy()
			
			event = nil
		end
		
		argData = nil
		argCount = nil
	end
	
	
	return object
end


return Signal