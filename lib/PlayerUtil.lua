--!strict
--[[================================================================================================

PlayerUtil | Written by Devi (@Devollin) | 2022 | v1.0.0
	Description: Library of helpful player / character related functions.
	
Additional credits to:
	Mia (@iGottic) - Cleanup & various modifications

==================================================================================================]]


local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Signal = require(script.Parent:WaitForChild("Signal"))
local Value = require(script.Parent:WaitForChild("Value"))

type Value<b...> = Value.Value<b...>
type Signal<b...> = Signal.Signal<b...>

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
	local character: Model? = if player then player.Character else nil
	
	return character
end

--[=[
	Returns the character of a given Player, or waits until the character exists.
	@within PlayerUtil
	@yields
]=]
function interface:GetCharacterFromPlayer(player: Player?): Model?
	local character: Model? = if player then (player.Character or player.CharacterAdded:Wait()) else nil
	
	return character
end

--[=[
	Returns the humanoid of a given character, if it exists; and waits if it doesn't.
	@within PlayerUtil
	@yields
]=]
function interface:GetHumanoidFromCharacter(character: Model?): Humanoid?
	local humanoid = if character then character:WaitForChild("Humanoid", 1) else nil
	
	return humanoid :: Humanoid?
end

--[=[
	Returns the humanoid of a given character, or nil if it doesn't exist.
	@within PlayerUtil
]=]
function interface:GetHumanoidFromCharacterAsync(character: Model?): Humanoid?
	local humanoid: Humanoid? = if character then character:FindFirstChildOfClass("Humanoid") else nil
	
	return humanoid
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
]=]
function interface:GetRootFromCharacter(character: Model?): BasePart?
	local root: BasePart? = if character then character.PrimaryPart else nil
	
	return root
end

--[=[
	Returns the root part of the given player, if it exists; or waits if it doesn't.
	@within PlayerUtil
	@yields
]=]
function interface:GetRootFromPlayer(player: Player?): BasePart?
	local character : Model? = interface:GetCharacterFromPlayer(player)
	local root: BasePart? = if character then character.PrimaryPart else nil
	
	return root
end

--[=[
	Returns the root part of the given player, if it exists.
	@within PlayerUtil
]=]
function interface:GetRootFromPlayerAsync(player: Player?): BasePart?
	local character: Model? = interface:GetCharacterFromPlayerAsync(player)
	local root: BasePart? = if character then character.PrimaryPart else nil
	
	return root
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
	local assumedCharacter: Model? = if part then part:FindFirstAncestorOfClass("Model") else nil
	local player: Player? = if assumedCharacter then Players:FindFirstChild(assumedCharacter.Name) else nil
	
	return player
end

--[=[
	Returns the character from a part, if there is one.
	@within PlayerUtil
]=]
function interface:GetCharacterFromPart(part: BasePart?): Model?
	local assumedCharacter: Model? = if part then part:FindFirstAncestorOfClass("Model") else nil
	local humanoid: Humanoid? = if assumedCharacter then assumedCharacter:FindFirstChildOfClass("Humanoid") else nil
	
	if assumedCharacter and humanoid then
		return assumedCharacter
	end
	
	return
end

--[=[
	Returns the tool from a given player and tool name, if it can be found.
	@within PlayerUtil
]=]
function interface:GetToolFromPlayerByName(player: Player?, name: string): Tool?
	local character: Model? = if player then interface:GetCharacterFromPlayerAsync(player) else nil
	
	if character then
		local find: Instance? = character:FindFirstChild(name)
		
		if find and find:IsA("Tool") then
			return find
		end
	end
	
	local backpack: Backpack? = if player then player:FindFirstChildOfClass("Backpack") else nil
	
	if backpack then
		local find: Instance? = backpack:FindFirstChild(name)
		
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
	local head = if character then character:FindFirstChild("Head") else nil
	
	if head and head:IsA("BasePart") then
		return head
	end
	
	return
end

--[=[
	Returns the head of the given character, if it exists; and waits if it doesn't.
	@within PlayerUtil
	@yields
]=]
function interface:GetHeadFromCharacter(character: Model?): BasePart?
	local head = if character then character:WaitForChild("Head", 1) else nil
	
	if head and head:IsA("BasePart") then
		return head
	end
	
	return
end

--[=[
	Returns the head of the given player, if it exists.
	@within PlayerUtil
]=]
function interface:GetHeadFromPlayerAsync(player: Player?): BasePart?
	local character: Model? = if player then interface:GetCharacterFromPlayerAsync(player) else nil
	local head = if character then character:FindFirstChild("Head") else nil
	
	if head and head:IsA("BasePart") then
		return head
	end
	
	return
end

--[=[
	Returns the head of the given player, if it exists; and waits if it doesn't.
	@within PlayerUtil
	@yields
]=]
function interface:GetHeadFromPlayer(player: Player?): BasePart?
	local character: Model? = if player then interface:GetCharacterFromPlayer(player) else nil
	local head = if character then character:WaitForChild("Head", 1) else nil
	
	if head and head:IsA("BasePart") then
		return head
	end
	
	return
