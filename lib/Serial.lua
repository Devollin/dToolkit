--!strict
--[[================================================================================================

Serial | Written by Devi (@Devollin) | 2021 | v1.0.0
	Description: A library used to serialize / deserialize any data type.
	
==================================================================================================]]


type Vector3Data = {x: number, y: number, z: number}
type Vector2Data = {x: number, y: number}
type UDimData = {scale: number, offset: number}
type NumberSequenceKeypointData = {t: number, v: number, e: number}


local serializers = {}
local deserializers = {}
local interface = {}


--================================================================================================--


function serializers.CFrame(input: CFrame): {number}
	return table.pack(input:GetComponents())
end

function serializers.Vector3(input: Vector3): Vector3Data
	return {x = input.X, y = input.Y, z = input.Z}
end

function serializers.Vector3int16(input: Vector3int16): Vector3Data
	return {x = input.X, y = input.Y, z = input.Z}
end

function serializers.Vector2(input: Vector2): Vector2Data
	return {x = input.X, y = input.Y}
end

function serializers.Vector2int16(input: Vector2int16): Vector2Data
	return {x = input.X, y = input.Y}
end

function serializers.Color3(input: Color3): string
	return input:ToHex()
end

function serializers.Rect(input: Rect): {number}
	return {input.Min.X, input.Min.Y, input.Max.X, input.Max.Y}
end

function serializers.UDim(input: UDim): UDimData
	return {scale = input.Scale, offset = input.Offset}
end

function serializers.UDim2(input: UDim2): {x: UDimData, y: UDimData}
	return {x = serializers.UDim(input.X), y = serializers.UDim(input.Y)}
end

function serializers.NumberRange(input: NumberRange): {min: number, max: number}
	return {min = input.Min, max = input.Max}
end

function serializers.number(input: number): number
	return input
end

function serializers.boolean(input: boolean): boolean
	return input
end

function serializers.string(input: string): string
	return input
end

function serializers.Region3(input: Region3): {size: Vector3Data, cframe: {number}}
	return {size = serializers.Vector3(input.Size), cframe = serializers.CFrame(input.CFrame)}
end

function serializers.Region3int16(input: Region3int16): {min: Vector3Data, max: Vector3Data}
	return {min = serializers.Vector3int16(input.Min), max = serializers.Vector3int16(input.Max)}
end

function serializers.ColorSequenceKeypoint(input: ColorSequenceKeypoint): {t: number, color: string}
	return {t = input.Time, color = serializers.Color3(input.Value)}
end

function serializers.ColorSequence(input: ColorSequence): {{t: number, color: string}}
	local sequences = {}
	
	for _, keypoint in input.Keypoints do
		table.insert(sequences, serializers.ColorSequenceKeypoint(keypoint))
	end
	
	return sequences
end

function serializers.NumberSequenceKeypoint(input: NumberSequenceKeypoint): NumberSequenceKeypointData
	return {t = input.Time, v = input.Value, e = input.Envelope}
end

function serializers.NumberSequence(input: NumberSequence): {NumberSequenceKeypointData}
	local sequences = {}
	
	for _, keypoint in input.Keypoints do
		table.insert(sequences, serializers.NumberSequenceKeypoint(keypoint))
	end
	
	return sequences
end

function serializers.EnumItem(input: EnumItem): {type: string, name: string}
	return {
		type = tostring(input.EnumType),
		name = input.Name,
	}
end


--================================================================================================--


function deserializers.CFrame(input: {number}): CFrame
	return CFrame.new(table.unpack(input))
end

function deserializers.Vector3(input: Vector3Data): Vector3
	return Vector3.new(input.x, input.y, input.z)
end

function deserializers.Vector3int16(input: Vector3Data): Vector3int16
	return Vector3int16.new(input.x, input.y, input.z)
end

function deserializers.Vector2(input: Vector2Data): Vector2
	return Vector2.new(input.x, input.y)
end

function deserializers.Vector2int16(input: Vector2Data): Vector2int16
	return Vector2int16.new(input.x, input.y)
end

function deserializers.Color3(input: string): Color3
	return Color3.fromHex(input)
end

function deserializers.Rect(input: {number}): Rect
	return Rect.new(input[1], input[2], input[3], input[4])
end

function deserializers.UDim(input: UDimData): UDim
	return UDim.new(input.scale, input.offset)
