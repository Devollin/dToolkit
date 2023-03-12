--!strict
--[[================================================================================================

Queue | Written by Devi (@Devollin) | 2023 | v1.0.0
	Description: A Queue class is used to hold a list of items which are accessible through a
		first-in, first-out format.
	
==================================================================================================]]


export type Queue<a> = {
	ClassName: "Queue",
	
	Add: (self: Queue<a>, item: a) -> (),
	Next: (self: Queue<a>) -> (),
	Get: (self: Queue<a>) -> (a),
	Pop: (self: Queue<a>) -> (a),
	Clear: (self: Queue<a>) -> (),
	Remove: (self: Queue<a>, item: a) -> (),
	IsEmpty: (self: Queue<a>) -> (boolean),
	Destroy: (self: Queue<a>) -> (),
}


--[=[
	@class Queue
	A Queue class is used to hold a list of items which are accessible through a first-in, first-out format.
	
	```lua
	local queue = Queue.new(1, 2, 3, 4)
	
	queue:Add(5)
	
	queue:Next()
	
	print(queue:Get())
	
	queue:Remove(1)
	
	if not queue:IsEmpty() then
		queue:Clear()
	end
	
	queue:Destroy()
	```
]=]
local Queue = {}


--[=[
	Creates a new [Queue] object.
	
	```lua
	local queue = Queue.new(1, 2, 3, 4)
	
	queue:Add(5)
	
	print(queue:Get())
	
	queue:Next()
	
	queue:Remove(2)
	
	print(queue:Pop())
	```
	
	@param ... -- The initial list of items to hold in the [Queue].
	
	@within Queue
]=]
function Queue.new<a>(...: a): Queue<a>
	local object = {ClassName = "Queue" :: "Queue"}
	local list = {...}
	
	
	--[=[
		Adds an item to the end of the [Queue].
		
		```lua
		queue:Add(5)
		```
		
		@within Queue
	]=]
	function object.Add(self: Queue<a>, item: a)
		table.insert(list, item)
	end
	
	--[=[
		Removes the item at the front of the [Queue].
		
		```lua
		print(queue:Get())
		
		queue:Next()
		
		print(queue:Get())
		```
		
		@within Queue
	]=]
	function object.Next(self: Queue<a>)
		if object:IsEmpty() then
			warn("Queue is empty; be sure to check for this by using Queue:IsEmpty()!")
		end
		
		table.remove(list, 1)
	end
	
	--[=[
		Returns the item at the front of the [Queue]. This will return nil if the [Queue] is empty. It
		is recommended to check if the [Queue] is empty by using [Queue]:IsEmpty() before using this.
		
		```lua
		print(queue:Get())
		```
		
		@within Queue
	]=]
	function object.Get(self: Queue<a>): a
		if object:IsEmpty() then
			warn("Queue is empty; be sure to check for this by using Queue:IsEmpty()!")
		end
		
		return list[1]
	end
	
	--[=[
		Returns the item at the front of the [Queue] and removes it from the [Queue]. This will return
		nil if the [Queue] is empty. It is recommended to check if the [Queue] is empty by using
		[Queue]:IsEmpty() before using this.
		
		```lua
		print(queue:Pop())
		```
		
		@within Queue
	]=]
	function object.Pop(self: Queue<a>): a
		local value = object:Get()
		
		object:Next()
		
		return value
	end
	
	--[=[
		Clears out the [Queue] of all values. The [Queue] object remains usable.
		
		```lua
		if not queue:IsEmpty() then
			queue:Clear()
		end
		```
		
		@within Queue
	]=]
	function object.Clear(self: Queue<a>)
		table.clear(list)
	end
	
	--[=[
		Removes a value from the [Queue] if is in the list.
		
		```lua
		queue:Remove(2)
		```
		
		@within Queue
	]=]
	function object.Remove(self: Queue<a>, item: a)
		local index = table.find(list, item)
		
		if index then
			table.remove(list, index)
		end
	end
	
	--[=[
		Returns a boolean describing if the [Queue] is empty.
		
		```lua
		if not queue:IsEmpty() then
			queue:Clear()
		end
		```
		
		@within Queue
	]=]
	function object.IsEmpty(self: Queue<a>): boolean
		return #list == 0
	end
	
	--[=[
		Clears the list and renders the [Queue] object unusable.
		
		```lua
		queue:Destroy()
		```
		
		@within Queue
	]=]
	function object.Destroy(self: Queue<a>)
		table.clear(list)
		
		list = nil :: any
		
		table.clear(object)
	end
	
	
	return object
end


return Queue