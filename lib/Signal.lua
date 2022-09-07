--!strict
--[[================================================================================================

Signal | Written by stravant; Modified by Devi (@Devollin) | 2022 | v1.0.0
	Description: Batched Yield-Safe Signal Implementation
		This is a Signal class which has effectively identical behavior to a normal RBXScriptSignal,
		with the only difference being a couple extra stack frames at the bottom of the stack trace
		when an error is thrown. This implementation caches runner coroutines, so the ability to
		yield in the signal handlers comes at minimal extra cost over a naive signal implementation
		that either always or never spawns a thread.
		
	Licensed under the MIT license.
	
==================================================================================================]]


export type Connection<b...> = {
	_connected: boolean,
	_callback: (b...) -> (),
	_next: Connection<b...>?,
	
	Disconnect: <a>(self: a) -> (),
}

export type Signal<b...> = {
	_handlerListHead: Connection<b...>?,
	
	Connect: <a>(self: a, callback: (b...) -> ()) -> (Connection<b...>),
	Destroy: <a>(self: a) -> (),
	Fire: <a>(self: a, b...) -> (),
	Wait: <a>(self: a) -> (b...),
	Once: <a>(self: a, callback: (b...) -> ()) -> (Connection<b...>),
}


-- The currently idle thread to run the next handler on
local freeRunnerThread = nil :: thread?

-- Function which acquires the currently idle handler runner thread, runs the
-- function fn on it, and then releases the thread, returning it to being the
-- currently idle one.
-- If there was a currently idle runner thread already, that's okay, that old
-- one will just get thrown and eventually GCed.
local function acquireRunnerThreadAndCallEventHandler(callback: (...any) -> (...any), ...: any)
	local acquiredRunnerThread = freeRunnerThread
	freeRunnerThread = nil
	
	callback(...)
	
	-- The handler finished running, this runner thread is free again.
	freeRunnerThread = acquiredRunnerThread
end

-- Coroutine runner that we create coroutines of. The coroutine can be 
-- repeatedly resumed with functions to run followed by the argument to run
-- them with.
local function runEventHandlerInFreeThread()
	-- Note: We cannot use the initial set of arguments passed to
	-- runEventHandlerInFreeThread for a call to the handler, because those
	-- arguments would stay on the stack for the duration of the thread's
	-- existence, temporarily leaking references. Without access to raw bytecode
	-- there's no way for us to clear the "..." references from the stack.
	while true do
		acquireRunnerThreadAndCallEventHandler(coroutine.yield())
	end
end

--[=[
	@class Connection
	A class used to manage connections to a [Signal].
]=]
local Connection = {}

--[=[
	Creates a new [Connection] object.
	
	@within Connection
	@ignore
]=]
function Connection.new<b...>(signal: any, callback: (b...) -> ()): Connection<b...>
	local object = {
		_connected = true,
		_callback = callback,
		_next = nil :: Connection<b...>?,
	}
	
	--[=[
		Disconnects the [Connection] object from the given [Signal]; renders it unusable.
		@within Connection
	]=]
	function object:Disconnect()
		object._connected = false
		
		-- Unhook the node, but DON'T clear it. That way any fire calls that are
		-- currently sitting on this node will be able to iterate forwards off of
		-- it, but any subsequent fire calls will not hit it, and it will be GCed
		-- when no more fire calls are sitting on it.
		if signal._handlerListHead == object then
			signal._handlerListHead = object._next
		else
			local prev = signal._handlerListHead
			
			while prev and prev._next ~= object do
				prev = prev._next
			end
			
			if prev then
				prev._next = object._next
			end
		end
	end
	
	return object
end


--[=[
	@class Signal
	A Signal class used to create custom events.
	
	```lua
	local newSignal: Signal<boolean, string> = Signal.new()
	
	local newConnection = newSignal:Connect(function(foo, bar)
		if foo then
			print(bar)
		else
			print(bar:reverse())
		end
	end)
	
	newSignal:Fire(true, "boot")
	
	newConnection:Disconnect()
	```
]=]
local Signal = {}


--[=[
	Creates a new Signal object.
	
	```lua
	local newSignal: Signal<boolean, string> = Signal.new()
	```
	
	@within Signal
]=]
function Signal.new<b...>(): Signal<b...>
	local object = {
		_handlerListHead = nil :: (Connection<b...>?),
	}
	
	--[=[
		Adds a listener for the [Signal], and returns a [Connection].
		
		```lua
		local newConnection = newSignal:Connect(function(foo, bar)
			if foo then
				print(bar)
			else
				print(bar:reverse())
			end
		end)
		```
		
		@within Signal
	]=]
	function object:Connect(callback: (b...) -> ()): Connection<b...>
		local connection = Connection.new(object, callback)
		
		if object._handlerListHead then
			connection._next = object._handlerListHead
			
			object._handlerListHead = connection
		else
			object._handlerListHead = connection
		end
		
		return connection
	end
	
	--[=[
		Disconnects every [Connection] to the [Signal].
		
		```lua
		newSignal:Destroy()
		```
		
		@within Signal
	]=]
	function object:Destroy()
		object._handlerListHead = nil
	end
	
	--[=[
		Triggers every [Connection] that is subscribed to the [Signal], passing along any parameters in the process.
		
		```lua
		newSignal:Fire(true, "boot")
		```
		
		@within Signal
	]=]
	function object:Fire(...: b...): ()
		local item = object._handlerListHead
		
		while typeof(item) == "table" do
			if item._connected then
				if not freeRunnerThread then
					freeRunnerThread = coroutine.create(runEventHandlerInFreeThread) :: thread
					
					-- Get the freeRunnerThread to the first yield
					coroutine.resume(freeRunnerThread :: any)
				end
				
				task.spawn(freeRunnerThread :: thread, item._callback, ...)
			end
			
			item = item._next
		end
	end
	
	--[=[
		Waits until the [Signal] is fired, and returns any parameters passed with it.
		
		```lua
		task.spawn(function()
			task.wait(5)
			
			newSignal:Fire(false, "bar")
		end)
		
		local foo, bar = newSignal:Wait()
		```
		
		@within Signal
		@yields
	]=]
	function object:Wait(): (b...)
		local waitingCoroutine = coroutine.running()
		local connection: Connection<b...>
		
		connection = object:Connect(function(...: b...)
			connection:Disconnect()
			
			task.spawn(waitingCoroutine, ...)
		end)
		
		return coroutine.yield()
	end
	
	--[=[
		Returns a [Connection], which will be automatically disconnected when the [Signal] is fired.
		
		```lua
		local tempConnection = newSignal:Once(function(foo, bar)
			print("i am self-destructing now!", foo, bar)
		end)
		
		newSignal:Fire(true, "boo!")
		newSignal:Fire(false, "scared them too much, oops")
		```
		
		@within Signal
	]=]
	function object:Once(callback: (b...) -> ()): Connection<b...>
		local connection: Connection<b...>
		
		connection = object:Connect(function(...: b...)
			if connection._connected then
				connection:Disconnect()
			end
			
			callback(...)
		end)
		
		return connection
	end
	
	
	return (object :: any) :: Signal<b...>
end


return Signal