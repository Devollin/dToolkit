--!strict
--[[================================================================================================

Flow | Written by Devi (@Devollin) | 2022 | v1.0.2
	Description: Interface for tweening.
	
==================================================================================================]]


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


local RunService: RunService = game:GetService("RunService")

local Signal = require(script.Parent:WaitForChild("Signal"))

local Styles = require(script:WaitForChild("Styles"))
local Types = require(script:WaitForChild("Types"))


export type Flow = {
	Play: (self: Flow) -> (),
	Stop: (self: Flow) -> (),
	Pause: (self: Flow) -> (),
	Destroy: (self: Flow) -> (),
	Restart: (self: Flow) -> (),
	
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

local Flow = {}


local function Applier(target: (Instance | {[string]: any}), property: any, goal: any): ((delta: number) -> ())
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


--[=[
	@type StepType "Heartbeat" | "RenderStepped" | "Stepped"
	@within Flow
]=]
--[=[
	@type Style "Linear" | "Smooth" | "Smoother" | "RidiculousWiggle" | "ReverseBack" | "Spring" | "SoftSpring" | "Quad" | "Cubic" | "Quart" | "Quint" | "Back" | "Sine" | "Bounce" | "Elastic" | "Exponential" | "Circular"
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
	@deprecated v1.1.0 -- Flow is an older and a very underperforming customized tweening system. It may be replaced
	eventually, but for the time being, it will not be maintained.
]=]

--[=[
	Creates a new Flow object.
	
	```lua
	local array = {
		foo = 5,
		bar = Vector2.new(5, 2),
	}
	
	Flow.new(array, {
		foo = 1,
		bar = Vector2.new(2, 5),
	}, {T = 5, ES = "Exponential", ED = "InOut"}).Stepped:Connect(function()
		print(array)
	end)
	```
	
	@within Flow
]=]
function Flow.new(targets: Target, goals: Properties, modifiers: ModifierInput?): Flow
	local final: Modifiers = {
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
	
	if modifiers then
		final.Time =
			if modifiers.T then modifiers.T
			elseif modifiers.Time then modifiers.Time
			else final.Time
		
		final.EasingStyle =
			if modifiers.ES then modifiers.ES
			elseif modifiers.EasingStyle then modifiers.EasingStyle
			else final.EasingStyle
		
		final.EasingDirection =
			if modifiers.ED then modifiers.ED
			elseif modifiers.EasingDirection then modifiers.EasingDirection
			else final.EasingDirection
		
		final.AutoPlay =
			if modifiers.AP ~= nil then modifiers.AP
			elseif modifiers.AutoPlay ~= nil then modifiers.AutoPlay
			else final.AutoPlay
		
		final.Destroy =
			if modifiers.D ~= nil then modifiers.D
			elseif modifiers.Destroy ~= nil then modifiers.Destroy
			else final.Destroy
		
		final.Reverse =
			if modifiers.R ~= nil then modifiers.R
			elseif modifiers.Reverse ~= nil then modifiers.Reverse
			else final.Reverse
		
		final.RepeatCount =
			if modifiers.RC then modifiers.RC
			elseif modifiers.RepeatCount then modifiers.RepeatCount
			else final.RepeatCount
		
		final.DelayTime =
			if modifiers.DT then modifiers.DT
			elseif modifiers.DelayTime then modifiers.DelayTime
			else final.DelayTime
		
		final.StepType =
			if modifiers.ST then modifiers.ST
			elseif modifiers.StepType then modifiers.StepType
			else final.StepType
	end
	
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
						table.insert(applicators, Applier(target, property, goal))
					end
				end
			else
				for property, goal in pairs(goals) do
					table.insert(applicators, Applier(targets :: any, property, goal))
				end
			end
			
			break
		end
	else
		newTargets = targets
		
		for property, goal in pairs(goals) do
			table.insert(applicators, Applier(targets, property, goal))
		end
	end
	
	local style = Styles[final.EasingDirection .. final.EasingStyle] :: (delta: number) -> (any)
	local duration = 0
	local repeats = final.RepeatCount
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
	function object.Play(self: Flow)
		running = true
		
		local event: RBXScriptSignal =
			if final.StepType == "RenderStepped" then RunService.RenderStepped
			elseif final.StepType == "Heartbeat" then RunService.Heartbeat
			else RunService.Stepped
		
		connection = connection or event:Connect(function(step: number, deltaTime: number?)
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
				duration = math.clamp(duration + delta, -final.Time, final.Time)
				
				if final.Time <= duration then
					duration = 0
					
					self.Completed:Fire()
					
					if final.Reverse then
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
								
								if final.Destroy then
									self:Destroy()
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
							
							if final.Destroy then
								self:Destroy()
							end
						end
					end
				end
				
				for _, applicator in applicators do
					task.defer(function()
						if (not connection) then
							applicator(died and 1 or 0)
							
							return
						end
						
						if direction == -1 then
							applicator(style(1 - (duration / final.Time)))
						else
							applicator(style(duration / final.Time))
						end
					end)
				end
				
				if object.Stepped then
					object.Stepped:Fire()
				end
			end)
		end)
	end
	
	--[=[
		Stops the Flow.
		@within Flow
	]=]
	function object.Stop(self: Flow)
		if connection then
			connection:Disconnect()
			connection = nil
			
			self.Cancelled:Fire()
		end
		
		running = false
		duration = 0
		
		if final.Destroy then
			self:Destroy()
		end
	end
	
	--[=[
		Pauses the Flow.
		@within Flow
	]=]
	function object.Pause(self: Flow)
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
	function object.Destroy(self: Flow)
		table.clear(applicators)
		
		if connection then
			connection:Disconnect()
			connection = nil
		end
		
		self.Completed:Destroy()
		self.Cancelled:Destroy()
		self.Stepped:Destroy()
		
		died = true
		running = false
		
		if typeof(newTargets) == "table" then
			table.clear(newTargets)
		end
		
		table.clear(object)
	end
	
	--[=[
		Restarts the Flow.
		@within Flow
	]=]
	function object.Restart(self: Flow)
		if connection then
			connection:Disconnect()
			connection = nil
		end
		
		repeats = final.RepeatCount
		
		self:Play()
	end
	
	
	if final.AutoPlay then
		object:Play()
	end
	
	
	return object
end


return Flow