--!strict
--[[================================================================================================

UIUtil | Written by Devi (@Devollin) | 2022 | v1.0.1
	Description: A library meant for use in solving UI-related problems.
	
==================================================================================================]]


local UserInputService: UserInputService = game:GetService("UserInputService")

local Platform = require(script.Parent:WaitForChild("Platform"))

local PlayerGui: PlayerGui = Platform.PlayerGui :: PlayerGui

local interface = {}


--[=[
	@class UIUtil
	A library meant for use in solving UI-related problems.
	@client
]=]

--[=[
	Returns the mouse's position relative to the center of the inferred GuiObject.
	@within UIUtil
]=]
function interface:GetMousePositionRelativeToCenter(absoluteSize: Vector2): Vector2
	local location = UserInputService:GetMouseLocation()
	
	return Vector2.new(
		location.X - (absoluteSize.X / 2),
		location.Y - (absoluteSize.Y / 2)
	)
end

--[=[
	Returns the mouse's position relative to the given point and of the inferred GuiObject.
	@within UIUtil
]=]
function interface:GetMousePositionRelativeToPoint(absoluteSize: Vector2, point: Vector2): Vector2
	local location = UserInputService:GetMouseLocation()
	
	return Vector2.new(
		location.X - (absoluteSize.X * point.X),
		location.Y - (absoluteSize.Y * point.Y)
	)
end

--[=[
	Returns a boolean that describes if there the provided position is within the given GuiObject.
	@within UIUtil
]=]
function interface:IsPositionInFrame(position: Vector2, frame: GuiObject): boolean
	local objects = PlayerGui:GetGuiObjectsAtPosition(position.X, position.Y) or {}
	
	return (table.find(objects, frame) ~= nil)
end


return interface