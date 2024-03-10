--!strict
--[[================================================================================================

Timer | Written by Devi (@Devollin) | 2023 | v2.0.1
	Description: A timer class.
	
==================================================================================================]]


local RunService: RunService = game:GetService("RunService")

local Signal = require(script.Parent:WaitForChild("Signal"))


export type Remaining = {
	remaining: number,
	elapsed: number,
}

export type Timer = {
	ClassName: "Timer",
	
	Paused: Signal.InternalSignal<nil>,
	Finished: Signal.InternalSignal<nil>,
	
	Start: (self: Timer) -> (),
	Pause: (self: Timer) -> (),
	Stop: (self: Timer) -> (),
	SetElapsed: (self: Timer, newElapsed: number) -> (),
	AddElapsed: (self: Timer, amount: number) -> (),
	IsRunning: (self: Timer) -> (boolean),
	SetDuration: (self: Timer, newDuration: number) -> (),
	GetRemaining: (self: Timer) -> (Remaining),
	Destroy: (self: Timer) -> (),
}

export type TimerWithUpdate = Timer & {Updated: Signal.Signal<Remaining>}


local timerSignal = Signal.new()

local Timer = {}

--[=[
	@class Timer
	A timer class.
	
	:::note V2.0.0
	As of v2.0.0, the Updated [Signal] is no longer a part of the default Timer class. It can be restored by using .withUpdate().
]=]
--[=[
	@prop Finished Signal<>
	Fired when the Timer finishes running.
	
	@within Timer
]=]
--[=[
	@prop Paused Signal<>
	Fired when the Timer has been paused.
	
	@within Timer
]=]
--[=[
	@prop Updated Signal<number, number>
	Fired when the Timer has been updated. The first number is the time remaining, the second is the time elapsed.
	
	:::note
	This [Signal] member is not available in the base version of [Timer]. Use .withUpdate() to implement it.
	
	@deprecated v2.0.0 -- Create your own updating method instead; removed due to a performance hit after the v2 revisions.
	@within Timer
]=]

--[=[
	@type Remaining {remaining: number, elapsed: number}
	A data type used to display how much time is remaining / has elapsed in the Timer.
	
	@within Timer
]=]

