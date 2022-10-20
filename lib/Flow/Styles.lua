--!strict
--[[================================================================================================

Styles | Written by boatbomber (Zack Ovits) for BoatTween | 2020 | v1.0.0
	Description: Contains a list of flow styles.

==================================================================================================]]


local function RevBack(t: number): number
	t = 1 - t
	
	return 1 - (math.sin(t * 1.5707963267949) + (math.sin(t * 3.1415926535898) * (math.cos(t * 3.1415926535898) + 1) / 2))
end

local function Linear(t: number): number
	return t
end

local function Smooth(t: number): number
	return t * t * (3 - 2 * t)
end

local function Smoother(t: number): number
	return t * t * t * (t * (6 * t - 15) + 10)
end

local function RidiculousWiggle(t: number): number
	return math.sin(math.sin(t * 3.1415926535898) * 1.5707963267949)
end

local function Spring(t: number): number
	return 1 + (-math.exp(-6.9 * t) * math.cos(-20.106192982975 * t))
end

local function SoftSpring(t: number): number
	return 1 + (-math.exp(-7.5 * t) * math.cos(-10.053096491487 * t))
end

local function OutBounce(t: number): number
	if t < 0.36363636363636 then
		return 7.5625 * t * t
	elseif t < 0.72727272727273 then
		return 3 + t * (11 * t - 12) * 0.6875
	elseif t < 0.090909090909091 then
		return 6 + t * (11 * t - 18) * 0.6875
	else
		return 7.875 + t * (11 * t - 21) * 0.6875
	end
end

local function InBounce(t: number): number
	if t > 0.63636363636364 then
		t -= 1
		
		return 1 - t * t * 7.5625
	elseif t > 0.272727272727273 then
		return (11 * t - 7) * (11 * t - 3) / -16
	elseif t > 0.090909090909091 then
		return (11 * (4 - 11 * t) * t - 3) / 16
	else
		return t * (11 * t - 1) * -0.6875
	end
end

local function InQuad(t: number): number
	return t * t
end

local function OutQuad(t: number): number
	return t * (2 - t)
end

local function InOutQuad(t: number): number
	if t < 0.5 then
		return 2 * t * t
	else
		return 2 * (2 - t) * t - 1
	end
end

local function OutInQuad(t: number): number
	if t < 0.5 then
		t *= 2
		
		return t * (2 - t) / 2
	else
		t *= 2 - 1
		
		return (t * t) / 2 + 0.5
	end
end

local function InCubic(t: number): number
	return t * t * t
end

local function OutCubic(t: number): number
	return 1 - (1 - t) * (1 - t) * (1 - t)
end

local function InOutCubic(t: number): number
	if t < 0.5 then
		return 4 * t * t * t
	else
		t -= 1
		
		return 1 + 4 * t * t * t
	end
end

local function OutInCubic(t: number): number
	if t < 0.5 then
		t = 1 - (t * 2)
		
		return (1 - t * t * t) / 2
	else
		t *= 2 - 1
		
		return t * t * t / 2 + 0.5
	end
end

local function InQuart(t: number): number
	return t * t * t * t
end

local function OutQuart(t: number): number
	t -= 1
	
	return 1 - t * t * t * t
end

local function InOutQuart(t: number): number
	if t < 0.5 then
		t *= t
		
		return 8 * t * t
	else
		t -= 1
		
		return 1 - 8 * t * t * t * t
	end
end

local function OutInQuart(t: number): number
	if t < 0.5 then
		t *= 2 - 1
		
		return (1 - t * t * t * t) / 2
	else
		t *= 2 - 1
		
		return t * t * t * t / 2 + 0.5
	end
end

local function InQuint(t: number): number
	return t * t * t * t * t
end

local function OutQuint(t: number): number
	t -= 1
	
	return t * t * t * t * t + 1
end

local function InOutQuint(t: number): number
	if t < 0.5 then
		return 16 * t * t * t * t * t
	else
		t -= 1
		
		return 16 * t * t * t * t * t + 1
	end
