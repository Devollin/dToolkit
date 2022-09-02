--!strict
--[[======================================================================

Types | Written by Devi (@Devollin) | 2022 | v1.0.0
	Description: Contains a list of userdata functions used in easing.

========================================================================]]

return {
	CFrame = function(i: CFrame, g: CFrame, t: number): CFrame
		return i:Lerp(g, t)
	end,
	Vector3 = function(i: Vector3, g: Vector3, t: number): Vector3
		return i:Lerp(g, t)
	end,
	Vector3int16 = function(i: Vector3int16, g: Vector3int16, t: number): Vector3int16
		local lerped = Vector3.new(i.X, i.Y, i.Z):Lerp(Vector3.new(g.X, g.Y, g.Z), t)
		
		return Vector3int16.new(math.round(lerped.X), math.round(lerped.Y), math.round(lerped.Z))
	end,
	Vector2 = function(i: Vector2, g: Vector2, t: number): Vector2
		return i:Lerp(g, t)
	end,
	Vector2int16 = function(i: Vector2int16, g: Vector2int16, t: number): Vector2int16
		local lerped = Vector2.new(i.X, i.Y):Lerp(Vector2.new(g.X, g.Y), t)
		
		return Vector2int16.new(math.round(lerped.X), math.round(lerped.Y))
	end,
	Color3 = function(i: Color3, g: Color3, t: number): Color3
		return i:Lerp(g, t)
	end,
	Rect = function(i: Rect, g: Rect, t: number): Rect
		return Rect.new(i.Min:Lerp(g.Min, t), i.Max:Lerp(g.Max, t))
	end,
	UDim = function(i: UDim, g: UDim, t: number): UDim
		return UDim.new(((g.Scale - i.Scale) * t) + (i.Scale - g.Scale), ((g.Offset - i.Offset) * t) + (i.Offset - g.Offset))
	end,
	UDim2 = function(i: UDim2, g: UDim2, t: number): UDim2
		return i:Lerp(g, t)
	end,
	NumberRange = function(i: NumberRange, g: NumberRange, t: number): NumberRange
		return NumberRange.new(((g.Min - i.Min) * t) + (i.Min - g.Min), ((g.Max - i.Max) * t) + (i.Max - g.Max))
	end,
	number = function(i: number, g: number, t: number): number
		return i + ((g - i) * t)
	end,
	boolean = function(i: boolean, g: boolean, t: number): boolean
		return math.round(((g and 1 or 0) - (i and 1 or 0)) * t) == 1
	end,
	Region3 = function(i: Region3, g: Region3, t: number): Region3
		local m1 = (i.CFrame.RightVector * (i.Size.Z / 2))
			+ (i.CFrame.UpVector * (i.Size.Y / 2)) - (i.CFrame.LookVector * (i.Size.X / 2))
		
		local m2 = (g.CFrame.RightVector * (g.Size.Z / 2))
			+ (g.CFrame.UpVector * (g.Size.Y / 2)) - (g.CFrame.LookVector * (g.Size.X / 2))
		
		local a, b, c, d = i.CFrame.Position - m1, i.CFrame.Position + m1, g.CFrame.Position - m2, g.CFrame.Position + m2
		local e, f = a:Lerp(c, t), b:Lerp(d, t)
		
		return Region3.new(e, f)
	end,
	Region3int16 = function(i: Region3int16, g: Region3int16, t: number): Region3int16
		local iSize = Vector3.new(i.Max.X - i.Min.X, i.Max.Y - i.Min.Y, i.Max.Z - i.Min.Z)
		local gSize = Vector3.new(g.Max.X - g.Min.X, g.Max.Y - g.Min.Y, g.Max.Z - g.Min.Z)
		
		local iHalfSize = iSize / 2
		local gHalfSize = gSize / 2
		
		local iCFrame = CFrame.new(i.Min.X + iHalfSize.X, i.Min.Y + iHalfSize.Y, i.Min.Z + iHalfSize.Z)
		local gCFrame = CFrame.new(g.Min.X + gHalfSize.X, g.Min.Y + gHalfSize.Y, g.Min.Z + gHalfSize.Z)
		
		local m1 = (iCFrame.RightVector * (iSize.Z / 2))
			+ (iCFrame.UpVector * (iSize.Y / 2)) - (iCFrame.LookVector * (iSize.X / 2))
		
		local m2 = (gCFrame.RightVector * (gSize.Z / 2))
			+ (gCFrame.UpVector * (gSize.Y / 2)) - (gCFrame.LookVector * (gSize.X / 2))
		
		local a, b, c, d = iCFrame.Position - m1, iCFrame.Position + m1, gCFrame.Position - m2, gCFrame.Position + m2
		local e, f = a:Lerp(c, t), b:Lerp(d, t)
		
		return Region3int16.new(Vector3int16.new(e.X, e.Y, e.Z), Vector3int16.new(f.X, f.Y, f.Z))
	end,
	
	ColorSequence = function(i: ColorSequence, g: ColorSequence, t: number): ColorSequence
		return g -- TODO: Add in support for ColorSequence tweening!
	end,
	NumberSequence = function(i: NumberSequence, g: NumberSequence, t: number): NumberSequence
		return g -- TODO: Add in support for NumberSequence tweening!
	end,
}