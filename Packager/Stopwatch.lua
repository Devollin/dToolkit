--!strict
--[[======================================================================

Timer | Written by Devi (@Devollin) | 2022 | v1.0.0
	Description: A stopwatch class.
	
========================================================================]]


local RunService = game:GetService("RunService")

local Signal = require(script.Parent:WaitForChild("Signal"))


type Signal<a...> = Signal.Signal<a...>

export type Stopwatch = {
	elapsed: number,
	destroyed: boolean,
	
	Updated: Signal<number>,
	
	Start: <a>(self: a) -> boolean?,
	Stop: <a>(self: a) -> (boolean | number)?,
	Pause: <a>(self: a) -> boolean?,
	Destroy: <a>(self: a) -> boolean?,
}


local interface = {}


--[[**
Creates a new Stopwatch object.

@returns [t:Stopwatch] The new Stopwatch object.
**--]]
function interface.new(): Stopwatch
	local totalElapsed = 0
	local destroyed = false
	local connection: RBXScriptConnection?
	
	local object = {
		Updated = Signal.new() :: Signal<number>,
	}
	
	--[[**
	Starts or resumes the Stopwatch.
	**--]]
	function object:Start()
		if destroyed then
			return
		end
		
		connection = RunService.Heartbeat:Connect(function(delta)
			totalElapsed += delta
			
			object.Updated:Fire(totalElapsed)
		end)
	end
	
	--[[**
	Stops the Stopwatch, and resets the total elapsed time.
	
	@returns [t:number?] Returns nil if it fails, or the total elapsed time if it succeeds.
	**--]]
	function object:Stop(): number?
		if destroyed then
			return
		end
		
		if connection then
			connection:Disconnect()
			connection = nil
		end
		
		local elapsed = totalElapsed
		
		object.elapsed = 0
		
		return elapsed
	end
	
	--[[**
	Pauses the Stopwatch.
	**--]]
	function object:Pause()
		if destroyed then
			return
		end
		
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end
	
	--[[**
	Destroys the Stopwatch object.
	**--]]
	function object:Destroy()
		if destroyed then
			return
		end
		
		object:Stop()
		
		object.destroyed = true
		
		object.Updated:Destroy()
	end
	
	
	return object
end


return interface