--!strict
--[[======================================================================

Bind | Written by Devi (@Devollin) | 2022 | v1.0.0
	Description: A Bind class that is used as an interface for binding
		keys to ContextActionService.
	
========================================================================]]


local ContextActionService = game:GetService("ContextActionService")

local Bind = {}


type Keys = {Enum.KeyCode}
type BoundFunction = (actionName: string, state: Enum.UserInputState, input: InputObject) -> (...any)

export type Bind = {
	boundFunction: BoundFunction,
	keys: Keys,
	
	Rebind: <a>(self: a, newKeys: Keys) -> (),
	Enable: <a>(self: a) -> (),
	Disable: <a>(self: a) -> (),
	Destroy: <a>(self: a) -> (),
}

--[=[
	@class Bind
	
	A Bind class that is used as an interface for binding keys to ContextActionService.
	@param name string -- The name of the action.
	@param keys {Enum.KeyCode} -- The list of keys you want to bind.
	@param boundFunction BoundFunction -- Function that the binding is bound to.
	@param enabled boolean? -- Determines if the binding should be enabled upon creation; defaults to true.
	@param mobileButton boolean? -- Determines if a mobile button should be added with this binding; defaults to false.
	
	@return Bind
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
		
		@param keys {Enum.KeyCode} -- The list of keys you want to bind.
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
	Enables the binding.
	]=]
	function object:Enable()
		enabled = true
	end
	
	--[=[
	Disables the binding.
	]=]
	function object:Disable()
		enabled = false
	end
	
	--[=[
	Destroys the binding.
	]=]
	function object:Destroy()
		ContextActionService:UnbindAction(name)
	end
	
	
	object:Rebind(keys)
	
	
	return object
end


return Bind