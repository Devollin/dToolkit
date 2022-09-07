--!strict
--[[================================================================================================

Platform | Written by Devi (@Devollin) | 2022 | v1.0.0
	Description: A set of variables meant to aide in determining the platform a player is on.
	
==================================================================================================]]


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

--[=[
	@type Platform "Xbox" | "VR" | "Desktop" | "Laptop" | "Phone" | "Tablet" | "Unknown"
	The platform the player is currently on.
	
	:::caution Inconsistency & Studio
	When using the Studio device emulator, Platform can't determine the platform very well (It is a little too accurate!).
	However, it does work consistently in live testing. 
	:::
	:::tip Granular Checking
	For more specific checks, use the individual [Value] members within Platform.
	:::
	@within Platform
]=]

--[=[
	@class Platform
	@client
	A set of [Value] objects meant to aide in determining the platform a [Player] is on.
]=]

--[=[
	@prop platform Value<Platform>
	The platform the [Player] is currently on.
	
	@within Platform
]=]
--[=[
	@prop mobile Value<boolean>
	Whether or not the [Player] is using a mobile device.
	
	@within Platform
]=]
--[=[
	@prop pc Value<boolean>
	Whether or not the [Player] is using a laptop or desktop.
	
	@within Platform
]=]
--[=[
	@prop xbox Value<boolean>
	Whether or not the [Player] is using an Xbox.
	
	@within Platform
]=]
--[=[
	@prop vr Value<boolean>
	Whether or not the [Player] is using a VR headset.
	
	@within Platform
]=]
--[=[
	@prop keyboard Value<boolean>
	Whether or not the platform the [Player] is using has keyboard input.
	
	@within Platform
]=]
--[=[
	@prop touch Value<boolean>
	Whether or not the platform the [Player] is using has touch input.
	
	@within Platform
]=]
--[=[
	@prop mouse Value<boolean>
	Whether or not the platform the [Player] is using has mouse input.
	
	@within Platform
]=]
--[=[
	@prop gamepad Value<boolean>
	Whether or not the platform the [Player] is using has gamepad input.
	
	@within Platform
]=]
--[=[
	@prop accelerometer Value<boolean>
	Whether or not the platform the [Player] is using has accelerometer input.
	
	@within Platform
]=]
--[=[
	@prop gyroscope Value<boolean>
	Whether or not the platform the [Player] is using has gyroscope input.
	
	@within Platform
]=]
--[=[
	@prop screenSize Value<Vector2>
	The size of the screen that the platform the [Player] on is using.
	
	@within Platform
]=]
--[=[
	@prop PlayerGui PlayerGui
	A reference to the [Player]'s [PlayerGui].
	
	@within Platform
]=]

local interface = {
	platform = Value.new("Unknown" :: Platform),
	
	mobile = Value.new(false),
	pc = Value.new(false),
	xbox = Value.new(GuiService:IsTenFootInterface()),
	vr = Value.new(UserInputService.VREnabled),
	
	keyboard = Value.new(UserInputService.KeyboardEnabled),
	touch = Value.new(UserInputService.TouchEnabled),
	mouse = Value.new(UserInputService.MouseEnabled),
	gamepad = Value.new(UserInputService.GamepadEnabled),
	accelerometer = Value.new(UserInputService.AccelerometerEnabled),
	gyroscope = Value.new(UserInputService.GyroscopeEnabled),
	
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