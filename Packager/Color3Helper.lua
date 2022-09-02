--!strict
--[[======================================================================

Color3Helper | Written by Devi (@Devollin) | 2022 | v1.0.0
	Description: A library with a number of Color3 helper functions.
	
========================================================================]]


type NumberOrRange = (number | NumberRange)?


local interface = {}


--[[**
Returns a number value that is either randomized or uses the given number.

@param [t:(number|NumberRange)?] a

@returns [t:number]
**--]]
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


--[[**
Returns a Color3 with clamped R, G, and B values.

@param [t:number] r The R (red) value.
@param [t:number] g The G (green) value.
@param [t:number] b The B (blue) value.

@returns [t:Color3] The new color.
**--]]
function interface:ClampRGB(r: number, g: number, b: number): Color3
	return Color3.fromRGB(math.clamp(r, 0, 255), math.clamp(g, 0, 255), math.clamp(b, 0, 255))
end

--[[**
Returns a Color3 with clamped H, S, and V values.

@param [t:number] h The H (hue) value.
@param [t:number] s The S (saturation) value.
@param [t:number] v The V (value / brightness) value.

@returns [t:Color3] The new color.
**--]]
function interface:ClampHSV(h: number, s: number, v: number): Color3
	return Color3.fromHSV(math.clamp(h, 0, 255) / 255, math.clamp(s, 0, 255) / 255, math.clamp(v, 0, 255) / 255)
end

--[[**
Returns a random color.

@returns [t:Color3]
**--]]
function interface:GetRandomColor(): Color3
	return Color3.new(math.random(), math.random(), math.random())
end

--[[**
Returns a randomized color within given boundaries in RGB.
Notes: If a parameter is given nil, it has no boundaries; if given a NumberRange, it randomizes
within that range; if given a number, it sets it to that number, and does no randomization.

@param [t:(number|NumberRange)?] r The R (red) value.
@param [t:(number|NumberRange)?] g The G (green) value.
@param [t:(number|NumberRange)?] b The B (blue) value.

@returns [t:Color3]
**--]]
function interface:GetRandomColorWithLimitsInRGB(r: NumberOrRange, g: NumberOrRange, b: NumberOrRange): Color3
	local success, result = pcall(function()
		local r = GetLimitedColor(r)
		local g = GetLimitedColor(g)
		local b = GetLimitedColor(b)
		
		return Color3.new(r / 255, g / 255, b / 255)
	end)
	
	if success then
		return result
	end
	
	warn("Failed to get a random color!", result, debug.traceback())
	
	return interface:GetRandomColor()
end

--[[**
Returns a randomized color within given boundaries in HSV.
Notes: If a parameter is given nil, it has no boundaries; if given a NumberRange, it randomizes
within that range; if given a number, it sets it to that number, and does no randomization.

@param [t:(number|NumberRange)?] h The H (hue) value.
@param [t:(number|NumberRange)?] s The S (saturation) value.
@param [t:(number|NumberRange)?] v The V (value / brightness) value.

@returns [t:Color3]
**--]]
function interface:GetRandomColorWithLimitsInHSV(h: NumberOrRange, s: NumberOrRange, v: NumberOrRange): Color3
	local success, result = pcall(function()
		local h = GetLimitedColor(h)
		local s = GetLimitedColor(s)
		local v = GetLimitedColor(v)
		
		return Color3.fromHSV(h / 255, s / 255, v / 255)
	end)
	
	if success then
		return result
	end
	
	warn("Failed to get a random color!", result, debug.traceback())
	
	return interface:GetRandomColor()
end

--[[**
Returns a color that is a variation of the one given, within a given amplitude.

@param [t:Color3] color The color to use as a base.
@param [t:number] amplitude The amount to variate the color by (0-255)

@returns [t:Color3]
**--]]
function interface:GetVariantColor(color: Color3, amplitude: number): Color3
	local r, g, b = color.R * 255, color.G * 255, color.B * 255
	
	return interface:ClampRGB(
		r + math.random(-amplitude / 2, amplitude / 2),
		g + math.random(-amplitude / 2, amplitude / 2),
		b + math.random(-amplitude / 2, amplitude / 2)
	)
end

--[[**
Returns the color at the given point within the ColorSequence.

@param [t:ColorSequence] sequence The sequence to pull the color from.
@param [t:number] point The time to get the color from. [0, 1]

@returns [t:Color3]
**--]]
function interface:GetColorAtPointFromSequence(sequence: ColorSequence, point: number): Color3
	local keypoints = sequence.Keypoints
	local finalColor = Color3.new()
	local keypointA, keypointB
	
	if #keypoints == 2 then
		finalColor = keypoints[1].Value:Lerp(keypoints[2].Value, point)
	else
		for index, value in ipairs(sequence.Keypoints) do
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

--[[**
Returns a color from anywhere on the ColorSequence.

@param [t:ColorSequence] sequence The sequence to pull the color from.

@returns [t:Color3]
**--]]
function interface:GetRandomColorOnSequence(sequence: ColorSequence): Color3
	return interface:GetColorAtPointFromSequence(sequence, math.random())
end


return interface