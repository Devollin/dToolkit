--!strict
--[[================================================================================================

Platform | Written by Devi (@Devollin) | 2022 | v1.0.2
	Description: A set of variables meant to aide in determining the platform a player is on.
	
==================================================================================================]]


local UserInputService: UserInputService = game:GetService("UserInputService")
local GuiService: GuiService = game:GetService("GuiService")
local Players: Players = game:GetService("Players")

local SimpleValue = require(script.Parent:WaitForChild("SimpleValue"))
local Value = require(script.Parent:WaitForChild("Value"))


export type Platform = "Xbox" | "VR" | "Desktop" | "Laptop" | "Phone" | "Tablet" | "Unknown"

export type SimpleValue<a> = SimpleValue.SimpleValue<a>
export type InternalSimpleValue<a> = SimpleValue.InternalSimpleValue<a>
export type Value<a...> = Value.Value<a...>
export type InternalValue<a...> = Value.InternalValue<a...>
export type Signal<a...> = Value.Signal<a...>
export type InternalSignal<a...> = Value.InternalSignal<a...>
export type Connection<a...> = Value.Connection<a...>
export type InternalConnection<a...> = Value.InternalConnection<a...>


local Player = Players.LocalPlayer
local PlayerGui: PlayerGui? =
	if Player then Player:WaitForChild("PlayerGui") :: PlayerGui
	else nil

local ui = Instance.new("ScreenGui")
ui.Name = "PLATFORM_UTILITY"
ui.IgnoreGuiInset = true
ui.ResetOnSpawn = false
ui.Parent = PlayerGui


--[=[
	@type Platform "Xbox" | "VR" | "Desktop" | "Laptop" | "Phone" | "Tablet" | "Unknown"
	The platform the player is currently on.
	
	:::caution Inconsistency & Studio
	When using the Studio device emulator, Platform can't determine the platform very well (It is a little too accurate!).
	However, it does work consistently in live testing. 
	:::
	:::tip Granular Checking
	For more specific checks, use the individual [SimpleValue] members within Platform.
	:::
	@within Platform
]=]

--[=[
	@class Platform
	@client
	A set of [SimpleValue] objects meant to aide in determining the platform a [Player] is on.
]=]

--[=[
	@prop platform SimpleValue<Platform>
	The platform the [Player] is currently on.
	
	@within Platform
]=]
--[=[
	@prop mobile SimpleValue<boolean>
	Whether or not the [Player] is using a mobile device.
	
	@within Platform
]=]
--[=[
	@prop pc SimpleValue<boolean>
	Whether or not the [Player] is using a laptop or desktop.
	
	@within Platform
]=]
--[=[
	@prop xbox SimpleValue<boolean>
	Whether or not the [Player] is using an Xbox.
	
	@within Platform
]=]
--[=[
	@prop vr SimpleValue<boolean>
	Whether or not the [Player] is using a VR headset.
	
	@within Platform
]=]
--[=[
	@prop keyboard SimpleValue<boolean>
	Whether or not the platform the [Player] is using has keyboard input.
	
	@within Platform
]=]
--[=[
	@prop touch SimpleValue<boolean>
	Whether or not the platform the [Player] is using has touch input.
	
	@within Platform
]=]
--[=[
	@prop mouse SimpleValue<boolean>
	Whether or not the platform the [Player] is using has mouse input.
	
	@within Platform
]=]
--[=[
	@prop gamepad SimpleValue<boolean>
	Whether or not the platform the [Player] is using has gamepad input.
	
	@within Platform
]=]
--[=[
	@prop accelerometer SimpleValue<boolean>
	Whether or not the platform the [Player] is using has accelerometer input.
	
	@within Platform
]=]
--[=[
	@prop gyroscope SimpleValue<boolean>
	Whether or not the platform the [Player] is using has gyroscope input.
	
	@within Platform
]=]
--[=[
	@prop screenSize SimpleValue<Vector2>
	The size of the screen that the platform the [Player] on is using.
	
	@within Platform
]=]
--[=[
	@prop PlayerGui PlayerGui
	A reference to the [Player]'s [PlayerGui].
	
	@within Platform
]=]


