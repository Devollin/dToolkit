--!strict
--[[======================================================================

Network | Written by Devi (@Devollin) | 2022 | v1.0.0
	Description: A library to handle Networking more easily.
	
Additional credits to:
	Mia (@iGottic) - Cleanup & various modifications
	
========================================================================]]


local RunService = game:GetService("RunService")


--[=[
	@class Network
	A library to handle networking more easily.
]=]

if RunService:IsClient() then
	return require(script:WaitForChild("Client"))
else
	return require(script:WaitForChild("Server"))
end