end

function deserializers.UDim2(input: {x: UDimData, y: UDimData}): UDim2
	return UDim2.new(deserializers.UDim(input.x), deserializers.UDim(input.y))
end

function deserializers.NumberRange(input: {min: number, max: number}): NumberRange
	return NumberRange.new(input.min, input.max)
end

function deserializers.number(input: number): number
	return input
end

function deserializers.boolean(input: boolean): boolean
	return input
end

function deserializers.string(input: string): string
	return input
end

function deserializers.Region3(input: {size: Vector3Data, cframe: {number}}): Region3
	local cframe = deserializers.CFrame(input.cframe)
	local size = deserializers.Vector3(input.size)
	
	return Region3.new(cframe.Position - (size / 2), cframe.Position + (size / 2))
end

function deserializers.Region3int16(input: {min: Vector3Data, max: Vector3Data}): Region3int16
	local min = input.min
	local max = input.max
	
	return Region3int16.new(Vector3int16.new(min.x, min.y, min.z), Vector3int16.new(max.x, max.y, max.z))
end

function deserializers.ColorSequenceKeypoint(input: {t: number, color: string}): ColorSequenceKeypoint
	return ColorSequenceKeypoint.new(input.t, deserializers.Color3(input.color))
end

function deserializers.ColorSequence(input: {{t: number, color: string}}): ColorSequence
	local sequences = {}
	
	for _, keypoint in input do
		table.insert(sequences, deserializers.ColorSequenceKeypoint(keypoint))
	end
	
	return ColorSequence.new(sequences)
end

function deserializers.NumberSequenceKeypoint(input: NumberSequenceKeypointData): NumberSequenceKeypoint
	return NumberSequenceKeypoint.new(input.t, input.v, input.e)
end

function deserializers.NumberSequence(input: {NumberSequenceKeypointData}): NumberSequence
	local sequences = {}
	
	for _, keypoint in input do
		table.insert(sequences, deserializers.NumberSequenceKeypoint(keypoint))
	end
	
	return NumberSequence.new(sequences)
end

function deserializers.EnumItem(input: {type: string, name: string}): EnumItem
	return Enum[input.type][input.name]
end


--================================================================================================--


--[=[
	@class Serial
	A library used to serialize / deserialize any data type.
]=]

--[=[
	Serializes the given input, if supported.
	
	@param input -- The data to be serialized.
	
	@return any -- The serialized data, or nil if it failed to serialize.
	
	@within Serial
]=]
function interface:Serialize(input: any): any
	local serializer = serializers[typeof(input)]
	
	if serializer then
		return serializer(input)
	end
	
	warn("Data of type '" .. typeof(input) .. "' does not seem to be supported; failed to serialize!")
	
	return
end

--[=[
	Serializes the given input, if supported.
	
	@param input -- The array of data to be serialized.
	
	@within Serial
]=]
function interface:SerializeList(input: {[any]: any}): {[any]: any}
	local result = {}
	
	for name, value in pairs(input) do
		if typeof(value) == "table" then
			result[name] = {type = "table", value = interface:SerializeList(value)}
		else
			local newValue = interface:Serialize(value)
			
			if newValue ~= nil then
				result[name] = {type = typeof(value), value = newValue}
			end
		end
	end
	
	return result
end

--[=[
	Deserializes the given input, if supported.
	
	@param input -- The data to be deserialized.
	
	@return any -- The deserialized data, or nil if it failed to deserialize.
	
	@within Serial
]=]
function interface:Deserialize(input: any): any
	local deserializer = deserializers[input.type]
	
	if deserializer then
		return deserializer(input.value)
	end
	
	warn("Data of type '" .. typeof(input.type) .. "' does not seem to be supported; failed to deserialize!")
	
	return
end

--[=[
	Deserializes the given input, if supported.
	
	@param input -- The array of data to be deserialized.
	
	@within Serial
]=]
function interface:DeserializeList(input: {[any]: any}): {[any]: any}
	local result = {}
	
	for name, value in pairs(input) do
		if value.type == "table" then
			result[name] = interface:DeserializeList(value.value)
		else
			local newValue = interface:Deserialize(value)
			
			if newValue ~= nil then
				result[name] = newValue
			end
		end
	end
	
	return result
end


return interface