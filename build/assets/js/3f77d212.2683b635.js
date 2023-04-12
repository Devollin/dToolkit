"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[18],{41755:t=>{t.exports=JSON.parse('{"functions":[{"name":"new","desc":"Creates a new [Stopwatch] object.\\n\\n```lua\\nlocal newStopwatch = Stopwatch.new()\\n```","params":[],"returns":[{"desc":"","lua_type":"Stopwatch\\r\\n"}],"function_type":"static","source":{"line":47,"path":"lib/Stopwatch.lua"}},{"name":"Start","desc":"Starts or resumes the [Stopwatch].\\n\\n```lua\\nnewStopwatch:Start()\\n```\\n\\n\\t","params":[{"name":"self","desc":"","lua_type":"Stopwatch"}],"returns":[],"function_type":"static","source":{"line":63,"path":"lib/Stopwatch.lua"}},{"name":"Stop","desc":"Stops the [Stopwatch], and resets the total elapsed time. Returns the total elapsed time if it succeeds, or nil.\\n\\n```lua\\nprint(\\"new time!!\\", newStopwatch:Stop())\\n```\\n\\n\\t","params":[{"name":"self","desc":"","lua_type":"Stopwatch"}],"returns":[{"desc":"","lua_type":"number\\r\\n"}],"function_type":"static","source":{"line":81,"path":"lib/Stopwatch.lua"}},{"name":"Pause","desc":"Pauses the [Stopwatch], and returns the lap elapsed time if it can; otherwise returns nil.\\n\\n```lua\\nprint(newStopwatch:Pause())\\n```\\n\\n\\t","params":[{"name":"self","desc":"","lua_type":"Stopwatch"}],"returns":[{"desc":"","lua_type":"number?\\r\\n"}],"function_type":"static","source":{"line":104,"path":"lib/Stopwatch.lua"}},{"name":"GetElapsed","desc":"Returns two numbers or nil; the first number is the total elapsed time, the second is the elapsed time of the lap, if\\nthe [Stopwatch] is running; otherwise returns nil.\\n\\n```lua\\ntask.spawn(function()\\n\\twhile true do\\n\\t\\tlocal total, lap = newStopwatch:GetElapsed()\\n\\t\\t\\n\\t\\tif total then\\n\\t\\t\\tif lap then\\n\\t\\t\\t\\tprint(\\"Total:\\", total, \\"; Lap:\\", lap)\\n\\t\\t\\telse\\n\\t\\t\\t\\tprint(\\"Total:\\", total)\\n\\t\\t\\tend\\n\\t\\telse\\n\\t\\t\\tprint(\\"Stopwatch does not exist!\\")\\n\\t\\tend\\n\\t\\t\\n\\t\\ttask.wait()\\n\\tend\\nend)\\n```\\n\\n\\t","params":[{"name":"self","desc":"","lua_type":"Stopwatch"}],"returns":[{"desc":"","lua_type":"number"},{"desc":"","lua_type":"number?"}],"function_type":"static","source":{"line":144,"path":"lib/Stopwatch.lua"}},{"name":"IsRunning","desc":"Returns a boolean describing if the [Stopwatch] is running or not.\\n\\n```lua\\nnewStopwatch:Start()\\n\\nprint(newStopwatch:IsRunning())\\n\\ntask.wait(1)\\n\\nnewStopwatch:Stop()\\n\\nprint(newStopwatch:IsRunning())\\n```\\n\\n\\t","params":[{"name":"self","desc":"","lua_type":"Stopwatch"}],"returns":[{"desc":"","lua_type":"boolean\\r\\n"}],"function_type":"static","source":{"line":169,"path":"lib/Stopwatch.lua"}},{"name":"Destroy","desc":"Destroys the [Stopwatch] object.\\n\\n```lua\\nnewStopwatch:Destroy()\\n```\\n\\n\\t","params":[{"name":"self","desc":"","lua_type":"Stopwatch"}],"returns":[],"function_type":"static","source":{"line":182,"path":"lib/Stopwatch.lua"}}],"properties":[],"types":[],"name":"Stopwatch","desc":"A class that tracks time; like a stopwatch!\\n\\n```lua\\nlocal newStopwatch = Stopwatch.new()\\n\\nlocal totalDelay = task.wait(math.random() * 5)\\n\\nprint(newStopWatch:Stop())\\nprint(totalDelay)\\n```","source":{"line":35,"path":"lib/Stopwatch.lua"}}')}}]);