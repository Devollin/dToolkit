--!strict
--[[================================================================================================

Stack | Written by Devi (@Devollin) | 2023 | v1.0.0
	Description: A Stack class is used to hold a list of items which are accessible through a last-in,
		first-out format.
	
==================================================================================================]]


export type Stack<a> = {
	ClassName: "Stack",
	
	Add: (self: Stack<a>, item: a) -> (),
	Next: (self: Stack<a>) -> (),
	Get: (self: Stack<a>) -> (a),
	Pop: (self: Stack<a>) -> (a),
	Clear: (self: Stack<a>) -> (),
	Remove: (self: Stack<a>, item: a) -> (),
	IsEmpty: (self: Stack<a>) -> (boolean),
	Destroy: (self: Stack<a>) -> (),
}


--[=[
	@class Stack
	A Stack class is used to hold a list of items which are accessible through a last-in, first-out
	format.
	
	```lua
	local stack = Stack.new(1, 2, 3, 4)
	
	stack:Add(5)
	
	stack:Next()
	
	print(stack:Get())
	
	stack:Remove(1)
	
	print(stack:Pop())
	
	if not stack:IsEmpty() then
		stack:Clear()
	end
	
	stack:Destroy()
	```
]=]
local Stack = {}


--[=[
	Creates a new [Stack] object.
	
	```lua
	local stack = Stack.new(1, 2, 3, 4)
	```
	
	@param ... -- The initial list of items to hold in the [Stack].
	
	@within Stack
]=]
function Stack.new<a>(...: a): Stack<a>
	local object = {ClassName = "Stack" :: "Stack"}
	local list = {}
	
	
	--[=[
		Adds an item to the top of the [Stack].
		
		```lua
		stack:Add(5)
		```
		
		@within Stack
	]=]
	function object.Add(self: Stack<a>, item: a)
		table.insert(list, item)
	end
	
	--[=[
		Returns the item at the top of the [Stack] and removes it from the [Stack]. This will return
		nil if the [Stack] is empty. It is recommended to check if the [Stack] is empty by using
		[Stack]:IsEmpty() before using this.
		
		```lua
		print(stack:Pop())
		```
		
		@within Stack
	]=]
	function object.Pop(self: Stack<a>): a
		local value = object:Get()
		
		object:Next()
		
		return value
	end
	
	--[=[
		Removes the item at the top of the [Stack].
		
		```lua
		print(stack:Get())
		
		stack:Next()
		
		print(stack:Get())
		```
		
		@within Stack
	]=]
	function object.Next(self: Stack<a>)
		if object:IsEmpty() then
			warn("Stack is empty; be sure to check for this by using Stack:IsEmpty()!")
		end
		
		list[#list] = nil
	end
	
	--[=[
		Returns the item at the top of the [Stack]. This will return nil if the [Stack] is empty. It
		is recommended to check if the [Stack] is empty by using [Stack]:IsEmpty() before using this.
		
		```lua
		print(stack:Get())
		```
		
		@within Stack
	]=]
	function object.Get(self: Stack<a>): a
		if object:IsEmpty() then
			warn("Stack is empty; be sure to check for this by using Stack:IsEmpty()!")
		end
		
		return list[#list]
	end
	
	--[=[
		Clears out the [Stack] of all values. The [Stack] object remains usable.
		
		```lua
		if not stack:IsEmpty() then
			stack:Clear()
		end
		```
		
		@within Stack
	]=]
	function object.Clear(self: Stack<a>)
		table.clear(list)
	end
	
	--[=[
		Removes a value from the [Stack] if is in the list.
		
		```lua
		stack:Remove(1)
		```
		
		@within Stack
	]=]
	function object.Remove(self: Stack<a>, item: a)
		local index = table.find(list, item)
		
		if index then
			table.remove(list, index)
		end
	end
	
	--[=[
		Returns a boolean describing if the [Stack] is empty.
		
		```lua
		if not stack:IsEmpty() then
			stack:Clear()
		end
		```
		
		@within Stack
	]=]
	function object.IsEmpty(self: Stack<a>): boolean
		return #list == 0
	end
	
	--[=[
		Clears the list and renders the [Stack] object unusable.
		
		```lua
		stack:Destroy()
		```
		
		@within Stack
	]=]
	function object.Destroy(self: Stack<a>)
		table.clear(list)
		
		list = nil :: any
		
		table.clear(object)
	end
	
	
	for _, value in {...} do
		table.insert(list, value)
	end
	
	
	return object
end


return Stack