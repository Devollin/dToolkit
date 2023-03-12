--!strict
--[[================================================================================================

PlayerUtil | Written by Devi (@Devollin) | 2022 | v1.1.0
	Description: Library of helpful player / character related functions.
	
Additional credits to:
	Mia (@iGottic) - Cleanup & various modifications

==================================================================================================]]


local RunService: RunService = game:GetService("RunService")
local Players: Players = game:GetService("Players")

local SimpleValue = require(script.Parent:WaitForChild("SimpleValue"))
local Signal = require(script.Parent:WaitForChild("Signal"))
local Value = require(script.Parent:WaitForChild("Value"))

type Value<a...> = Value.Value<a...>
type InternalValue<a...> = Value.InternalValue<a...>
type Signal<a...> = Signal.Signal<a...>
type InternalSignal<a...> = Signal.InternalSignal<a...>
type SimpleValue<a> = SimpleValue.SimpleValue<a>
type InternalSimpleValue<a> = SimpleValue.InternalSimpleValue<a>

local interface = {}


--[=[
	@class PlayerUtil
	A library of helpful player / character related functions.
]=]

--[=[
	Returns the character of a given Player, or returns nil if there is no character or player.
	@within PlayerUtil
]=]
function interface:GetCharacterFromPlayerAsync(player: Player?): Model?
	return
		if player then player.Character
		else nil
end

--[=[
	Returns the character of a given Player, or waits until the character exists.
	@within PlayerUtil
	@yields
]=]
function interface:GetCharacterFromPlayer(player: Player?): Model?
	return
		if player then (player.Character or player.CharacterAdded:Wait())
		else nil
end

--[=[
	Returns the humanoid of a given character, if it exists; and waits if it doesn't.
	@within PlayerUtil
	@yields
]=]
function interface:GetHumanoidFromCharacter(character: Model?): Humanoid?
	return
		if character then character:WaitForChild("Humanoid", 1) :: Humanoid
		else nil
end

--[=[
	Returns the humanoid of a given character, or nil if it doesn't exist.
	@within PlayerUtil
]=]
function interface:GetHumanoidFromCharacterAsync(character: Model?): Humanoid?
	return
		if character then character:FindFirstChildOfClass("Humanoid")
		else nil
end

--[=[
	Returns the humanoid of a given player, if it exists; and waits if it doesn't.
	@within PlayerUtil
	@yields
]=]
function interface:GetHumanoidFromPlayer(player: Player?): Humanoid?
	return interface:GetHumanoidFromCharacter(interface:GetCharacterFromPlayer(player))
end

--[=[
	Returns the humanoid of a given player, or nil if it doesn't exist.
	@within PlayerUtil
]=]
function interface:GetHumanoidFromPlayerAsync(player: Player?): Humanoid?
	return interface:GetHumanoidFromCharacterAsync(interface:GetCharacterFromPlayerAsync(player))
end

--[=[
	Returns the root part of the given character, if it exists; or waits if it doesn't.
	@within PlayerUtil
	@yields
]=]
function interface:GetRootFromCharacter(character: Model?): BasePart?
	return
		if character then character:WaitForChild("HumanoidRootPart", 1) :: BasePart
		else nil
end

--[=[
	Returns the root part of the given character, if it exists.
	@within PlayerUtil
]=]
function interface:GetRootFromCharacterAsync(character: Model?): BasePart?
	return
		if character then character:FindFirstChild("HumanoidRootPart") :: BasePart
		else nil
end

--[=[
	Returns the root part of the given player, if it exists; or waits if it doesn't.
	@within PlayerUtil
	@yields
]=]
function interface:GetRootFromPlayer(player: Player?): BasePart?
	local character = interface:GetCharacterFromPlayer(player)
	
	return
		if character then character:WaitForChild("HumanoidRootPart", 1) :: BasePart
		else nil
end

--[=[
	Returns the root part of the given player, if it exists.
	@within PlayerUtil
]=]
function interface:GetRootFromPlayerAsync(player: Player?): BasePart?
	local character = interface:GetCharacterFromPlayerAsync(player)
	
	return
		if character then character:FindFirstChild("HumanoidRootPart") :: BasePart
		else nil