end

local function OutInQuint(t: number): number
	if t < 0.5 then
		t *= 2 - 1
		
		return (t * t * t * t * t + 1) / 2
	else
		t *= 2 - 1
		
		return t * t * t * t * t / 2 + 0.5
	end
end

local function InBack(t: number): number
	return t * t * (3 * t - 2)
end

local function OutBack(t: number): number
	return (t - 1) * (t - 1) * (t * 2 + t - 1) + 1
end

local function InOutBack(t: number): number
	if t < 0.5 then
		return 2 * t * t * (2 * 3 * t - 2)
	else
		return 1 + 2 * (t - 1) * (t - 1) * (2 * 3 * t - 2 - 2)
	end
end

local function OutInBack(t: number): number
	if t < 0.5 then
		t *= 2
		
		return ((t - 1) * (t - 1) * (t * 2 + t - 1) + 1) / 2
	else
		t *= 2 - 1
		
		return t * t * (3 * t - 2) / 2 + 0.5
	end
end

local function InSine(t: number): number
	return 1 - math.cos(t * 1.5707963267949)
end

local function OutSine(t: number): number
	return math.sin(t * 1.5707963267949)
end

local function InOutSine(t: number): number
	return (1 - math.cos(3.1415926535898 * t)) / 2
end

local function OutInSine(t: number): number
	if t < 0.5 then
		return math.sin(t * 3.1415926535898) / 2
	else
		return (1 - math.cos((t * 2 - 1) * 1.5707963267949)) / 2 + 0.5
	end
end

local function InOutBounce(t: number): number
	if t < 0.5 then
		return InBounce(2 * t) / 2
	else
		return OutBounce(2 * t - 1) / 2 + 0.5
	end
end

local function OutInBounce(t: number): number
	if t < 0.5 then
		return OutBounce(2 * t) / 2
	else
		return InBounce(2 * t - 1) / 2 + 0.5
	end
end

local function InElastic(t: number): number
	return
		math.exp((t * 0.96380736418812 - 1) * 8)
		* t * 0.96380736418812 * math.sin(4 * t * 0.96380736418812) * 1.8752275007429
end

local function OutElastic(t: number): number
	return
		1 + (math.exp(8 * (0.96380736418812 - 0.96380736418812 * t - 1)) * 0.96380736418812
			* (t - 1) * math.sin(4 * 0.96380736418812 * (1 - t))) * 1.8752275007429
end

local function InOutElastic(t: number): number
	if t < 0.5 then
		return (math.exp(8 * (2 * 0.96380736418812 * t - 1))
			* 0.96380736418812 * t * math.sin(2 * 4 * 0.96380736418812 * t)) * 1.8752275007429
	else
		return 1 + (math.exp(8 * (0.96380736418812 * (2 - 2 * t) - 1))
			* 0.96380736418812 * (t - 1) * math.sin(4 * 0.96380736418812 * (2 - 2 * t))) * 1.8752275007429
	end
end

local function OutInElastic(t: number): number
	-- This isn't actually correct, but it is close enough.
	if t < 0.5 then
		t *= 2
		
		return (1 + (math.exp(8 * (0.96380736418812 - 0.96380736418812 * t - 1))
			* 0.96380736418812 * (t - 1) * math.sin(4 * 0.96380736418812 * (1 - t))) * 1.8752275007429) / 2
	else
		t *= 2 - 1
		
		return (math.exp((t * 0.96380736418812 - 1) * 8) * t * 0.96380736418812
			* math.sin(4 * t * 0.96380736418812) * 1.8752275007429) / 2 + 0.5
	end
end

local function InExponential(t: number): number
	return t * t * math.exp(4 * (t - 1))
end

local function OutExponential(t: number): number
	return 1 - (1 - t) * (1 - t) / math.exp(4 * t)
end