end

--[=[
	Returns the animator of the given humanoid, if it exists.
	@within PlayerUtil
]=]
function interface:GetAnimatorFromHumanoidAsync(humanoid: Humanoid?): Animator?
	local animator: Animator? = if humanoid then humanoid:FindFirstChildOfClass("Animator") else nil
	
	return animator
end

--[=[
	Returns the animator of the given humanoid, if it exists; and waits if it doesn't.
	@within PlayerUtil
	@yields
]=]
function interface:GetAnimatorFromHumanoid(humanoid: Humanoid?): Animator?
	local animator = if humanoid then humanoid:WaitForChild("Animator", 1) else nil
	
	if animator and animator:IsA("Animator") then
		return animator
	end
	
	return
end

--[=[
	Returns the animator of the given character, if it exists.
	@within PlayerUtil
]=]
function interface:GetAnimatorFromCharacterAsync(character: Model?): Animator?
	local humanoid: Humanoid? = if character then interface:GetHumanoidFromCharacterAsync(character) else nil
	local animator: Animator? = if humanoid then interface:GetAnimatorFromHumanoidAsync(humanoid) else nil
	
	return animator
end

--[=[
	Returns the animator of the given character, if it exists; and waits if it doesn't.
	@within PlayerUtil
	@yields
]=]
function interface:GetAnimatorFromCharacter(character: Model?): Animator?
	local humanoid: Humanoid? = if character then interface:GetHumanoidFromCharacter(character) else nil
	local animator: Animator? = if humanoid then interface:GetAnimatorFromHumanoid(humanoid) else nil
	
	return animator
end

--[=[
	Returns the animator of the given player, if it exists.
	@within PlayerUtil
]=]
function interface:GetAnimatorFromPlayerAsync(player: Player?): Animator?
	local character: Model? = if player then interface:GetCharacterFromPlayerAsync(player) else nil
	local animator: Animator? = if character then interface:GetAnimatorFromCharacterAsync(character) else nil
	
	return animator
end

--[=[
	Returns the animator of the given player, if it exists; and waits if it doesn't.
	@within PlayerUtil
	@yields
]=]
function interface:GetAnimatorFromPlayer(player: Player?): Animator?
	local character: Model? = if player then interface:GetCharacterFromPlayer(player) else nil
	local animator: Animator? = if character then interface:GetAnimatorFromCharacter(character) else nil
	
	return animator
end


--[=[
	@prop player Value<Player>
	A reference to the [Player].
	
	@within PlayerUtil
	@client
]=]
--[=[
	@prop character Value<Model?>
	A reference to the [Player]'s character [Model].
	
	@within PlayerUtil
	@client
]=]
--[=[
	@prop humanoid Value<Humanoid>
	A reference to the [Humanoid] of the [Player].
	
	@within PlayerUtil
	@client
]=]
--[=[
	@prop animator Value<Animator?>
	A reference to the [Player]'s [Animator].
	
	@within PlayerUtil
	@client
]=]
--[=[
	@prop head Value<BasePart?>
	A reference to the [Player]'s head [BasePart].
	
	@within PlayerUtil
	@client
]=]
--[=[
	@prop root Value<BasePart?>
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
	local Player = Players.LocalPlayer
	
	interface.player = Value.new(Player) :: Value<Player>
	interface.character = Value.new() :: Value<Model?>
	interface.humanoid = Value.new() :: Value<Humanoid?>
	
	interface.animator = Value.new() :: Value<Animator?>
	interface.head = Value.new() :: Value<BasePart?>
	interface.root = Value.new() :: Value<BasePart?>
	
	interface.state = Value.new() :: Value<Enum.HumanoidStateType?, Enum.HumanoidStateType?>
	
	interface.Respawned = Signal.new() :: Signal<Humanoid>
	interface.Died = Signal.new() :: Signal<Model, Humanoid>
	
	interface.character.Changed:Connect(function(newValue)
		interface.humanoid:Set(interface:GetHumanoidFromCharacter(newValue))
		interface.head:Set(interface:GetHeadFromCharacter(newValue))
		interface.root:Set(interface:GetRootFromCharacter(newValue))
	end)
	
	interface.humanoid.Changed:Connect(function(newValue)
		if newValue then
			local connection, stateConnection
			
			interface.Respawned:Fire(newValue)
			
			interface.animator:Set(interface:GetAnimatorFromHumanoid(newValue))
			
			stateConnection = newValue.StateChanged:Connect(function(old, new)
				interface.state:Set(old, new)
			end)
			
			interface.state:Set(interface.state:Get(), newValue:GetState())
			
			connection = newValue.Died:Connect(function()
				interface.Died:Fire(interface.character:Get() :: Model, newValue)
				
				connection:Disconnect()
				stateConnection:Disconnect()
			end)
		end
	end)
	
	interface.player:Set(Player)
	
	local character = interface:GetCharacterFromPlayerAsync(Player)
	
	if character then
		interface.character:Set(character)
	end
	
	Player.CharacterAdded:Connect(function(newCharacter)
		interface.character:Set(newCharacter)
	end)
end


return interface