end

--[=[
	Returns an array of all the parts within a character, and allows you to exclude some by name.
	
	@return {[string]: BasePart} -- A dictionary of all the parts in the character.
	
	@within PlayerUtil
	@yields
]=]
function interface:GetCharacterParts(character: Model?): {[string]: BasePart}
	local results = {}
	
	if character then
		for _, part in pairs(character:GetChildren()) do
			if part:IsA("BasePart") then
				results[part.Name] = part
			end
		end
	end
	
	return results
end

--[=[
	Returns an array of all the parts within a character, and allows you to exclude some by name.
	
	@param blacklist -- A table of character part names to exclude from the list.
	
	@return {[string]: BasePart} -- A dictionary of all the parts in the character, excluding those from the blacklist.
	
	@within PlayerUtil
]=]
function interface:GetCharacterPartsWithBlacklist(character: Model?, blacklist: {string}): {[string]: BasePart}
	local results = {}
	
	if character then
		for _, part in pairs(character:GetChildren()) do
			if part:IsA("BasePart") and not table.find(blacklist, part.Name) then
				results[part.Name] = part
			end
		end
	end
	
	return results
end

--[=[
	Returns an array of requested parts within a character.
	
	@param whitelist -- A dictionary of character part names to try to include on the list.
	
	@return {[string]: BasePart} -- A dictionary of all the parts in the character requested on the list.
	
	@within PlayerUtil
]=]
function interface:GetCharacterPartsWithWhitelist(character: Model?, whitelist: {string}): {[string]: BasePart}
	local results = {}
	
	if character then
		for _, part in pairs(character:GetChildren()) do
			if part:IsA("BasePart") and table.find(whitelist, part.Name) then
				results[part.Name] = part
			end
		end
	end
	
	return results
end

--[=[
	Returns the player from a part, if there is one.
	@within PlayerUtil
]=]
function interface:GetPlayerFromPart(part: BasePart?): Player?
	local part = part :: BasePart
	
	if not (part and part.Parent) then
		return
	end
	
	for _, otherPlayer in pairs(Players:GetPlayers()) do
		local character = interface:GetCharacterFromPlayerAsync(otherPlayer) :: Model
		
		if not (character and character.Parent) then
			continue
		end
		
		if not (part and part.Parent) then
			return
		end
		
		if part:IsDescendantOf(character) then
			return otherPlayer
		end
	end
	
	return
end

--[=[
	Returns the character from a part, if there is one.
	@within PlayerUtil
]=]
function interface:GetCharacterFromPart(part: BasePart?): Model?
	local player = interface:GetPlayerFromPart(part)
	
	return
		if player then player.Character
		else nil
end

--[=[
	Returns the tool from a given player and tool name, if it can be found.
	@within PlayerUtil
]=]
function interface:GetToolFromPlayerByName(player: Player?, name: string): Tool?
	local character =
		if player then interface:GetCharacterFromPlayerAsync(player)
		else nil
	
	if character then
		local find = character:FindFirstChild(name)
		
		if find and find:IsA("Tool") then
			return find
		end
	end
	
	local backpack =
		if player then player:FindFirstChildOfClass("Backpack")
		else nil
	
	if backpack then
		local find = backpack:FindFirstChild(name)
		
		if find and find:IsA("Tool") then
			return find
		end
	end
	
	return
end

--[=[
	Returns a boolean describing if the player has the given tool in their inventory.
	@within PlayerUtil
]=]
function interface:DoesPlayerHaveTool(player: Player?, name: string): boolean
	return interface:GetToolFromPlayerByName(player, name) ~= nil
end

--[=[
	Returns the head of the given character, if it exists.
	@within PlayerUtil
]=]
function interface:GetHeadFromCharacterAsync(character: Model?): BasePart?
	local head =
		if character then character:FindFirstChild("Head")
		else nil
	
	return
		if head and head:IsA("BasePart") then head
		else nil
end

