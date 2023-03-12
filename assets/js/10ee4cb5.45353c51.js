"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[8281],{48809:e=>{e.exports=JSON.parse('{"functions":[{"name":"new","desc":"Creates a new Value object. This will also determine the types for the object, if they were not strictly given.\\n\\n```lua\\nlocal state = Value.new(false, true)\\n```","params":[{"name":"...","desc":"The initial values you want to store in the new Value object.","lua_type":"a..."}],"returns":[{"desc":"","lua_type":"Value<a...>\\r\\n"}],"function_type":"static","source":{"line":114,"path":"lib/Value.lua"}},{"name":"Set","desc":"Updates the value(s) inside the Value object.\\n\\n```lua\\nstate:Set(true, false)\\n```\\n\\n\\t","params":[{"name":"self","desc":"","lua_type":"Value<a...>"},{"name":"...","desc":"","lua_type":"a..."}],"returns":[],"function_type":"static","source":{"line":134,"path":"lib/Value.lua"}},{"name":"Get","desc":"Returns all values inside of the Value object.\\n\\n```lua\\nprint(state:Get())\\n```\\n\\n\\t","params":[{"name":"self","desc":"","lua_type":"Value<a...>"}],"returns":[{"desc":"","lua_type":"a..."}],"function_type":"static","source":{"line":153,"path":"lib/Value.lua"}},{"name":"Clone","desc":"Returns a new Value object with the same values as the original.\\n\\n```lua\\nlocal copiedState = state:Clone()\\n```\\n\\n\\t","params":[{"name":"self","desc":"","lua_type":"Value<a...>"}],"returns":[{"desc":"","lua_type":"Value<a...>\\r\\n"}],"function_type":"static","source":{"line":168,"path":"lib/Value.lua"}},{"name":"RawSet","desc":"Sets the value of the Value object without firing Changed or WillChange.\\n\\n\\t","params":[{"name":"self","desc":"","lua_type":"Value<a...>"},{"name":"...","desc":"","lua_type":"a..."}],"returns":[],"function_type":"static","source":{"line":177,"path":"lib/Value.lua"}},{"name":"Destroy","desc":"Destroys the Value object and makes it unusable.\\n\\n```lua\\ncopiedState:Destroy()\\n```\\n\\n\\t","params":[{"name":"self","desc":"","lua_type":"Value<a...>"}],"returns":[],"function_type":"static","source":{"line":190,"path":"lib/Value.lua"}}],"properties":[{"name":"WillChange","desc":"Is fired before the value changes for [Value].\\n\\n```lua\\nstate.WillChange:Connect(function(foo, bar)\\n\\tprint(foo, bar)\\nend)\\n```","lua_type":"Signal<b...>","tags":["Event"],"source":{"line":87,"path":"lib/Value.lua"}},{"name":"Changed","desc":"Is fired after the value changes for [Value].\\n\\n```lua\\nstate.Changed:Connect(function(foo, bar)\\n\\tprint(foo, bar)\\nend)\\n```","lua_type":"Signal<b...>","tags":["Event"],"source":{"line":100,"path":"lib/Value.lua"}}],"types":[],"name":"Value","desc":"An object used to store states, and trigger every [Connection] listening to its [Signal] members.\\n\\n```lua\\nlocal state = Value.new(false, true)\\n\\nstate.WillChange:Connect(function(foo, bar)\\n\\tprint(foo, bar)\\nend)\\n\\nstate.Changed:Connect(function(foo, bar)\\n\\tprint(foo, bar)\\nend)\\n\\nstate:Set(true, false)\\n\\ntask.wait(1)\\n\\nlocal copiedState = state:Clone()\\n\\nprint(\\"These are the current states:\\", copiedState:Get())\\n\\ncopiedState:Destroy()\\n```\\n\\n:::caution String Literals\\nIt should be noted that for one reason or another, Value is not able to typecheck string literals properly.\\n\\n:::info\\nThere is an alternative type named InternalValue, which can be used for classes built using it! The primary difference\\nis that InternalValue drops the :Set(), :Destroy(), and :RawSet() methods, but only from the type, not the object.","source":{"line":73,"path":"lib/Value.lua"}}')}}]);