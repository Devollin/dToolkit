--!strict
--[[======================================================================

UIUtil | Written by Devi (@Devollin) | 2022 | v1.0.0
	Description: A helpful library meant for use in solving UI-related
		problems.
	
========================================================================]]


local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local Util = require(script.Parent:WaitForChild("Util"))
local Platform = require(script.Parent:WaitForChild("Platform"))

local PlayerGui: PlayerGui = Platform.PlayerGui

local interface = {}


--[[**
Returns the mouse's position relative to the center of the inferred GuiObject.

@param [t:Vector2] absoluteSize

@returns [t:Vector2]
**--]]
function interface:GetMousePositionRelativeToCenter(absoluteSize: Vector2): Vector2
	local location = UserInputService:GetMouseLocation()
	
	return Vector2.new(
		location.X - (absoluteSize.X / 2),
		location.Y - (absoluteSize.Y / 2)
	)
end

--[[**
Returns the mouse's position relative to the given point and of the inferred GuiObject.

@param [t:Vector2] absoluteSize
@param [t:Vector2] point

@returns [t:Vector2]
**--]]
function interface:GetMousePositionRelativeToPoint(absoluteSize: Vector2, point: Vector2): Vector2
	local location = UserInputService:GetMouseLocation()
	
	return Vector2.new(
		location.X - (absoluteSize.X * point.X),
		location.Y - (absoluteSize.Y * point.Y)
	)
end

--[[**
Returns a boolean that describes if there the provided position is within the given GuiObject.

@param [t:Vector2] position
@param [t:GuiObject] frame

@returns [t:boolean]
**--]]
function interface:IsPositionInFrame(position: Vector2, frame: GuiObject): boolean
	local objects = PlayerGui:GetGuiObjectsAtPosition(position.X, position.Y) or {}
	
	return (table.find(objects, frame) ~= nil)
end


return interface