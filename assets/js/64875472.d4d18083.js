"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[463],{43102:e=>{e.exports=JSON.parse('{"functions":[{"name":"GetLimitedColor","desc":"Returns a number value that is either randomized or uses the given number.","params":[{"name":"a","desc":"","lua_type":"NumberOrRange"}],"returns":[{"desc":"","lua_type":"number\\r\\n"}],"function_type":"static","ignore":true,"source":{"line":34,"path":"lib/Color3Util.lua"}},{"name":"ClampRGB","desc":"Returns a Color3 with clamped R, G, and B values.\\n\\n```lua\\nlocal clampedColor = Color3Util:ClampRGB(300, -2500, 5)\\n\\nprint(clampedColor) --\x3e 255, 0, 5\\n```","params":[{"name":"r","desc":"","lua_type":"number"},{"name":"g","desc":"","lua_type":"number"},{"name":"b","desc":"","lua_type":"number"}],"returns":[{"desc":"","lua_type":"Color3\\r\\n"}],"function_type":"method","source":{"line":60,"path":"lib/Color3Util.lua"}},{"name":"ClampHSV","desc":"Returns a Color3 with clamped H, S, and V values.\\n\\n```lua\\nlocal clampedColor = Color3Util:ClampHSV(300, -2500, 5)\\n\\nprint(clampedColor) --\x3e 255, 0, 5\\n```","params":[{"name":"h","desc":"","lua_type":"number"},{"name":"s","desc":"","lua_type":"number"},{"name":"v","desc":"","lua_type":"number"}],"returns":[{"desc":"","lua_type":"Color3\\r\\n"}],"function_type":"method","source":{"line":75,"path":"lib/Color3Util.lua"}},{"name":"GetRandomColor","desc":"Returns a random color.\\n\\n```lua\\nprint(Color3Util:GetRandomColor())\\n```","params":[],"returns":[{"desc":"","lua_type":"Color3\\r\\n"}],"function_type":"method","source":{"line":88,"path":"lib/Color3Util.lua"}},{"name":"GetRandomColorWithLimitsInRGB","desc":"Returns a randomized color within given boundaries in RGB [0-255].\\n\\n```lua\\nlocal limitedColor = Color3Util:GetRandomColorWithLimitsInRGB(NumberRange.new(50, 255), nil, 5)\\n\\nprint(limitedColor)\\n```\\n\\n:::info\\nIf a parameter is given nil, it has no boundaries; if given a NumberRange, it randomizes within that range; if given a\\nnumber, it sets it to that number, and does no randomization.","params":[{"name":"r","desc":"","lua_type":"NumberOrRange"},{"name":"g","desc":"","lua_type":"NumberOrRange"},{"name":"b","desc":"","lua_type":"NumberOrRange"}],"returns":[{"desc":"","lua_type":"Color3\\r\\n"}],"function_type":"method","source":{"line":107,"path":"lib/Color3Util.lua"}},{"name":"GetRandomColorWithLimitsInHSV","desc":"Returns a randomized color within given boundaries in HSV [0-255].\\n\\n```lua\\nlocal limitedColor = Color3Util:GetRandomColorWithLimitsInHSV(NumberRange.new(50, 255), nil, 5)\\n\\nprint(limitedColor)\\n```\\n\\n:::info\\nIf a parameter is given nil, it has no boundaries; if given a NumberRange, it randomizes\\nwithin that range; if given a number, it sets it to that number, and does no randomization.","params":[{"name":"h","desc":"","lua_type":"NumberOrRange"},{"name":"s","desc":"","lua_type":"NumberOrRange"},{"name":"v","desc":"","lua_type":"NumberOrRange"}],"returns":[{"desc":"","lua_type":"Color3\\r\\n"}],"function_type":"method","source":{"line":126,"path":"lib/Color3Util.lua"}},{"name":"GetVariantColor","desc":"Returns a color that is a variation of the one given, within a given amplitude.\\n\\n```lua\\nlocal originalColor = Color3.new(0.5, 0.25, 0.75)\\nlocal variationColorA = Color3Util:GetVariantColor(originalColor, 55)\\nlocal variationColorB = Color3Util:GetVariantColor(originalColor, 20)\\n\\nprint(\\"Original:\\", originalColor, \\"| A:\\", variationColorA, \\"| B:\\", variationColorB)\\n```","params":[{"name":"color","desc":"The color to use as a base.","lua_type":"Color3"},{"name":"amplitude","desc":"The amount to variate the color by (0-255)","lua_type":"number"}],"returns":[{"desc":"","lua_type":"Color3\\r\\n"}],"function_type":"method","source":{"line":146,"path":"lib/Color3Util.lua"}},{"name":"GetColorAtPointFromSequence","desc":"Returns the color at the given point within the ColorSequence.\\n\\n```lua\\nlocal sequence = ColorSequence.new({\\n\\tColorSequenceKeypoint.new(0, Color3.new(1, 0, 0)),\\n\\tColorSequenceKeypoint.new(0.5, Color3.new(0, 1, 0)),\\n\\tColorSequenceKeypoint.new(1, Color3.new(1, 0, 1)),\\n})\\n\\nprint(Color3Util:GetColorAtPointFromSequence(sequence, 0.25))\\n```","params":[{"name":"sequence","desc":"The sequence to pull the color from.","lua_type":"ColorSequence"},{"name":"point","desc":"The time to get the color from. [0, 1]","lua_type":"number"}],"returns":[{"desc":"","lua_type":"Color3\\r\\n"}],"function_type":"method","source":{"line":175,"path":"lib/Color3Util.lua"}},{"name":"GetRandomColorOnSequence","desc":"Returns a color from anywhere on the ColorSequence.\\n\\n```lua\\nlocal sequence = ColorSequence.new({\\n\\tColorSequenceKeypoint.new(0, Color3.new(1, 0, 0)),\\n\\tColorSequenceKeypoint.new(0.5, Color3.new(0, 1, 0)),\\n\\tColorSequenceKeypoint.new(1, Color3.new(1, 0, 1)),\\n})\\n\\nprint(Color3Util:GetRandomColorOnSequence(sequence))\\n```","params":[{"name":"sequence","desc":"The sequence to pull the color from.","lua_type":"ColorSequence"}],"returns":[{"desc":"","lua_type":"Color3\\r\\n"}],"function_type":"method","source":{"line":224,"path":"lib/Color3Util.lua"}}],"properties":[],"types":[{"name":"NumberOrRange","desc":"A number, NumberRange, or nil.","lua_type":"(number | NumberRange)?","source":{"line":22,"path":"lib/Color3Util.lua"}}],"name":"Color3Util","desc":"A library with a number of Color3 helper functions.","source":{"line":27,"path":"lib/Color3Util.lua"}}')}}]);