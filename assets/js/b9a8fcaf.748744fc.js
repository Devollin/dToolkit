"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[6519],{36356:e=>{e.exports=JSON.parse('{"functions":[{"name":"new","desc":"Creates a new Flow object.\\n\\n```lua\\nlocal array = {\\n\\tfoo = 5,\\n\\tbar = Vector2.new(5, 2),\\n}\\n\\nFlow.new(array, {\\n\\tfoo = 1,\\n\\tbar = Vector2.new(2, 5),\\n}, {T = 5, ES = \\"Exponential\\", ED = \\"InOut\\"}).Stepped:Connect(function()\\n\\tprint(array)\\nend)\\n```","params":[{"name":"targets","desc":"","lua_type":"Target"},{"name":"goals","desc":"","lua_type":"Properties"},{"name":"modifiers","desc":"","lua_type":"ModifierInput?"}],"returns":[{"desc":"","lua_type":"Flow\\r\\n"}],"function_type":"static","source":{"line":172,"path":"lib/Flow/init.lua"}},{"name":"Play","desc":"Runs the Flow.\\n\\t","params":[],"returns":[],"function_type":"method","source":{"line":222,"path":"lib/Flow/init.lua"}},{"name":"Stop","desc":"Stops the Flow.\\n\\t","params":[],"returns":[],"function_type":"method","source":{"line":314,"path":"lib/Flow/init.lua"}},{"name":"Pause","desc":"Pauses the Flow.\\n\\t","params":[],"returns":[],"function_type":"method","source":{"line":334,"path":"lib/Flow/init.lua"}},{"name":"Destroy","desc":"Destroys the Flow.\\n\\t","params":[],"returns":[],"function_type":"method","source":{"line":347,"path":"lib/Flow/init.lua"}},{"name":"Restart","desc":"Restarts the Flow.\\n\\t","params":[],"returns":[],"function_type":"method","source":{"line":371,"path":"lib/Flow/init.lua"}}],"properties":[],"types":[{"name":"StepType","desc":"","lua_type":"\\"Heartbeat\\" | \\"RenderStepped\\" | \\"Stepped\\"","source":{"line":124,"path":"lib/Flow/init.lua"}},{"name":"Style","desc":"","lua_type":"\\"Linear\\" | \\"Smooth\\" | \\"Smoother\\" | \\"RidiculousWiggle\\" | \\"ReverseBack\\" | \\"Spring\\" | \\"SoftSpring\\" | \\"Quad\\" | \\"Cubic\\" | \\"Quart\\" | \\"Quint\\" | \\"Back\\" | \\"Sine\\" | \\"Bounce\\" | \\"Elastic\\" | \\"Exponential\\" | \\"Circular\\"","source":{"line":128,"path":"lib/Flow/init.lua"}},{"name":"Direction","desc":"","lua_type":"\\"In\\" | \\"Out\\" | \\"InOut\\" | \\"OutIn\\"","source":{"line":132,"path":"lib/Flow/init.lua"}},{"name":"Properties","desc":"","lua_type":"{[string]: any}","source":{"line":136,"path":"lib/Flow/init.lua"}},{"name":"Target","desc":"","lua_type":"Instance | {[string]: any} | {Instance}","source":{"line":140,"path":"lib/Flow/init.lua"}},{"name":"ModifierInput","desc":"Additionally, you can use shorthand for each parameter, based off of the capitalized letters in each member.\\nEx: Time -> T","lua_type":"{Time: number?, EasingStyle: Style?, EasingDirection: Direction?, AutoPlay: boolean?, Destroy: boolean?, Reverse: boolean?, RepeatCount: number?, DelayTime: number?, StepType: StepType?}","source":{"line":147,"path":"lib/Flow/init.lua"}}],"name":"Flow","desc":"Interface for tweening.","source":{"line":152,"path":"lib/Flow/init.lua"}}')}}]);