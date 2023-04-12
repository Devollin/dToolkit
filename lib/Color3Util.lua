--!strict
--[[================================================================================================

Color3Util | Written by Devi (@Devollin) | 2022 | v1.1.0
	Description: A library with helpful Color3 functions.
	
==================================================================================================]]


type NumberOrRange = (number | NumberRange)?


local interface = {}


--[=[
	@type NumberOrRange (number | NumberRange)?
	A number, NumberRange, or nil.
	
	@within Color3Util
]=]

--[=[
	@class Color3Util
	A library with a number of Color3 helper functions.
]=]

--[=[
	Returns a number value that is either randomized or uses the given number.
	
	@within Color3Util
	@ignore
]=]
local function GetLimitedColor(a: NumberOrRange): number
	if typeof(a) ~= "number" then
		if a == nil then
			a = NumberRange.new(0, 255)
		end
		
		if typeof(a) == "NumberRange" then
			a = math.random(a.Min, a.Max)
		end
	end
	
	return a :: number
end


--[=[
	Returns a Color3 with clamped R, G, and B values.
	
	```lua
	local clampedColor = Color3Util:ClampRGB(300, -2500, 5)
	
	print(clampedColor) --> 255, 0, 5
	```
	
	@within Color3Util
]=]
function interface:ClampRGB(r: number, g: number, b: number): Color3
	return Color3.fromRGB(math.clamp(r, 0, 255), math.clamp(g, 0, 255), math.clamp(b, 0, 255))
end

--[=[
	Returns a Color3 with clamped H, S, and V values.
	
	```lua
	local clampedColor = Color3Util:ClampHSV(300, -2500, 5)
	
	print(clampedColor) --> 255, 0, 5
	```
	
	@within Color3Util
]=]
function interface:ClampHSV(h: number, s: number, v: number): Color3
	return Color3.fromHSV(math.clamp(h, 0, 255) / 255, math.clamp(s, 0, 255) / 255, math.clamp(v, 0, 255) / 255)
end

--[=[
	Returns a random color.
	
	```lua
	print(Color3Util:GetRandomColor())
	```
	
	@within Color3Util
]=]
function interface:GetRandomColor(): Color3
	return Color3.new(math.random(), math.random(), math.random())
end

--[=[
	Returns a randomized color within given boundaries in RGB [0-255].
	
	```lua
	local limitedColor = Color3Util:GetRandomColorWithLimitsInRGB(NumberRange.new(50, 255), nil, 5)
	
	print(limitedColor)
	```
	
	:::info
	If a parameter is given nil, it has no boundaries; if given a NumberRange, it randomizes within that range; if given a
	number, it sets it to that number, and does no randomization.
	
	@within Color3Util
]=]
function interface:GetRandomColorWithLimitsInRGB(r: NumberOrRange, g: NumberOrRange, b: NumberOrRange): Color3
	return Color3.fromRGB(GetLimitedColor(r), GetLimitedColor(g), GetLimitedColor(b))
end

--[=[
	Returns a randomized color within given boundaries in HSV [0-255].
	
	```lua
	local limitedColor = Color3Util:GetRandomColorWithLimitsInHSV(NumberRange.new(50, 255), nil, 5)
	
	print(limitedColor)
	```
	
	:::info
	If a parameter is given nil, it has no boundaries; if given a NumberRange, it randomizes
	within that range; if given a number, it sets it to that number, and does no randomization.
	
	@within Color3Util
]=]
function interface:GetRandomColorWithLimitsInHSV(h: NumberOrRange, s: NumberOrRange, v: NumberOrRange): Color3
	return Color3.fromHSV(GetLimitedColor(h) / 255, GetLimitedColor(s) / 255, GetLimitedColor(v) / 255)
end