--[=[
	Creates and returns a new [Timer] object.
	
	```lua
	local newTimer = Timer.new()
	newTimer:SetDuration(5)
	
	newTimer.Finished:Connect(function()
		print("Finished!")
		
		newTimer:Start()
	end)
	
	newTimer:Start()
	```
	
	@param initDuration -- Duration applied after initializing the [Timer].
	
	@within Timer
]=]
function Timer.new(initDuration: number?): Timer
	local object = {ClassName = "Timer" :: "Timer"}
	object.Finished = (Signal.new() :: any) :: Signal.InternalSignal<nil>
	object.Paused = (Signal.new() :: any) :: Signal.InternalSignal<nil>
	
	local timerThread: thread?
	
	local duration: number
	local remainingDuration: number
	local resumeTimestamp: number
	
	local running = false
	
	
	--[=[
		Starts the [Timer].
		
		:::caution
		This will error if the [Timer] has not been given a duration yet.
		
		@within Timer
	]=]
	function object.Start(self: Timer)
		if not (duration and remainingDuration) then
			error("Duration has not been set yet! Do that before starting a timer!")
		end
		
		if running then
			return
		end
		
		running = true
		
		resumeTimestamp = time()
		
		timerThread = task.delay(remainingDuration, function()
			timerThread = nil
			running = false
			remainingDuration = duration;
			
			((object.Finished :: any) :: Signal.Signal<nil>):Fire()
		end)
	end
	
	--[=[
		Pauses the [Timer].
		@within Timer
	]=]
	function object.Pause(self: Timer)
		if not running then
			return
		end
		
		running = false
		
		if not timerThread then
			return
		end
		
		task.cancel(timerThread)
		
		timerThread = nil
		
		remainingDuration = time() - resumeTimestamp;
		
		((object.Paused :: any) :: Signal.Signal<nil>):Fire()
	end
	
	--[=[
		Stops the [Timer].
		@within Timer
	]=]
	function object.Stop(self: Timer)
		if not running then
			return
		end
		
		running = false
		
		if not timerThread then
			return
		end
		
		task.cancel(timerThread)
		
		timerThread = nil
		
		remainingDuration = duration
	end
	
	--[=[
		Returns true or false, depending on if the [Timer] is running or not.
		@within Timer
	]=]
	function object.IsRunning(self: Timer): boolean
		return running
	end
	
	--[=[
		Sets the duration of the [Timer]. Durations MUST be a positive number and not zero.
		
		:::caution
		This will error if the [Timer] is running. Utilize :IsRunning() to prevent the error from propagating.
		
		@within Timer
	]=]
	function object.SetDuration(self: Timer, newDuration: number)
		if running then
			error("You cannot set a duration of a timer while it is running!")
		end
		
		if newDuration <= 0 then
			error("You cannot use a negative number or 0 for the duration of a Timer!")
		end
		
		duration = newDuration
		remainingDuration = newDuration
	end
	
	--[=[
		Gets the duration and elapsed time of the [Timer].
		
		:::caution
		This will error if the [Timer] has not been given a duration yet.
		
		@within Timer
	]=]
	function object.GetRemaining(self: Timer): Remaining
		if not (duration and remainingDuration) then
			error("Duration has not been set! Make sure to set it before using this function.")
		end
		
		if running then
			local newRemainingDuration = time() - resumeTimestamp
			
			return {
				remaining = remainingDuration - newRemainingDuration,
				elapsed = duration - remainingDuration + newRemainingDuration,
			}
		else
			return {
				remaining = remainingDuration,
				elapsed = duration - remainingDuration,
			}
		end
	end
	
	--[=[
		Sets the elapsed time to the [Timer].
		
		:::caution
		This will error if the amount is greater than the duration or less than 0, or the duration has not been set yet.
		
		@within Timer
	]=]
	function object.SetElapsed(self: Timer, newElapsed: number)
		assert(duration, "Duration has not been set! Make sure to set it before using this function.")
		assert((newElapsed < duration) and (newElapsed >= 0), "The new elapsed time should be between 0 and the duration!")
		
		if timerThread then
			task.cancel(timerThread)
		end
		
		timerThread = nil
		
		resumeTimestamp = time()
		remainingDuration = duration - newElapsed
		
		timerThread = task.delay(remainingDuration, function()
			timerThread = nil
			running = false
			remainingDuration = duration;
			
			((object.Finished :: any) :: Signal.Signal<nil>):Fire()
		end)
	end
	
	--[=[
		Adds elapsed time to the [Timer].
		
		:::caution
		This will error if the duration has not been set yet.
		
		@within Timer
	]=]
	function object.AddElapsed(self: Timer, amount: number)
		assert(duration, "Duration has not been set! Make sure to set it before using this function.")
		
		object:SetElapsed(math.clamp(object:GetRemaining().elapsed + amount, 0, duration))
	end
	
	--[=[
		Destroys the [Timer] object.
		@within Timer
	]=]
	function object.Destroy(self: Timer)
		if (object :: any).Updated then
			(object :: any).Updated:Destroy()
		end
		
		((object.Finished :: any) :: Signal.Signal<nil>):Destroy()
		
		if timerThread then
			task.cancel(timerThread)
			
			timerThread = nil
		end
		
		table.clear(object)
	end
	
	
	if initDuration then
		object:SetDuration(initDuration)
	end
	
	
	return object
end

--[=[
	Creates and returns a new [Timer] object, with an Updated [Signal].
	
	@param initDuration -- Duration applied after initializing the [Timer].
	
	@within Timer
]=]
function Timer.withUpdate(initDuration: number?): TimerWithUpdate
	local object = Timer.new(initDuration);
	(object :: any).Updated = Signal.new() :: Signal.Signal<Remaining>
	
	
	local connection; connection = timerSignal:Connect(function()
		if not object.ClassName then
			connection:Disconnect()
			
			return
		end
		
		if object:IsRunning() then
			(object :: any).Updated:Fire(object:GetRemaining())
		end
	end)
	
	
	return object :: TimerWithUpdate
end


do
	RunService.Heartbeat:Connect(function()
		timerSignal:Fire()
	end)
end


return Timer