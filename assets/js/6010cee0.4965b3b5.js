"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[837],{3866:e=>{e.exports=JSON.parse('{"functions":[{"name":"new","desc":"Returns a new Bind class.\\n\\n\\n```lua\\nlocal newBind = Bind.new(\\"Test\\", {Enum.KeyCode.E}, function(actionName, state, input)\\n\\tprint(\\"Wow!\\")\\nend)\\n```","params":[{"name":"name","desc":"The name of the action.","lua_type":"string"},{"name":"keys","desc":"The list of keys you want to bind.","lua_type":"Keys"},{"name":"boundFunction","desc":"Function that the binding is bound to.","lua_type":"BoundFunction?"},{"name":"enabled","desc":"Determines if the binding should be enabled upon creation; defaults to true.","lua_type":"boolean?"},{"name":"mobileButton","desc":"Determines if a mobile button should be added with this binding; defaults to false.","lua_type":"boolean?"}],"returns":[{"desc":"","lua_type":"Bind\\r\\n"}],"function_type":"static","source":{"line":78,"path":"lib/Bind.lua"}},{"name":"Rebind","desc":"Replaces the bound function mapped to new keys.\\n\\t","params":[{"name":"newKeys","desc":"","lua_type":"Keys"}],"returns":[],"function_type":"method","source":{"line":101,"path":"lib/Bind.lua"}},{"name":"Enable","desc":"Enables the [Bind].\\n\\t","params":[],"returns":[],"function_type":"method","source":{"line":121,"path":"lib/Bind.lua"}},{"name":"Disable","desc":"Disables the [Bind].\\n\\t","params":[],"returns":[],"function_type":"method","source":{"line":129,"path":"lib/Bind.lua"}},{"name":"Destroy","desc":"Destroys the [Bind].\\n\\t","params":[],"returns":[],"function_type":"method","source":{"line":137,"path":"lib/Bind.lua"}}],"properties":[{"name":"boundFunction","desc":"Function bound to the given [Keys].","lua_type":"BoundFunction","source":{"line":54,"path":"lib/Bind.lua"}},{"name":"keys","desc":"[Keys] bound to the action.","lua_type":"Keys","source":{"line":60,"path":"lib/Bind.lua"}}],"types":[{"name":"Keys","desc":"A list of Enum.KeyCode to bind an action to.","lua_type":"{Enum.KeyCode}","source":{"line":35,"path":"lib/Bind.lua"}},{"name":"BoundFunction","desc":"A function used to bind context actions to.","lua_type":"(actionName: string, state: Enum.UserInputState, input: InputObject) -> ()","source":{"line":41,"path":"lib/Bind.lua"}}],"name":"Bind","desc":"A [Bind] class that is used as an interface for binding keys to ContextActionService.","realm":["Client"],"source":{"line":47,"path":"lib/Bind.lua"}}')}}]);