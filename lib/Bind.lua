--!strict
--[[================================================================================================

Bind | Written by Devi (@Devollin) | 2022 | v1.0.0
	Description: A Bind class that is used as an interface for binding keys to ContextActionService.
	
==================================================================================================]]


local ContextActionService = game:GetService("ContextActionService")

local Bind = {}


type Keys = {Enum.KeyCode}
type BoundFunction = (actionName: string, state: Enum.UserInputState, input: InputObject) -> ()

export type Bind = {
	boundFunction: BoundFunction,
	keys: Keys,
	
	Rebind: <a>(self: a, newKeys: Keys) -> (),
	Enable: <a>(self: a) -> (),
	Disable: <a>(self: a) -> (),
	Destroy: <a>(self: a) -> (),
}


--[=[
	@type Keys {Enum.KeyCode}
	A list of Enum.KeyCode to bind an action to.
	
	@within Bind
]=]
--[=[
	@type BoundFunction (actionName: string, state: Enum.UserInputState, input: InputObject) -> ()
	A function used to bind context actions to.
	
	@within Bind
]=]

--[=[
	@class Bind
	@client
	A [Bind] class that is used as an interface for binding keys to ContextActionService.
]=]

--[=[
	@prop boundFunction BoundFunction
	Function bound to the given [Keys].
	
	@within Bind
]=]
--[=[
	@prop keys Keys
	[Keys] bound to the action.
	
	@within Bind
]=]

--[=[
	Returns a new Bind class.
	
	@param name -- The name of the action.
	@param keys -- The list of keys you want to bind.
	@param boundFunction -- Function that the binding is bound to.
	@param enabled -- Determines if the binding should be enabled upon creation; defaults to true.
	@param mobileButton -- Determines if a mobile button should be added with this binding; defaults to false.
	
	```lua
	local newBind = Bind.new("Test", {Enum.KeyCode.E}, function(actionName, state, input)
		print("Wow!")
	end)
	```
	
	@within Bind
]=]
function Bind.new(name: string, keys: Keys, boundFunction: BoundFunction?, enabled: boolean?, mobileButton: boolean?): Bind
	mobileButton =
		if mobileButton == nil then false
		else mobileButton
	
	enabled =
		if enabled == nil then true
		else enabled
	
	local object = {
		boundFunction = (
			if boundFunction then boundFunction
				else function(...: any)
					
				end
		) :: BoundFunction,
		keys = keys,
	}
	
	--[=[
		Replaces the bound function mapped to new keys.
		@within Bind
	]=]
	function object:Rebind(newKeys: Keys)
		local success, result = pcall(function()
			ContextActionService:UnbindAction(name)
		end)
		
		object.keys = newKeys
		
		ContextActionService:BindAction(name, function(actionName: string, state: Enum.UserInputState, input: InputObject)
			if name == actionName then
				if enabled then
					object.boundFunction(actionName, state, input)
				end
			end
		end, mobileButton, table.unpack(newKeys))
	end
	
	--[=[
		Enables the [Bind].
		@within Bind
	]=]
	function object:Enable()
		enabled = true
	end
	
	--[=[
		Disables the [Bind].
		@within Bind
	]=]
	function object:Disable()
		enabled = false
	end
	
	--[=[
		Destroys the [Bind].
		@within Bind
	]=]
	function object:Destroy()
		ContextActionService:UnbindAction(name)
	end
	
	
	object:Rebind(keys)
	
	
	return object
end


return Bind