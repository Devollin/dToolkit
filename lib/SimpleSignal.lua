--!strict
--[[======================================================================

Signal | Written by ???; Modified by Devi (@Devollin) | 2022 | v1.0.0
	Description: Lua-side duplication of the API of events on Roblox
		objects.
		Signals are needed for to ensure that for local events objects
		are passed by reference rather than by value where possible, as
		the BindableEvent objects always pass signal arguments by value,
		meaning tables will be deep copied. Roblox's deep copy method
		parses to a non-lua table compatable format.
	
========================================================================]]


export type Signal<b...> = {
	Fire: <a>(self: a, b...) -> (),
	Connect: <a>(self: a, (b...) -> ()) -> (RBXScriptConnection?),
	Wait: <a>(self: a) -> (b...),
	Destroy: <a>(self: a) -> (),
}


local Signal = {}


--[[**
Constructs a new signal.

@returns [t:Signal]
**--]]
function Signal.new<b...>(): Signal<b...>
	local event: BindableEvent? = Instance.new("BindableEvent")
	
	local argCount: any = nil -- Prevent edge case of :Fire("A", nil) --> "A" instead of "A", nil
	local argData: any = nil
	
	local object = {}
	
	--[[**
	Fire the event with the given arguments. All handlers will be invoked. Handlers follow Roblox signal conventions.
	
	@param [t:any] ... Variable arguments to pass to handler
	**--]]
	function object:Fire(...: b...)
		if event then
			argData = table.pack(...)
			argCount = select("#", ...)
			
			event:Fire()
			
			argData = nil
			argCount = nil
		end
	end
	
	--[[**
	Connect a new handler to the event. Returns a connection object that can be disconnected.
	
	@param [t:function] callback Function handler called with arguments passed when `:Fire(...)` is called.
	
	@returns [t:RBXScriptConnection?] Connection object that can be disconnected.
	**--]]
	function object:Connect(callback: (b...) -> ()): RBXScriptConnection?
		if event then
			return event.Event:Connect(function()
				callback(unpack(argData, 1, argCount))
			end)
		end
		
		return
	end
	
	--[[**
	Wait for `:Fire(...)` to be called, and return the arguments it was given.
	
	@param [t:type] name desc
	
	@returns [t:any] ... Variable arguments from connection
	**--]]
	function object:Wait(): (b...)
		if event then
			event.Event:Wait()
			
			assert(argData, "Missing arg data, likely due to :TweenSize/Position corrupting threadrefs.")
			
			return unpack(argData, 1, argCount)
		end
	end
	
	--[[**
	Disconnects all connected events to the signal. Voids the signal as unusable.
	**--]]
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