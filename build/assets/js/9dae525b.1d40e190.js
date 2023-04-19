"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[9297],{81670:e=>{e.exports=JSON.parse('{"functions":[{"name":"new","desc":"Creates and returns a new [Timer] object.\\n\\n```lua\\nlocal newTimer = Timer.new()\\nnewTimer:SetDuration(5)\\n\\nnewTimer.Finished:Connect(function()\\n\\tprint(\\"Finished!\\")\\n\\t\\n\\tnewTimer:Start()\\nend)\\n\\nnewTimer:Start()\\n```","params":[{"name":"initDuration","desc":"Duration applied after initializing the [Timer].","lua_type":"number?"}],"returns":[{"desc":"","lua_type":"Timer\\r\\n"}],"function_type":"static","source":{"line":99,"path":"lib/Timer.lua"}},{"name":"Start","desc":"Starts the [Timer].\\n\\n:::caution\\nThis will error if the [Timer] has not been given a duration yet.\\n\\n\\t","params":[{"name":"self","desc":"","lua_type":"Timer"}],"returns":[],"function_type":"static","source":{"line":121,"path":"lib/Timer.lua"}},{"name":"Pause","desc":"Pauses the [Timer].\\n\\t","params":[{"name":"self","desc":"","lua_type":"Timer"}],"returns":[],"function_type":"static","source":{"line":147,"path":"lib/Timer.lua"}},{"name":"Stop","desc":"Stops the [Timer].\\n\\t","params":[{"name":"self","desc":"","lua_type":"Timer"}],"returns":[],"function_type":"static","source":{"line":171,"path":"lib/Timer.lua"}},{"name":"IsRunning","desc":"Returns true or false, depending on if the [Timer] is running or not.\\n\\t","params":[{"name":"self","desc":"","lua_type":"Timer"}],"returns":[{"desc":"","lua_type":"boolean\\r\\n"}],"function_type":"static","source":{"line":193,"path":"lib/Timer.lua"}},{"name":"SetDuration","desc":"Sets the duration of the [Timer]. Durations MUST be a positive number and not zero.\\n\\n:::caution\\nThis will error if the [Timer] is running. Utilize :IsRunning() to prevent the error from propagating.\\n\\n\\t","params":[{"name":"self","desc":"","lua_type":"Timer"},{"name":"newDuration","desc":"","lua_type":"number"}],"returns":[],"function_type":"static","source":{"line":205,"path":"lib/Timer.lua"}},{"name":"GetRemaining","desc":"Gets the duration and elapsed time of the [Timer].\\n\\n:::caution\\nThis will error if the [Timer] has not been given a duration yet.\\n\\n\\t","params":[{"name":"self","desc":"","lua_type":"Timer"}],"returns":[{"desc":"","lua_type":"Remaining\\r\\n"}],"function_type":"static","source":{"line":226,"path":"lib/Timer.lua"}},{"name":"Destroy","desc":"Destroys the [Timer] object.\\n\\t","params":[{"name":"self","desc":"","lua_type":"Timer"}],"returns":[],"function_type":"static","source":{"line":250,"path":"lib/Timer.lua"}},{"name":"withUpdate","desc":"Creates and returns a new [Timer] object, with an Updated [Signal].","params":[{"name":"initDuration","desc":"Duration applied after initializing the [Timer].","lua_type":"number?"}],"returns":[{"desc":"","lua_type":"TimerWithUpdate\\r\\n"}],"function_type":"static","source":{"line":282,"path":"lib/Timer.lua"}}],"properties":[{"name":"Finished","desc":"Fired when the Timer finishes running.","lua_type":"Signal<>","source":{"line":55,"path":"lib/Timer.lua"}},{"name":"Paused","desc":"Fired when the Timer has been paused.","lua_type":"Signal<>","source":{"line":61,"path":"lib/Timer.lua"}},{"name":"Updated","desc":"Fired when the Timer has been updated. The first number is the time remaining, the second is the time elapsed.\\n\\n:::note\\nThis [Signal] member is not available in the base version of [Timer]. Use .withUpdate() to implement it.","lua_type":"Signal<number, number>","deprecated":{"version":"v2.0.0","desc":"Create your own updating method instead; removed due to a performance hit after the v2 revisions."},"source":{"line":71,"path":"lib/Timer.lua"}}],"types":[{"name":"Remaining","desc":"A data type used to display how much time is remaining / has elapsed in the Timer.","lua_type":"{remaining: number, elapsed: number}","source":{"line":78,"path":"lib/Timer.lua"}}],"name":"Timer","desc":"A timer class.\\n\\n:::note V2.0.0\\nAs of v2.0.0, the Updated [Signal] is no longer a part of the default Timer class. It can be restored by using .withUpdate().","source":{"line":49,"path":"lib/Timer.lua"}}')}}]);