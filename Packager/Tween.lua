--!strict
--[[======================================================================

Tween | Written by Devi (@Devollin) | 2022 | v1.0.0
	Description: A wrapper function for interfacing with TweenService.

========================================================================]]


type Direction = "In" | "Out" | "InOut"
type Style =
	"Linear" | "Quad" | "Cubic" | "Quart" | "Quint" | "Back" | "Sine" | "Bounce" | "Elastic" | "Exponential" | "Circular"

type Objects = {Instance}
type Properties = {[string]: any}
type ModifierInput = {
	Time: number?,
	EasingStyle: (Style | Enum.EasingStyle)?,
	EasingDirection: (Direction | Enum.EasingDirection)?,
	AutoPlay: boolean?,
	Destroy: boolean?,
	Reverse: boolean?,
	RepeatCount: number?,
	DelayTime: number?,
	
	T: number?,
	ES: (Style | Enum.EasingStyle)?,
	ED: (Direction | Enum.EasingDirection)?,
	AP: boolean?,
	D: boolean?,
	R: boolean?,
	RC: number?,
	DT: number?,
}

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


function interface:Tween(object: Instance, properties: Properties, modifiers: ModifierInput?): Tween
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

function interface:GroupTween(objects: Objects, properties: Properties, modifiers: ModifierInput?): TweenGroup
	local tweens = {}
	
	for _, value in pairs(objects) do
		table.insert(tweens, interface:Tween(value, properties, modifiers))
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


--[[**
Tweens the properties of an object, or objects.

@param [t:Instance|Objects] objects An object or a table of objects.
@param [t:Properties] properties The properties to tween.
@param [t:ModifierInput?] modifiers A dictionary of modifiers used in adjusting tween properties.

@returns [t:(Tween|Group)?] A Tween instance or a table of generated tweens, or nil if it fails.
**--]]
return function(objects: Instance | Objects, properties: Properties, modifiers: ModifierInput?): (Tween | TweenGroup)?
	if typeof(objects) == "Instance" then
		return interface:Tween(objects, properties, modifiers)
	elseif typeof(objects) == "table" then
		return interface:GroupTween(objects, properties, modifiers)
	end
	
	return
end