--[=[
	Returns the head of the given character, if it exists; and waits if it doesn't.
	@within PlayerUtil
	@yields
]=]
function interface:GetHeadFromCharacter(character: Model?): BasePart?
	local head =
		if character then character:WaitForChild("Head", 1)
		else nil
	
	return
		if head and head:IsA("BasePart") then head
		else nil
end

--[=[
	Returns the head of the given player, if it exists.
	@within PlayerUtil
]=]
function interface:GetHeadFromPlayerAsync(player: Player?): BasePart?
	local character =
		if player then interface:GetCharacterFromPlayerAsync(player)
		else nil
	
	local head =
		if character then character:FindFirstChild("Head")
		else nil
	
	return
		if head and head:IsA("BasePart") then head
		else nil
end

--[=[
	Returns the head of the given player, if it exists; and waits if it doesn't.
	@within PlayerUtil
	@yields
]=]
function interface:GetHeadFromPlayer(player: Player?): BasePart?
	local character =
		if player then interface:GetCharacterFromPlayer(player)
		else nil
	
	local head =
		if character then character:WaitForChild("Head", 1)
		else nil
	
	return
		if head and head:IsA("BasePart") then head
		else nil
end

--[=[
	Returns the animator of the given humanoid, if it exists.
	@within PlayerUtil
]=]
function interface:GetAnimatorFromHumanoidAsync(humanoid: Humanoid?): Animator?
	return
		if humanoid then humanoid:FindFirstChildOfClass("Animator")
		else nil
end

--[=[
	Returns the animator of the given humanoid, if it exists; and waits if it doesn't.
	@within PlayerUtil
	@yields
]=]
function interface:GetAnimatorFromHumanoid(humanoid: Humanoid?): Animator?
	local animator =
		if humanoid then humanoid:WaitForChild("Animator", 1)
		else nil
	
	return
		if animator and animator:IsA("Animator") then animator
		else nil
end

--[=[
	Returns the animator of the given character, if it exists.
	@within PlayerUtil
]=]
function interface:GetAnimatorFromCharacterAsync(character: Model?): Animator?
	local humanoid =
		if character then interface:GetHumanoidFromCharacterAsync(character)
		else nil
	
	return
		if humanoid then interface:GetAnimatorFromHumanoidAsync(humanoid)
		else nil
end

--[=[
	Returns the animator of the given character, if it exists; and waits if it doesn't.
	@within PlayerUtil
	@yields
]=]
function interface:GetAnimatorFromCharacter(character: Model?): Animator?
	local humanoid =
		if character then interface:GetHumanoidFromCharacter(character)
		else nil
	
	return
		if humanoid then interface:GetAnimatorFromHumanoid(humanoid)
		else nil
end

--[=[
	Returns the animator of the given player, if it exists.
	@within PlayerUtil
]=]
function interface:GetAnimatorFromPlayerAsync(player: Player?): Animator?
	local character =
		if player then interface:GetCharacterFromPlayerAsync(player)
		else nil
	
	return
		if character then interface:GetAnimatorFromCharacterAsync(character)
		else nil
end

--[=[
	Returns the animator of the given player, if it exists; and waits if it doesn't.
	@within PlayerUtil
	@yields
]=]
function interface:GetAnimatorFromPlayer(player: Player?): Animator?
	local character =
		if player then interface:GetCharacterFromPlayer(player)
		else nil
	
	return
		if character then interface:GetAnimatorFromCharacter(character)
		else nil
end


