--!strict
--[[======================================================================

Platform | Written by Devi (@Devollin) | 2022 | v1.0.0
	Description: A set of variables meant to aide in determining the
		platform a player is on.
	
========================================================================]]


export type Platform = "Xbox" | "VR" | "Desktop" | "Laptop" | "Phone" | "Tablet" | "Unknown"


local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")

local Value = require(script.Parent:WaitForChild("Value"))
local Util = require(script.Parent:WaitForChild("Util"))

local Player = Players.LocalPlayer
local PlayerGui: PlayerGui =
	if Player then Player:WaitForChild("PlayerGui")
	else nil

local ui = Util:Synth("ScreenGui", {
	Name = "PLATFORM_UTILITY",
	Parent = if PlayerGui then PlayerGui else StarterGui,
	IgnoreGuiInset = true,
	ResetOnSpawn = false,
}) :: ScreenGui

local interface = {
	platform = Value.new("Unknown" :: Platform),
	
	mobile = Value.new(false),
	pc = Value.new(false),
	
	keyboard = Value.new(UserInputService.KeyboardEnabled),
	touch = Value.new(UserInputService.TouchEnabled),
	mouse = Value.new(UserInputService.MouseEnabled),
	gamepad = Value.new(UserInputService.GamepadEnabled),
	accelerometer = Value.new(UserInputService.AccelerometerEnabled),
	gyroscope = Value.new(UserInputService.GyroscopeEnabled),
	
	xbox = Value.new(GuiService:IsTenFootInterface()),
	vr = Value.new(UserInputService.VREnabled),
	
	screenSize = Value.new(ui.AbsoluteSize),
	
	PlayerGui = PlayerGui,
}


local function DeterminePlatform()
	local xbox = interface.xbox:Get()
	local vr = interface.vr:Get()
	
	if xbox then
		interface.pc:Set(false)
		interface.mobile:Set(false)
		interface.platform:Set("Xbox")
	elseif vr then
		interface.pc:Set(false)
		interface.mobile:Set(false)
		interface.platform:Set("VR")
	else
		local keyboard = interface.keyboard:Get()
		local touch = interface.touch:Get()
		local mouse = interface.mouse:Get()
		local gamepad = interface.gamepad:Get()
		local accelerometer = interface.accelerometer:Get()
		local gyroscope = interface.gyroscope:Get()
		
		local screenSize = interface.screenSize:Get()
		
		local isDesktop =
			keyboard and
			mouse and
			(not accelerometer) and
			(not gyroscope)
		
		local isLaptop =
			keyboard and
			mouse
		
		local isPhone =
			(not keyboard) and
			(not mouse) and
			(not gamepad) and
			touch and
			accelerometer and
			gyroscope and
			(screenSize.X <= 900) and (screenSize.Y <= 500)
		
		local isTablet =
			(not gamepad) and
			touch and
			accelerometer and
			gyroscope and
			(screenSize.X > 900) and (screenSize.Y > 500)
		
		if isLaptop then
			interface.pc:Set(true)
			interface.mobile:Set(false)
			
			if isDesktop then
				interface.platform:Set("Desktop")
			else
				interface.platform:Set("Laptop")
			end
		else
			interface.pc:Set(false)
			
			if isPhone then
				interface.mobile:Set(true)
				interface.platform:Set("Phone")
			elseif isTablet then
				interface.mobile:Set(true)
				interface.platform:Set("Tablet")
			else
				interface.mobile:Set(false)
				interface.platform:Set("Unknown")
			end
		end
	end
end


if PlayerGui then
	UserInputService:GetPropertyChangedSignal("KeyboardEnabled"):Connect(function()
		local value = UserInputService.KeyboardEnabled
		
		interface.keyboard:Set(value)
		DeterminePlatform()
	end)
	
	UserInputService:GetPropertyChangedSignal("TouchEnabled"):Connect(function()
		local value = UserInputService.TouchEnabled
		
		interface.touch:Set(value)
		DeterminePlatform()
	end)
	
	UserInputService:GetPropertyChangedSignal("MouseEnabled"):Connect(function()
		local value = UserInputService.MouseEnabled
		
		interface.mouse:Set(value)
		DeterminePlatform()
	end)
	
	UserInputService:GetPropertyChangedSignal("GamepadEnabled"):Connect(function()
		local value = UserInputService.GamepadEnabled
		
		interface.gamepad:Set(value)
		DeterminePlatform()
	end)
	
	UserInputService:GetPropertyChangedSignal("VREnabled"):Connect(function()
		local value = UserInputService.VREnabled
		
		interface.vr:Set(value)
		DeterminePlatform()
	end)
	
	UserInputService:GetPropertyChangedSignal("AccelerometerEnabled"):Connect(function()
		local value = UserInputService.AccelerometerEnabled
		
		interface.accelerometer:Set(value)
		DeterminePlatform()
	end)
	
	UserInputService:GetPropertyChangedSignal("GyroscopeEnabled"):Connect(function()
		local value = UserInputService.GyroscopeEnabled
		
		interface.gyroscope:Set(value)
		DeterminePlatform()
	end)
	
	ui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		local value = ui.AbsoluteSize
		
		interface.screenSize:Set(value)
		DeterminePlatform()
	end)
	
	
	DeterminePlatform()
else
	ui:Destroy()
end


return interface