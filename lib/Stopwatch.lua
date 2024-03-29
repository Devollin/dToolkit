--!strict
--[[================================================================================================

Stopwatch | Written by Devi (@Devollin) | 2022 | v1.1.0
	Description: A stopwatch class.
	
==================================================================================================]]


export type Stopwatch = {
	ClassName: "Stopwatch",
	
	Start: (self: Stopwatch) -> (),
	Stop: (self: Stopwatch) -> (number),
	Pause: (self: Stopwatch) -> (number?),
	GetElapsed: (self: Stopwatch) -> (number, number?),
	IsRunning: (self: Stopwatch) -> (boolean),
	Destroy: (self: Stopwatch) -> (),
}


--[=[
	@class Stopwatch
	A class that tracks time; like a stopwatch!
	
	```lua
	local newStopwatch = Stopwatch.new()
	
	local totalDelay = task.wait(math.random() * 5)
	
	print(newStopWatch:Stop())
	print(totalDelay)
	```
]=]
local Stopwatch = {}


--[=[
	Creates a new [Stopwatch] object.
	
	```lua
	local newStopwatch = Stopwatch.new()
	```
	
	@within Stopwatch
]=]
function Stopwatch.new(): Stopwatch
	local startTime = 0
	local totalElapsed = 0
	local running = false
	
	local object = {ClassName = "Stopwatch" :: "Stopwatch"}
	
	--[=[
		Starts or resumes the [Stopwatch].
		
		```lua
		newStopwatch:Start()
		```
		
		@within Stopwatch
	]=]
	function object.Start(self: Stopwatch)
		if running then
			return
		end
		
		running = true
		startTime = time()
	end
	
	--[=[
		Stops the [Stopwatch], and resets the total elapsed time. Returns the total elapsed time if it succeeds, or nil.
		
		```lua
		print("new time!!", newStopwatch:Stop())
		```
		
		@within Stopwatch
	]=]
	function object.Stop(self: Stopwatch): number
		local total = totalElapsed
		
		totalElapsed = 0
		
		if running then
			running = false
			
			return total + (time() - startTime)
		else
			return total
		end
	end
	
	--[=[
		Pauses the [Stopwatch], and returns the lap elapsed time if it can; otherwise returns nil.
		
		```lua
		print(newStopwatch:Pause())
		```
		
		@within Stopwatch
	]=]
	function object.Pause(self: Stopwatch): number?
		if running then
			running = false
			
			local lap = time() - startTime
			
			totalElapsed += lap
			
			return lap
		end
		
		return
	end
	
	--[=[
		Returns two numbers or nil; the first number is the total elapsed time, the second is the elapsed time of the lap, if
		the [Stopwatch] is running; otherwise returns nil.
		
		```lua
		task.spawn(function()
			while true do
				local total, lap = newStopwatch:GetElapsed()
				
				if total then
					if lap then
						print("Total:", total, "; Lap:", lap)
					else
						print("Total:", total)
					end
				else
					print("Stopwatch does not exist!")
				end
				
				task.wait()
			end
		end)
		```
		
		@within Stopwatch
	]=]
	function object.GetElapsed(self: Stopwatch): (number, number?)
		if running then
			return totalElapsed, time() - startTime
		else
			return totalElapsed
		end
	end
	
	--[=[
		Returns a boolean describing if the [Stopwatch] is running or not.
		
		```lua
		newStopwatch:Start()
		
		print(newStopwatch:IsRunning())
		
		task.wait(1)
		
		newStopwatch:Stop()
		
		print(newStopwatch:IsRunning())
		```
		
		@within Stopwatch
	]=]
	function object.IsRunning(self: Stopwatch): boolean
		return running
	end
	
	--[=[
		Destroys the [Stopwatch] object.
		
		```lua
		newStopwatch:Destroy()
		```
		
		@within Stopwatch
	]=]
	function object.Destroy(self: Stopwatch)
		object:Stop()
		
		table.clear(object)
	end
	
	
	return object
end


return Stopwatch