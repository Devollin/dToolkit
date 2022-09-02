--!strict
--[[================================================================================================

CameraUtil | Written by Devi (@Devollin) | 2022 | v1.0.0
	Description: A library meant to aide in the manipulaton of the camera.
	
==================================================================================================]]


local Players = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")

local PlayerUtil = require(script.Parent:WaitForChild("PlayerUtil"))

local Camera = workspace.CurrentCamera
local Player =
	if PlayerUtil.player then PlayerUtil.player:Get()
	else nil

local interface = {}


--[=[
	@class CameraUtil
	@client
	A library meant to aide in the manipulaton of the camera.
]=]

--[=[
	Fixes the reference to the camera.
	@within CameraUtil
]=]
function interface:SetCamera()
	Camera = Camera or workspace.CurrentCamera
end

--[[**
	Returns the current Camera.
	@within CameraUtil
**--]]
function interface:GetCamera(): Camera
	interface:SetCamera()
	
	return Camera
end

--[=[
	Destroys the Camera, and replaces it with a new one.
	@within CameraUtil
]=]
function interface:HardReset()
	interface:SetCamera()
	
	if Camera then
		Camera:Destroy()
		
		Camera = Instance.new("Camera")
	end
	
	interface:SoftReset()
end

--[=[
	Resets the CameraSubject and CameraType of the Camera.
	@within CameraUtil
]=]
function interface:SoftReset()
	interface:SetCamera()
	
	Camera.CameraType = Enum.CameraType.Custom
	Camera.CameraSubject = PlayerUtil:GetHumanoidFromPlayer(Player)
end

--[=[
	Returns the Camera's distance to the player's head. Can be nil if the player's head doesn't exist.
	@within CameraUtil
]=]
function interface:GetCameraDistanceToHead(): number?
	local head = PlayerUtil.head:Get() or PlayerUtil:GetHeadFromPlayerAsync(Player)
	local distance = head and (head.Position - Camera.CFrame.Position).Magnitude
	
	return distance
end

--[=[
	Returns a boolean describing if the Camera is zoomed in fully or not. Can be nil if the player's head doesn't exist.
	@within CameraUtil
]=]
function interface:IsCameraZoomedInFully(): boolean?
	local magnitude = interface:GetCameraDistanceToHead()
	
	return magnitude and (magnitude <= (StarterPlayer.CameraMinZoomDistance + 0.5))
end

--[=[
	Returns a boolean describing if the Camera is zoomed out fully or not. Can be nil if the player's head doesn't exist.
	@within CameraUtil
]=]
function interface:IsCameraZoomedOutFully(): boolean?
	local magnitude = interface:GetCameraDistanceToHead()
	
	return magnitude and (magnitude >= (StarterPlayer.CameraMaxZoomDistance - 0.5))
end


return interface