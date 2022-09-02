--!strict
--[[======================================================================

Packager | Written by Devi (Devollin) | 2022 | v3.0.0
	Description: Package manager.
	
========================================================================]]


local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")

local packages = {}

local yield = 2

local SimpleSignal = require(script:WaitForChild("SimpleSignal", yield))
local Stopwatch = require(script:WaitForChild("Stopwatch", yield))
local Signal = require(script:WaitForChild("Signal", yield))
local Value = require(script:WaitForChild("Value", yield))
local Timer = require(script:WaitForChild("Timer", yield))
local Tween = require(script:WaitForChild("Tween", yield))
local Flow = require(script:WaitForChild("Flow", yield))

local Storage = require(script:WaitForChild("Storage", yield))

local Platform = require(script:WaitForChild("Platform", yield))
local Bind = require(script:WaitForChild("Bind", yield))

packages.Color3Helper = require(script:WaitForChild("Color3Helper", yield))
packages.PlayerUtil = require(script:WaitForChild("PlayerUtil", yield))
packages.Displays = require(script:WaitForChild("Displays", yield))
packages.Network = require(script:WaitForChild("Network", yield))
packages.Presets = require(script:WaitForChild("Presets", yield))
packages.Wrapper = require(script:WaitForChild("Wrapper", yield))
packages.Serial = require(script:WaitForChild("Serial", yield))
packages.Util = require(script:WaitForChild("Util", yield))

packages.CameraUtil = require(script:WaitForChild("CameraUtil", yield))
packages.UIUtil = require(script:WaitForChild("UIUtil", yield))

packages.SimpleSignal = SimpleSignal
packages.Stopwatch = Stopwatch
packages.Signal = Signal
packages.Value = Value
packages.Timer = Timer
packages.Tween = Tween
packages.Flow = Flow

packages.Storage = Storage

packages.Platform = Platform
packages.Bind = Bind


export type SimpleSignal<a...> = SimpleSignal.Signal<a...>
export type Stopwatch = Stopwatch.Stopwatch
export type Connection<a...> = Signal.Connection<a...>
export type Signal<a...> = Signal.Signal<a...>
export type Value<a...> = Value.Value<a...>
export type Timer = Timer.Timer
export type TweenGroup = Tween.TweenGroup
export type TweenModifiers = Tween.TweenModifiers
export type TweenModifiersInput = Tween.TweenModifiersInput
export type Flow = Flow.Flow
export type FlowModifiers = Flow.FlowModifiers
export type FlowModifiersInput = Flow.FlowModifiersInput

export type DataStoreResult = Storage.DataStoreResult
export type OrderedDataStoreResult = Storage.OrderedDataStoreResult
export type Storage = Storage.Storage
export type BaseStorage = Storage.BaseStorage
export type BaseStorageResult = Storage.BaseStorageResult
export type PlayerStorage = Storage.PlayerStorage
export type PlayerStorageResult = Storage.PlayerStorageResult
export type OrderedStorage = Storage.OrderedStorage
export type OrderedStorageResult = Storage.OrderedStorageResult

export type Platform = Platform.Platform
export type Bind = Bind.Bind


return packages