local internal = {
	platform = SimpleValue.new("Unknown"),
	
	mobile = SimpleValue.new(false),
	pc = SimpleValue.new(false),
	xbox = SimpleValue.new(GuiService:IsTenFootInterface()),
	vr = SimpleValue.new(UserInputService.VREnabled),
	
	keyboard = SimpleValue.new(UserInputService.KeyboardEnabled),
	touch = SimpleValue.new(UserInputService.TouchEnabled),
	mouse = SimpleValue.new(UserInputService.MouseEnabled),
	gamepad = SimpleValue.new(UserInputService.GamepadEnabled),
	accelerometer = SimpleValue.new(UserInputService.AccelerometerEnabled),
	gyroscope = SimpleValue.new(UserInputService.GyroscopeEnabled),
	
	screenSize = SimpleValue.new(ui.AbsoluteSize),
}


local function DeterminePlatform()
	local xbox = internal.xbox:Get()
	local vr = internal.vr:Get()
	
	if xbox then
		internal.pc:Set(false)
		internal.mobile:Set(false)
		internal.platform:Set("Xbox")
	elseif vr then
		internal.pc:Set(false)
		internal.mobile:Set(false)
		internal.platform:Set("VR")
	else
		local keyboard = internal.keyboard:Get()
		local touch = internal.touch:Get()
		local mouse = internal.mouse:Get()
		local gamepad = internal.gamepad:Get()
		local accelerometer = internal.accelerometer:Get()
		local gyroscope = internal.gyroscope:Get()
		
		local screenSize = internal.screenSize:Get()
		
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
			internal.pc:Set(true)
			internal.mobile:Set(false)
			
			if isDesktop then
				internal.platform:Set("Desktop")
			else
				internal.platform:Set("Laptop")
			end
		else
			internal.pc:Set(false)
			
			if isPhone then
				internal.mobile:Set(true)
				internal.platform:Set("Phone")
			elseif isTablet then
				internal.mobile:Set(true)
				internal.platform:Set("Tablet")
			else
				internal.mobile:Set(false)
				internal.platform:Set("Unknown")
			end
		end
	end
end


if PlayerGui then
	UserInputService:GetPropertyChangedSignal("KeyboardEnabled"):Connect(function()
		internal.keyboard:Set(UserInputService.KeyboardEnabled)
		
		DeterminePlatform()
	end)
	
	UserInputService:GetPropertyChangedSignal("TouchEnabled"):Connect(function()
		internal.touch:Set(UserInputService.TouchEnabled)
		
		DeterminePlatform()
	end)
	
	UserInputService:GetPropertyChangedSignal("MouseEnabled"):Connect(function()
		internal.mouse:Set(UserInputService.MouseEnabled)
		
		DeterminePlatform()
	end)
	
	UserInputService:GetPropertyChangedSignal("GamepadEnabled"):Connect(function()
		internal.gamepad:Set(UserInputService.GamepadEnabled)
		
		DeterminePlatform()
	end)
	
	UserInputService:GetPropertyChangedSignal("VREnabled"):Connect(function()
		internal.vr:Set(UserInputService.VREnabled)
		
		DeterminePlatform()
	end)
	
	UserInputService:GetPropertyChangedSignal("AccelerometerEnabled"):Connect(function()
		internal.accelerometer:Set(UserInputService.AccelerometerEnabled)
		
		DeterminePlatform()
	end)
	
	UserInputService:GetPropertyChangedSignal("GyroscopeEnabled"):Connect(function()
		internal.gyroscope:Set(UserInputService.GyroscopeEnabled)
		
		DeterminePlatform()
	end)
	
	ui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		internal.screenSize:Set(ui.AbsoluteSize)
		
		DeterminePlatform()
	end)
	
	
	DeterminePlatform()
else
	ui:Destroy()
	ui = nil :: any
end


return {
	platform = internal.platform :: InternalSimpleValue<string>,
	
	mobile = internal.mobile :: InternalSimpleValue<boolean>,
	pc = SimpleValue.new(false) :: InternalSimpleValue<boolean>,
	xbox = SimpleValue.new(GuiService:IsTenFootInterface()) :: InternalSimpleValue<boolean>,
	vr = internal.vr :: InternalSimpleValue<boolean>,
	
	keyboard = internal.keyboard :: InternalSimpleValue<boolean>,
	touch = internal.touch :: InternalSimpleValue<boolean>,
	mouse = internal.mouse :: InternalSimpleValue<boolean>,
	gamepad = internal.gamepad :: InternalSimpleValue<boolean>,
	accelerometer = internal.accelerometer :: InternalSimpleValue<boolean>,
	gyroscope = internal.gyroscope :: InternalSimpleValue<boolean>,
	
	screenSize = internal.screenSize :: InternalSimpleValue<Vector2>,
	
	PlayerGui = PlayerGui,
}