--[=[
	Returns a color that is a variation of the one given, within a given amplitude.
	
	```lua
	local originalColor = Color3.new(0.5, 0.25, 0.75)
	local variationColorA = Color3Util:GetVariantColor(originalColor, 55)
	local variationColorB = Color3Util:GetVariantColor(originalColor, 20)
	
	print("Original:", originalColor, "| A:", variationColorA, "| B:", variationColorB)
	```
	
	@param color -- The color to use as a base.
	@param amplitude -- The amount to variate the color by (0-255)
	
	@within Color3Util
]=]
function interface:GetVariantColor(color: Color3, amplitude: number): Color3
	local r, g, b = color.R * 255, color.G * 255, color.B * 255
	local halfAmplitude = amplitude / 2
	
	return interface:ClampRGB(
		r + math.random(-halfAmplitude, halfAmplitude),
		g + math.random(-halfAmplitude, halfAmplitude),
		b + math.random(-halfAmplitude, halfAmplitude)
	)
end

--[=[
	Returns the color at the given point within the ColorSequence.
	
	```lua
	local sequence = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0)),
		ColorSequenceKeypoint.new(0.5, Color3.new(0, 1, 0)),
		ColorSequenceKeypoint.new(1, Color3.new(1, 0, 1)),
	})
	
	print(Color3Util:GetColorAtPointFromSequence(sequence, 0.25))
	```
	
	@param sequence -- The sequence to pull the color from.
	@param point -- The time to get the color from. [0, 1]
	
	@within Color3Util
]=]
function interface:GetColorAtPointFromSequence(sequence: ColorSequence, point: number): Color3
	local keypoints = sequence.Keypoints
	local finalColor = Color3.new()
	local keypointA, keypointB
	
	if #keypoints == 2 then
		finalColor = keypoints[1].Value:Lerp(keypoints[2].Value, point)
	else
		for index, value in sequence.Keypoints do
			if value.Time <= point then
				local otherValue = sequence.Keypoints[index + 1]
				
				if otherValue and (otherValue.Time >= point) then
					keypointA = value
					keypointB = otherValue
					
					break
				end
			end
		end
		
		if keypointA and keypointB then
			local delta = (keypointB.Time - keypointA.Time)
			local relativePoint = (point - keypointA.Time) / delta
			
			finalColor = keypointA.Value:Lerp(keypointB.Value, relativePoint)
		end
	end
	
	return finalColor
end

--[=[
	Returns a color from anywhere on the ColorSequence.
	
	```lua
	local sequence = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0)),
		ColorSequenceKeypoint.new(0.5, Color3.new(0, 1, 0)),
		ColorSequenceKeypoint.new(1, Color3.new(1, 0, 1)),
	})
	
	print(Color3Util:GetRandomColorOnSequence(sequence))
	```
	
	@param sequence -- The sequence to pull the color from.
	
	@within Color3Util
]=]
function interface:GetRandomColorOnSequence(sequence: ColorSequence): Color3
	return interface:GetColorAtPointFromSequence(sequence, math.random())
end

--[=[
	Returns a ColorSequence with all given Color3s evenly spread out.
	
	```lua
	local sequence = Color3Util:GetColorSequenceFromColor3s(Color3.new(1, 0.5, 1), Color3.new(1, 1, 0), Color3.new(1, 0.5, 0))
	```
	
	@within Color3Util
]=]
function interface:GetColorSequenceFromColor3s(...: Color3): ColorSequence
	local originalColors = {...}
	
	if #originalColors == 1 then
		return ColorSequence.new(originalColors[1])
	elseif #originalColors == 0 then
		return ColorSequence.new(Color3.new(0, 0, 0))
	end
	
	local keypoints = {}
	
	for index, color in originalColors do
		local time =
			if index == 1 then 0
			elseif index == #originalColors then 1
			else (index - 1) / (#originalColors - 1)
		
		table.insert(keypoints, ColorSequenceKeypoint.new(time, color))
	end
	
	return ColorSequence.new(keypoints)
end


return interface