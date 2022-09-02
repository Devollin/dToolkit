--!strict
--[[======================================================================

Displays | Written by Devi (@Devollin) | 2021 | v1.0.0
	Description: Library of helpful display-related functions.
	
Additional credits to:
	Mia (@iGottic) - Cleanup & various modifications
	
========================================================================]]


local numberSuffixes = {"", "k", "m", "b", "t", "qu", "qi", "s", "se", "o", "n", "d"}
local numbers = {1, 5, 10, 50, 100, 500, 1000}
local chars = {"I", "V", "X", "L", "C", "D", "M"}


local interface = {}


--[[**
Returns a rounded number within certain parameters.

@param [t:number] number The number to round.
@param [t:number] place The decimal place value to round to.
@param [t:boolean?] down If false, rounds up; if true, rounds down; if nil, rounds to the nearest integer.

@returns [t:number] The rounded number.
**--]]
local function Round(number: number, place: number?, down: boolean?): number
	local adjust = 10 ^ (place or 0)
	
	if down == false then
		return math.ceil(number * adjust) / adjust
	elseif down == true then
		return math.floor(number * adjust) / adjust
	else
		return math.floor((number * adjust) + 0.5) / adjust
	end
end

--[[**
Returns the absolute value of the number given, along with the sign (or an empty string).

@param [t:number] number

@returns [t:number,string]
**--]]
local function ValidateNumber(number: number): (number, string)
	local sign = (math.sign(number) <= 0) and "-" or ""
	
	return math.abs(number), sign
end


--[[**
Returns a formatted string which displays minutes and seconds.

@param [t:number] seconds

@returns [t:string] The formatted string.
**--]]
function interface:GetTime(seconds: number): string
	local seconds, sign = ValidateNumber(seconds)
	
	return sign .. string.format("%02i:%02i",
		seconds / 60,
		seconds % 60)
end

--[[**
Returns a formatted string which displays hours, minutes, and seconds.

@param [t:number] seconds

@returns [t:string] The formatted string.
**--]]
function interface:GetTimeWithHours(seconds: number): string
	local seconds, sign = ValidateNumber(seconds)
	
	return sign .. string.format("%02i:%02i:%02i",
		seconds / (60 ^ 2),
		(seconds / 60) % 60,
		seconds % 60)
end

--[[**
Returns a formatted string which displays days, hours, minutes and seconds.

@param [t:number] seconds

@returns [t:string] The formatted string.
**--]]
function interface:GetTimeWithDays(seconds: number): string
	local seconds, sign = ValidateNumber(seconds)
	
	return sign .. string.format("%02i:%02i:%02i:%02i",
		seconds / ((60 ^ 2) * 24),
		(seconds / (60 ^ 2)) % 24,
		(seconds / 60) % 60,
		seconds % 60)
end

--[[**
Returns a formatted string which displays minutes, seconds, and milliseconds.

@param [t:number] seconds

@returns [t:string] The formatted string.
**--]]
function interface:GetTimeWithMilli(seconds: number): string
	local seconds, sign = ValidateNumber(seconds)
	
	return sign .. string.format("%02i:%02i.%03i",
		seconds / 60,
		seconds % 60,
		(seconds % 1) * 1000)
end

--[[**
Returns a shortened form of a number. Ex: 1000 -> 1k, 555555 -> 555k

@param [t:number]
@param [t:number?] place The decimal place value to show up to. If not given, will show decimals up to 3. Integers only.

@returns [t:string] The formatted string.
**--]]
function interface:GetNumberSuffix(number: number, places: number?): string
	local sign = (math.sign(number) <= 0) and "-" or ""
	number = math.abs(number)
	
	local index = math.abs(math.clamp(math.floor(math.log10(number) / 3), 0, #(numberSuffixes) - 1))
	local short = numberSuffixes[index + 1]
	
	local places = math.max(if places then places else 3, 0)
	
	if short then
		number = math.abs(Round(number / (1000 ^ index), places, sign == ""))
		
		return sign .. string.format("%." .. tostring(places) .. "f", number) .. short
	else
		return sign .. string.format("%." .. tostring(places) .. "f", number)
	end
end

--[[**
Places commas within a number, and returns the string.

@param [t:number] number

@returns [t:string] The formatted string.
**--]]
function interface:PlaceCommasInNumber(number: number): string
	number = Round(number, nil, false)
	
	local i, j, minus, int, fraction = tostring(number):find("([-]?)(%d+)([.]?%d*)")
	
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	
	return minus .. int:reverse():gsub("^,", "") .. fraction
end

--[[**
Returns a string of roman numerals based off of the number given to it.

@param [t:number] number

@returns [t:string] The roman numeral string.
**--]]
function interface:NumberToRomanNumerals(number: number): string
	number = math.floor(number)
	
	if number <= 0 then
		return tostring(number)
	end
	
	local result = ""
	
	for i = #numbers, 1, -1 do
		local a = numbers[i]
		
		while ((number - a) >= 0) and (number > 0) do
			result = result .. chars[i]
			number = number - a
		end
		
		for j = 1, (i - 1) do
			local b = numbers[j]
			
			if ((number - (a - b)) >= 0) and (number < a) and (number > 0) and ((a - b) ~= b) then
				result = result .. chars[j] .. chars[i]
				number = number - (a - b)
				
				break
			end
		end
	end
	
	return result
end


return interface