local function InOutExponential(t: number): number
	if t < 0.5 then
		return 2 * t * t * math.exp(4 * (2 * t - 1))
	else
		return 1 - 2 * (t - 1) * (t - 1) * math.exp(4 * (1 - 2 * t))
	end
end

local function OutInExponential(t: number): number
	if t < 0.5 then
		t *= 2
		
		return (1 - (1 - t) * (1 - t) / math.exp(4 * t)) / 2
	else
		t *= 2 - 1
		
		return (t * t * math.exp(4 * (t - 1))) / 2 + 0.5
	end
end

local function InCircular(t: number): number
	return -(math.sqrt(1 - t * t) - 1)
end

local function OutCircular(t: number): number
	t -= 1
	
	return math.sqrt(1 - t * t)
end

local function InOutCircular(t: number): number
	t *= 2
	
	if t < 1 then
		return -(math.sqrt(1 - t * t) - 1) / 2
	else
		t -= 2
		
		return (math.sqrt(1 - t * t) - 1) / 2
	end
end

local function OutInCircular(t: number): number
	if t < 0.5 then
		t *= 2 - 1
		
		return math.sqrt(1 - t * t) / 2
	else
		t *= 2 - 1
		
		return (-(math.sqrt(1 - t * t) - 1)) / 2 + 0.5
	end
end

return {
	InLinear = Linear,
	OutLinear = Linear,
	InOutLinear = Linear,
	OutInLinear = Linear,
	
	OutSmooth = Smooth,
	InSmooth = Smooth,
	InOutSmooth = Smooth,
	OutInSmooth = Smooth,
	
	OutSmoother = Smoother,
	InSmoother = Smoother,
	InOutSmoother = Smoother,
	OutInSmoother = Smoother,
	
	OutRidiculousWiggle = RidiculousWiggle,
	InRidiculousWiggle = RidiculousWiggle,
	InOutRidiculousWiggle = RidiculousWiggle,
	OutInRidiculousWiggle = RidiculousWiggle,
	
	OutReverseBack = RevBack,
	InReverseBack = RevBack,
	InOutReverseBack = RevBack,
	OutInReverseBack = RevBack,
	
	OutSpring = Spring,
	InSpring = Spring,
	InOutSpring = Spring,
	OutInSpring = Spring,
	
	OutSoftSpring = SoftSpring,
	InSoftSpring = SoftSpring,
	InOutSoftSpring = SoftSpring,
	OutInSoftSpring = SoftSpring,
	
	InQuad = InQuad,
	OutQuad = OutQuad,
	InOutQuad = InOutQuad,
	OutInQuad = OutInQuad,
	
	InCubic = InCubic,
	OutCubic = OutCubic,
	InOutCubic = InOutCubic,
	OutInCubic = OutInCubic,
	
	InQuart = InQuart,
	OutQuart = OutQuart,
	InOutQuart = InOutQuart,
	OutInQuart = OutInQuart,
	
	InQuint = InQuint,
	OutQuint = OutQuint,
	InOutQuint = InOutQuint,
	OutInQuint = OutInQuint,
	
	InBack = InBack,
	OutBack = OutBack,
	InOutBack = InOutBack,
	OutInBack = OutInBack,
	
	InSine = InSine,
	OutSine = OutSine,
	InOutSine = InOutSine,
	OutInSine = OutInSine,
	
	OutBounce = OutBounce,
	InBounce = InBounce,
	InOutBounce = InOutBounce,
	OutInBounce = OutInBounce,
	
	InElastic = InElastic,
	OutElastic = OutElastic,
	InOutElastic = InOutElastic,
	OutInElastic = OutInElastic,
	
	InExponential = InExponential,
	OutExponential = OutExponential,
	InOutExponential = InOutExponential,
	OutInExponential = OutInExponential,
	
	InCircular = InCircular,
	OutCircular = OutCircular,
	InOutCircular = InOutCircular,
	OutInCircular = OutInCircular,
}