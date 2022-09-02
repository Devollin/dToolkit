--!strict
--[[================================================================================================

Tween | Written by Devi (@Devollin) | 2022 | v1.0.0
	Description: A wrapper function for interfacing with TweenService.

==================================================================================================]]


type Direction = "In" | "Out" | "InOut"
type Style =
	"Linear" | "Quad" | "Cubic" | "Quart" | "Quint" | "Back" | "Sine" | "Bounce" | "Elastic" | "Exponential" | "Circular"

type Properties = {[string]: any}
type ModifierInput = {
	Time: number?,
	EasingStyle: Style,
	EasingDirection: Direction,
	AutoPlay: boolean?,
	Destroy: boolean?,
	Reverse: boolean?,
	RepeatCount: number?,
	DelayTime: number?,
	
	T: number?,
	ES: Style,
	ED: Direction,
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

export type TweenModifiers = Modifiers

type Tweens = {Tween}

export type TweenGroup = {
	tweens: Tweens,
	Completed: RBXScriptSignal,
	
	Cancel: <a>(self: a) -> (),
	Pause: <a>(self: a) -> (),
	Play: <a>(self: a) -> (),
	Destroy: <a>(self: a) -> (),
}


local TweenService = game:GetService("TweenService")

local default: Modifiers = {
	Time = 0.25,
	EasingStyle = Enum.EasingStyle.Quart,
	EasingDirection = Enum.EasingDirection.InOut,
	AutoPlay = true,
	Destroy = true,
	Reverse = false,
	RepeatCount = 0,
	DelayTime = 0,
}

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
	@type ModifierInput {Time: number?, EasingStyle: Style?, EasingDirection: Direction?, AutoPlay: boolean?, Destroy: boolean?, Reverse: boolean?, RepeatCount: number?, DelayTime: number?}
	Additionally, you can use shorthand for each parameter, based off of the capitalized letters in each member.
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
	@type TweenGroup {tweens: Tweens, Completed: RBXScriptSignal, Cancel: Method, Pause: Method, Play: Method, Destroy: Method}
	@within Tween
]=]

--[=[
	@class Tween
	A library of wrapper functions for interfacing with [TweenService].
]=]

--[=[
	Tweens the properties of an object.
	
	@param object -- An Instance.
	@param properties -- The properties to tween.
	@param modifiers -- A dictionary of modifiers used in adjusting tween properties.
	
	@within Tween
]=]
function interface.new(object: Instance, properties: Properties, modifiers: ModifierInput?): Tween
	local final: Modifiers = table.clone(default)
	
	if modifiers ~= nil then
		for index, value in pairs(default) do
			local lower = string.gsub(index, "%l", "")
			local capture = modifiers[lower]
			
			if capture ~= nil then
				if typeof(capture) == "string" then
					if lower == "ES" then
						final[index] = Enum.EasingStyle[capture]
					elseif lower == "ED" then
						final[index] = Enum.EasingDirection[capture]
					else
						final[index] = capture
					end
				else
					final[index] = capture
				end
			else
				if modifiers[index] ~= nil then
					if typeof(modifiers[index]) == "string" then
						if index == "EasingStyle" then
							final[index] = Enum.EasingStyle[modifiers[index]]
						elseif index == "EasingDirection" then
							final[index] = Enum.EasingDirection[modifiers[index]]
						else
							final[index] = modifiers[index]
						end
					else
						final[index] = modifiers[index]
					end
				else
					final[index] = value
				end
			end
		end
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
		if (final.Destroy) or (final.Destroy and state == Enum.TweenStatus.Completed) then
			tween:Destroy()
		end
	end)
	
	tween.Parent = object
	
	return tween
end

--[=[
	Tweens the properties of multiple objects.
	
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
		tweens = tweens,
		Completed = tweens[1].Completed :: RBXScriptSignal,
	}
	
	function object:Play()
		for _, tween in ipairs(tweens) do
			tween:Play()
		end
	end
	
	function object:Pause()
		for _, tween in ipairs(tweens) do
			tween:Pause()
		end
	end
	
	function object:Cancel()
		for _, tween in ipairs(tweens) do
			tween:Cancel()
		end
	end
	
	function object:Destroy()
		for _, tween in ipairs(tweens) do
			tween:Destroy()
		end
		
		table.clear(object)
	end
	
	return object
end


return interface