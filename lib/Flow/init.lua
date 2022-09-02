--!strict
--[[================================================================================================

Flow | Written by Devi (@Devollin) | 2022 | v1.0.0
	Description: Interface for tweening.
	
==================================================================================================]]


--VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
--TODO: Clean this up / rewrite?
--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

type StepType = "Heartbeat" | "RenderStepped" | "Stepped"
type Direction = "In" | "Out" | "InOut" | "OutIn"
type Style = "Linear" | "Smooth" | "Smoother" | "RidiculousWiggle" | "ReverseBack" | "Spring" | "SoftSpring" | "Quad"
| "Cubic" | "Quart" | "Quint" | "Back" | "Sine" | "Bounce" | "Elastic" | "Exponential" | "Circular"

type Target = Instance | {[string]: any} | {Instance}
type Properties = {[string]: any}

type ModifierInput = {
	Time: number?,
	EasingStyle: Style?,
	EasingDirection: Direction?,
	AutoPlay: boolean?,
	Destroy: boolean?,
	Reverse: boolean?,
	RepeatCount: number?,
	DelayTime: number?,
	StepType: StepType?,
	
	T: number?,
	ES: Style?,
	ED: Direction?,
	AP: boolean?,
	D: boolean?,
	R: boolean?,
	RC: number?,
	DT: number?,
	ST: StepType?
}

export type FlowModifiersInput = ModifierInput

type Modifiers = {
	Time:             number,     -- [T] Duration of the flow.
	EasingStyle:      Style,      -- [ES] The style of the flow.
	EasingDirection:  Direction,  -- [ED] The direction of the flow.
	AutoPlay:         boolean,    -- [AP] Plays on creation.
	Destroy:          boolean,    -- [D] Destroys on finish.
	Reverse:          boolean,    -- [R] Reverse when completed.
	RepeatCount:      number,     -- [RC] Times to repeat; -1 is looped.
	DelayTime:        number,     -- [DT] Time between each repeat.
	StepType:         StepType,   -- [ST] Event to attach the update to.
}

export type FlowModifiers = Modifiers


local RunService = game:GetService("RunService")

local Signal = require(script.Parent:WaitForChild("Signal"))
local Util = require(script.Parent:WaitForChild("Util"))

local Styles = require(script:WaitForChild("Styles"))
local Types = require(script:WaitForChild("Types"))


export type Flow = {
	Play: <a>(self: a) -> (),
	Stop: <a>(self: a) -> (),
	Pause: <a>(self: a) -> (),
	Destroy: <a>(self: a) -> (),
	Restart: <a>(self: a) -> (),
	
	Completed: Signal.Signal<nil>,
	Stepped: Signal.Signal<nil>,
	Cancelled: Signal.Signal<nil>,
}


local Default: Modifiers = {
	Time = 0.25,
	EasingStyle = "Linear",
	EasingDirection = "Out",
	AutoPlay = true,
	Destroy = true,
	Reverse = false,
	RepeatCount = 0,
	DelayTime = 0,
	StepType = "Heartbeat",
}

local function applier(target: (Instance | {[string]: any}), property, goal: any): ((delta: number) -> ())
	local iterator = Types[typeof(goal)]
	
	local target = target :: any
	
	if typeof(target) == "Instance" then
		if target:GetAttribute(property) ~= nil then
			local init = target:GetAttribute(property)
			
			return function(delta: number)
				target:SetAttribute(property, iterator(init, goal, delta))
			end
		end
	end
	
	local init = target[property]
	
	return function(delta: number)
		target[property] = iterator(init, goal, delta)
	end
end

local Flow = {}


--[=[
	@type StepType "Heartbeat" | "RenderStepped" | "Stepped"
	@within Flow
]=]
--[=[
	@type Style = "Linear" | "Smooth" | "Smoother" | "RidiculousWiggle" | "ReverseBack" | "Spring" | "SoftSpring" | "Quad" | "Cubic" | "Quart" | "Quint" | "Back" | "Sine" | "Bounce" | "Elastic" | "Exponential" | "Circular"
	@within Flow
]=]
--[=[
	@type Direction "In" | "Out" | "InOut" | "OutIn"
	@within Flow
]=]
--[=[
	@type Properties {[string]: any}
	@within Flow
]=]
--[=[
	@type Target Instance | {[string]: any} | {Instance}
	@within Flow
]=]
--[=[
	@type ModifierInput {Time: number?, EasingStyle: Style?, EasingDirection: Direction?, AutoPlay: boolean?, Destroy: boolean?, Reverse: boolean?, RepeatCount: number?, DelayTime: number?, StepType: StepType?}
	Additionally, you can use shorthand for each parameter, based off of the capitalized letters in each member.
	Ex: Time -> T
	
	@within Flow
]=]