--[=[
	@prop player SimpleValue<Player>
	A reference to the [Player].
	
	@within PlayerUtil
	@client
]=]
--[=[
	@prop character SimpleValue<Model?>
	A reference to the [Player]'s character [Model].
	
	@within PlayerUtil
	@client
]=]
--[=[
	@prop humanoid SimpleValue<Humanoid>
	A reference to the [Humanoid] of the [Player].
	
	@within PlayerUtil
	@client
]=]
--[=[
	@prop animator SimpleValue<Animator?>
	A reference to the [Player]'s [Animator].
	
	@within PlayerUtil
	@client
]=]
--[=[
	@prop head SimpleValue<BasePart?>
	A reference to the [Player]'s head [BasePart].
	
	@within PlayerUtil
	@client
]=]
--[=[
	@prop root SimpleValue<BasePart?>
	A reference to the [Player]'s root [BasePart].
	
	@within PlayerUtil
	@client
]=]
--[=[
	@prop state Value<Enum.HumanoidStateType?, Enum.HumanoidStateType?>
	A reference to the [Enum.HumanoidStateType] of the [Player]'s [Humanoid].
	
	@within PlayerUtil
	@client
]=]
--[=[
	@prop Respawned Signal<Humanoid>
	A [Signal] that is fired when the [Player]'s character [Model] is created, and passes along its [Humanoid].
	
	@within PlayerUtil
	@tag Event
	@client
]=]
--[=[
	@prop Died Signal<Model, Humanoid>
	A [Signal] that is fired when the [Player]'s [Humanoid] dies, and passes along the character [Model] and [Humanoid].
	
	@within PlayerUtil
	@tag Event
	@client
]=]


if RunService:IsClient() then
	local Player = Players.LocalPlayer :: Player
	
	local internal = {
		player = SimpleValue.new(Player) :: SimpleValue<Player>,
		character = SimpleValue.new(nil :: Model?) :: SimpleValue<Model?>,
		humanoid = SimpleValue.new(nil :: Humanoid?) :: SimpleValue<Humanoid?>,
		
		animator = SimpleValue.new(nil :: Animator?) :: SimpleValue<Animator?>,
		head = SimpleValue.new(nil :: BasePart?) :: SimpleValue<BasePart?>,
		root = SimpleValue.new(nil :: BasePart?) :: SimpleValue<BasePart?>,
		
		state = Value.new() :: Value<Enum.HumanoidStateType?, Enum.HumanoidStateType?>,
		
		Respawned = Signal.new() :: Signal<Humanoid>,
		Died = Signal.new() :: Signal<Model, Humanoid>,
	}
	
	interface.player = (internal.player :: any) :: InternalValue<Player>
	interface.character = (internal.character :: any) :: InternalValue<Model?>
	interface.humanoid = (internal.humanoid :: any) :: InternalValue<Humanoid?>
	
	interface.animator = (internal.animator :: any) :: InternalValue<Animator?>
	interface.head = (internal.head :: any) :: InternalValue<BasePart?>
	interface.root = (internal.root :: any) :: InternalValue<BasePart?>
	
	interface.state = internal.state :: InternalValue<Enum.HumanoidStateType?, Enum.HumanoidStateType?>
	
	interface.Respawned = (internal.Respawned :: any) :: InternalSignal<Humanoid>
	interface.Died = (internal.Died :: any) :: InternalSignal<Model, Humanoid>
	
	
	internal.character.Changed:Connect(function(newValue)
		internal.humanoid:Set(interface:GetHumanoidFromCharacter(newValue))
		internal.head:Set(interface:GetHeadFromCharacter(newValue))
		internal.root:Set(interface:GetRootFromCharacter(newValue))
	end)
	
	internal.humanoid.Changed:Connect(function(newValue)
		if newValue then
			local connection, stateConnection
			
			internal.Respawned:Fire(newValue)
			
			internal.animator:Set(interface:GetAnimatorFromHumanoid(newValue))
			
			stateConnection = newValue.StateChanged:Connect(function(old, new)
				internal.state:Set(old, new)
			end)
			
			internal.state:Set(internal.state:Get(), newValue:GetState())
			
			connection = newValue.Died:Connect(function()
				internal.Died:Fire(internal.character:Get() :: Model, newValue)
				
				connection:Disconnect()
				stateConnection:Disconnect()
			end)
		end
	end)
	
	internal.player:Set(Player)
	
	local character = interface:GetCharacterFromPlayerAsync(Player)
	
	if character then
		internal.character:Set(character)
	end
	
	Player.CharacterAdded:Connect(function(newCharacter)
		internal.character:Set(newCharacter)
	end)
end


return interface