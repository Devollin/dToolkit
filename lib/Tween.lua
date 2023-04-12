--!strict
--[[================================================================================================

Tween | Written by Devi (@Devollin) | 2022 | v1.0.2
	Description: A wrapper function for interfacing with TweenService.

==================================================================================================]]


type Direction = "In" | "Out" | "InOut"
type Style =
	"Linear" | "Quad" | "Cubic" | "Quart" | "Quint" | "Back" | "Sine" | "Bounce" | "Elastic" | "Exponential" | "Circular"

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
	
	T: number?,
	ES: Style?,
	ED: Direction?,
	AP: boolean?,
	D: boolean?,
	R: boolean?,
	RC: number?,
	DT: number?,
}

export type EasingStyle = Style
export type EasingDirection = Direction
export type TweenModifiersInput = ModifierInput

type Modifiers = {
	Time:            number,                -- [T] Duration of the tween.
	EasingStyle:     Enum.EasingStyle,      -- [ES] The style of the tween.
	EasingDirection: Enum.EasingDirection,  -- [ED] The direction of the tween.
	AutoPlay:        boolean,               -- [AP] Plays on creation.
	Destroy:         boolean,               -- [D] Destroys on finish.
	Reverse:         boolean,               -- [R] Reverse when completed.
	RepeatCount:     number,                -- [RC] Times to repeat; -1 is looped.
	DelayTime:       number,                -- [DT] Time between each repeat.
}

export type TweenGroup = {
	ClassName: "TweenGroup",
	tweens: {Tween},
	Completed: RBXScriptSignal,
	
	Cancel: (self: TweenGroup) -> (),
	Pause: (self: TweenGroup) -> (),
	Play: (self: TweenGroup) -> (),
	Destroy: (self: TweenGroup) -> (),
}


local TweenService: TweenService = game:GetService("TweenService")

local interface = {}


--[=[
	@type Properties {[string]: any}
	@within Tween
]=]
--[=[
	@type Direction "In" | "Out" | "InOut"
	@within Tween
]=]
--[=[
	@type Style "Linear" | "Quad" | "Cubic" | "Quart" | "Quint" | "Back" | "Sine" | "Bounce" | "Elastic" | "Exponential" | "Circular"
	@within Tween
]=]
--[=[
	@type TweenModifiersInput {Time: number?, EasingStyle: Style?, EasingDirection: Direction?, AutoPlay: boolean?, Destroy: boolean?, Reverse: boolean?, RepeatCount: number?, DelayTime: number?}
	Additionally, you can use shorthand for each parameter, based off of the capitalized letters in each member; however, the shorthand takes priority.
	Ex: Time -> T
	
	@within Tween
]=]
--[=[
	@type Method <a>(self: a) -> ()
	@within Tween
]=]
--[=[
	@type Tweens {Tween}
	@within Tween
]=]
--[=[
	@type TweenGroup {ClassName: "TweenGroup", tweens: Tweens, Completed: RBXScriptSignal, Cancel: Method, Pause: Method, Play: Method, Destroy: Method}
	@within Tween
]=]

--[=[
	@class Tween
	A library of wrapper functions for interfacing with [TweenService].
]=]

--[=[
	Tweens the properties of an object.
	
	```lua
	local part = Instance.new("Part")
	part.CFrame = CFrame.new(0, 0, 0)
	part.Anchored = true
	part.Parent = workspace

	Tween.new(part, {
		CFrame = CFrame.new(0, 5, 0),
	}, {T = 5, ES = "Exponential", ED = "InOut"}).Completed:Connect(function()
		print("Finished!")
	end)
	```
	
	@param object -- An Instance.
	@param properties -- The properties to tween.
	@param modifiers -- A dictionary of modifiers used in adjusting tween properties.
	
	@within Tween
]=]
function interface.new(object: Instance, properties: Properties, modifiers: ModifierInput?): Tween
	local final: Modifiers = {
		Time = 0.25,
		EasingStyle = Enum.EasingStyle.Quart,
		EasingDirection = Enum.EasingDirection.InOut,
		AutoPlay = true,
		Destroy = true,
		Reverse = false,
		RepeatCount = 0,
		DelayTime = 0,
	}
	
	if modifiers then
		final.Time =
			if modifiers.T then modifiers.T
			elseif modifiers.Time then modifiers.Time
			else final.Time
		
		final.EasingStyle =
			if modifiers.ES then Enum.EasingStyle[modifiers.ES]
			elseif modifiers.EasingStyle then Enum.EasingStyle[modifiers.EasingStyle]
			else final.EasingStyle
		
		final.EasingDirection =
			if modifiers.ED then Enum.EasingDirection[modifiers.ED]
			elseif modifiers.EasingDirection then Enum.EasingDirection[modifiers.EasingDirection]
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
	end
	
	local tween = TweenService:Create(object, TweenInfo.new(
		final.Time,
		final.EasingStyle,
		final.EasingDirection,
		final.RepeatCount,
		final.Reverse,
		final.DelayTime), properties)
	
	if final.AutoPlay then
		tween:Play()
	end
	
	tween.Completed:Connect(function(state)
		if (final.Destroy) or (final.Destroy and state == Enum.PlaybackState.Completed) then
			tween:Destroy()
		end
	end)
	
	tween.Parent = object
	
	return tween
end

--[=[
	Tweens the properties of multiple objects.
	
	```lua
	local part = Instance.new("Part")
	part.CFrame = CFrame.new(0, 0, 0)
	part.Anchored = true
	part.Parent = workspace
	
	local part2 = part:Clone()
	part.CFrame = CFrame.new(0, 5, 0)
	part.Parent = workspace
	
	local groupTween = Tween.fromGroup({part, part2}, {
		CFrame = CFrame.new(0, 2.5, 0),
	}, {T = 2.5, ES = "Back", ED = "Out"})
	
	task.wait(1.25)
	
	groupTween:Cancel()
	```
	
	@param objects -- An array of objects.
	@param properties -- The properties to tween.
	@param modifiers -- A dictionary of modifiers used in adjusting tween properties.
	
	@return TweenGroup -- An array of Tweens.
	
	@within Tween
]=]
function interface.fromGroup(objects: {Instance}, properties: Properties, modifiers: ModifierInput?): TweenGroup
	local tweens = {}
	
	for _, value in pairs(objects) do
		table.insert(tweens, interface.new(value, properties, modifiers))
	end
	
	
	local object = {
		ClassName = "TweenGroup" :: "TweenGroup",
	}
	object.tweens = tweens
	object.Completed = tweens[1].Completed :: RBXScriptSignal
	
	function object.Play(self: TweenGroup)
		for _, tween in tweens do
			tween:Play()
		end
	end
	
	function object.Pause(self: TweenGroup)
		for _, tween in tweens do
			tween:Pause()
		end
	end
	
	function object.Cancel(self: TweenGroup)
		for _, tween in tweens do
			tween:Cancel()
		end
	end
	
	function object.Destroy(self: TweenGroup)
		for _, tween in tweens do
			tween:Destroy()
		end
		
		table.clear(object)
	end
	
	
	return object
end


return interface