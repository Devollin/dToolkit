--!strict
--[[================================================================================================

Network | Written by Devi (@Devollin) | 2022 | v1.0.3
	Description: A library to handle networking easily.
	
Additional credits to:
	Mia (@iGottic) - Cleanup & various modifications
	
==================================================================================================]]


--[=[
	@class Network
	A library to handle networking easily.
	
	:::caution
	In dToolkit version 1.0.1 and onwards, Network has been split into Network.Client and Network.Server; make sure to update
	your references!
	
	This has been done to resolve all typechecking-related errors, and to make usage easier!
]=]

return {
	Client = require(script:WaitForChild("Client")),
	Server = require(script:WaitForChild("Server")),
}