--[=[
	@class Flow
	Interface for tweening.
]=]

--[=[
	Creates a new Flow object.
	
	@within Flow
]=]
function Flow.new(targets: Target, goals: Properties, modifiers: ModifierInput?): Flow
	local modifiers: Modifiers = Util:Presets({Default = Default}, "Default", modifiers or {})
	local applicators: {(delta: number) -> ()} = {}
	local newTargets: {} | Instance
	local connection: RBXScriptConnection?
	
	local running = false
	local died = false
	
	if typeof(targets) == "table" then
		newTargets = table.clone(targets)
		
		for _, target in pairs(targets) do
			if typeof(target) == "Instance" then
				for _, target in pairs(targets) do
					for property, goal in pairs(goals) do
						table.insert(applicators, applier(target, property, goal))
					end
				end
			else
				for property, goal in pairs(goals) do
					table.insert(applicators, applier(targets :: any, property, goal))
				end
			end
			
			break
		end
	else
		newTargets = targets
		
		for property, goal in pairs(goals) do
			table.insert(applicators, applier(targets, property, goal))
		end
	end
	
	local style = Styles[modifiers.EasingDirection .. modifiers.EasingStyle] :: (delta: number) -> (any)
	local duration = 0
	local repeats = modifiers.RepeatCount
	local direction = 1
	
	local object = {
		Completed = Signal.new(),
		Stepped = Signal.new(),
		Cancelled = Signal.new(),
	}
	
	--[=[
		Runs the Flow.
		@within Flow
	]=]
	function object:Play()
		running = true
		connection = connection or RunService[modifiers.StepType]:Connect(function(step, deltaTime)
			local delta = deltaTime or step
			
			if not running then
				return
			end
			
			if died then
				if connection then
					connection:Disconnect()
					connection = nil
				end
				
				return
			end
			
			task.defer(function()
				duration = math.clamp(duration + delta, -modifiers.Time, modifiers.Time)
				
				if modifiers.Time <= duration then
					duration = 0
					
					object.Completed:Fire()
					
					if modifiers.Reverse then
						if direction == 1 then
							if repeats > 0 or repeats < 0 then
								repeats -= 1
							else
								running = false
								
								if connection then
									connection:Disconnect()
									connection = nil
									
									running = false
								end
								
								if modifiers.Destroy then
									object:Destroy()
								end
							end
						end
						
						direction = -1 * direction
					else
						if repeats > 0 or repeats < 0 then
							repeats -= 1
						else
							running = false
							
							if connection then
								connection:Disconnect()
								connection = nil
								
								running = false
							end
							
							if modifiers.Destroy then
								object:Destroy()
							end
						end
					end
				end
				
				for _, applicator in ipairs(applicators) do
					task.defer(function()
						if (not connection) then
							applicator(died and 1 or 0)
							
							return
						end
						
						if direction == -1 then
							applicator(style(1 - (duration / modifiers.Time)))
						else
							applicator(style(duration / modifiers.Time))
						end
					end)
				end
				
				object.Stepped:Fire()
			end)
		end)
	end
	
	--[=[
		Stops the Flow.
		@within Flow
	]=]
	function object:Stop()
		if connection then
			connection:Disconnect()
			connection = nil
			
			object.Cancelled:Fire()
		end
		
		running = false
		duration = 0
		
		if modifiers.Destroy then
			object:Destroy()
		end
	end
	
	--[=[
		Pauses the Flow.
		@within Flow
	]=]
	function object:Pause()
		running = false
		
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end
	
	--[=[
		Destroys the Flow.
		@within Flow
	]=]
	function object:Destroy()
		table.clear(applicators)
		
		if connection then
			connection:Disconnect()
			connection = nil
		end
		
		object.Completed:Destroy()
		object.Cancelled:Destroy()
		object.Stepped:Destroy()
		
		died = true
		running = false
		
		if typeof(newTargets) == "table" then
			table.clear(newTargets)
		end
	end
	
	--[=[
		Restarts the Flow.
		@within Flow
	]=]
	function object:Restart()
		if connection then
			connection:Disconnect()
			connection = nil
		end
		
		repeats = modifiers.RepeatCount
		
		object:Play()
	end
	
	
	if modifiers.AutoPlay then
		object:Play()
	end
	
	
	return object
end


return Flow