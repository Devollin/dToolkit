--!strict
--[[================================================================================================

Timer | Written by Devi (@Devollin) | 2022 | v1.0.0
	Description: A timer class.
	
==================================================================================================]]


local RunService = game:GetService("RunService")

local Signal = require(script.Parent:WaitForChild("Signal"))


export type Timer = {
	id: string,
	
	Finished: Signal.Signal<nil>,
	Paused: Signal.Signal<nil>,
	Updated: Signal.Signal<number, number>,
	
	Start: <a>(self: a) -> (),
	Stop: <a>(self: a) -> (),
	Pause: <a>(self: a) -> (),
	IsRunning: <a>(self: a) -> (boolean),
	SetDuration: <a>(self: a, newDuration: number) -> (),
	GetDuration: <a>(self: a) -> (number),
	GetElapsed: <a>(self: a) -> (number),
	Destroy: <a>(self: a) -> (),
}


local Timer = {}


--[=[
	@class Timer
	A timer class.
]=]

--[=[
	Creates and returns a new [Timer] object.
	
	@param duration -- The duration you want to give to the [Timer]; or nil, if you need to set it dynamically.
	
	@within Timer
]=]
function Timer.new(duration: number?): Timer
	local finished = false
	local destroyed = false
	local initDuration = duration or 0
	local remaining = duration or 0
	local elapsed = 0
	local connection: RBXScriptConnection?
	
	local object = {
		Finished = Signal.new(),
		Paused = Signal.new(),
		Updated = Signal.new(),
	}
	
	object.id = tostring(object)
	
	
	--[=[
		Starts the [Timer].
		@within Timer
	]=]
	function object:Start()
		if destroyed then
			return
		end
		
		if finished then
			finished = false
			remaining = initDuration
		end
		
		connection = RunService.Heartbeat:Connect(function(delta: number)
			remaining = math.clamp(remaining - delta, 0, math.huge)
			elapsed = initDuration - remaining
			
			object.Updated:Fire(remaining, elapsed)
			
			if remaining <= 0 then
				if connection then
					connection:Disconnect()
					connection = nil
				end
				
				if remaining <= 0 then
					finished = true
					elapsed = initDuration
					
					object.Finished:Fire()
				else
					object.Paused:Fire()
				end
			end
		end)
	end
	
	--[=[
		Stops the [Timer].
		@within Timer
	]=]
	function object:Stop()
		if destroyed then
			return
		end
		
		if finished then
			return
		end
		
		if connection then
			connection:Disconnect()
			connection = nil
		end
		
		finished = true
		remaining = initDuration
		elapsed = 0
	end
	
	--[=[
		Pauses the [Timer].
		@within Timer
	]=]
	function object:Pause()
		if destroyed then
			return
		end
		
		if finished then
			return
		end
		
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end
	
	--[=[
		Returns true or false, depending on if the [Timer] is running or not.
		@within Timer
	]=]
	function object:IsRunning(): boolean
		return (connection ~= nil)
	end
	
	--[=[
		Sets the duration of the [Timer].
		@within Timer
	]=]
	function object:SetDuration(newDuration: number)
		if destroyed then
			return
		end
		
		if object:IsRunning() then
			return
		end
		
		initDuration = newDuration
		remaining = newDuration
	end
	
	--[=[
		Gets the duration of the [Timer]. Returns 0 if the duration has not been set, otherwise, returns the duration.
		@within Timer
	]=]
	function object:GetDuration(): number
		return remaining
	end
	
	--[=[
		Gets the elapsed time of the [Timer]. Returns 0 if the duration has not been set or if the [Timer] finished;
		otherwise returns the duration.
		@within Timer
	]=]
	function object:GetElapsed(): number
		return elapsed
	end
	
	--[=[
		Destroys the [Timer] object.
		@within Timer
	]=]
	function object:Destroy()
		if destroyed then
			return
		end
		
		object:Stop()
		
		destroyed = true
		
		object.Finished:Destroy()
		object.Paused:Destroy()
		object.Updated:Destroy()
	end
	
	
	return object
end


return Timer