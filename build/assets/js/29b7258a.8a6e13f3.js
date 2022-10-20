"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[1918],{73913:e=>{e.exports=JSON.parse('{"functions":[{"name":"new","desc":"Returns a [StorageResult] object.\\n\\n```lua\\nlocal storageResult = Storage.new(\\"Base\\", \\"TEST\\", nil, {\\n\\tfoo = 5,\\n\\tbar = 10,\\n\\tqux = {\\n\\t\\tfoo = 10,\\n\\t\\tbar = 5\\n\\t\\tboot = \\"doot\\",\\n\\t\\t\\n\\t\\tsecret = {\\n\\t\\t\\tREALLYSECRET = {\\n\\t\\t\\t\\tkey = \\"oof!\\",\\n\\t\\t\\t}\\n\\t\\t},\\n\\t},\\n})\\n\\nif storageResult.success then\\n\\tlocal storage = storageResult.result\\n\\t\\n\\tstorage.DeepKeyUpdated:Connect(function(index, oldData, newData, indexers)\\n\\t\\tprint(index, indexers, table.unpack(indexers), oldData, newData)\\n\\tend)\\n\\t\\n\\tstorage.KeyUpdate:Connect(function(index, key, newData, oldData)\\n\\t\\tprint(index, key, newData, oldData)\\n\\tend)\\n\\t\\n\\tdo\\n\\t\\tlocal data = storage:HardLoad(\\"qux\\")\\n\\t\\t\\n\\t\\tif data.success then\\n\\t\\t\\tstorage:DeepUpdate(\\"qux\\", \\"doh!\\", \\"secret\\", \\"REALLYSECRET\\")\\n\\t\\tend\\n\\tend\\n\\t\\n\\tdo\\n\\t\\tlocal data = storage:HardLoad(\\"foo\\")\\n\\t\\t\\n\\t\\tif data.success then\\n\\t\\t\\tstorage:Update(\\"foo\\", 10)\\n\\t\\tend\\n\\tend\\nend\\n```\\n\\n\\n\\t","params":[{"name":"type","desc":"","lua_type":"StorageType"},{"name":"name","desc":"The name of the [Storage].","lua_type":"string"},{"name":"scope","desc":"The scope of the [Storage].","lua_type":"string?"},{"name":"default","desc":"","lua_type":"Default"},{"name":"options","desc":"Options to modify DataStores.","lua_type":"DataStoreOptions?"}],"returns":[{"desc":"","lua_type":"StorageResult\\r\\n"}],"function_type":"static","yields":true,"source":{"line":99,"path":"lib/Storage/init.lua"}},{"name":"newOrdered","desc":"Returns a [OrderedStorageResult] object.\\n\\n\\n\\t","params":[{"name":"name","desc":"The name of the [OrderedStorage].","lua_type":"string"},{"name":"scope","desc":"The scope of the [OrderedStorage].","lua_type":"string?"},{"name":"default","desc":"The default data for the [OrderedStorage]","lua_type":"number"}],"returns":[{"desc":"","lua_type":"StorageResult\\r\\n"}],"function_type":"static","yields":true,"source":{"line":119,"path":"lib/Storage/init.lua"}},{"name":"GetStorage","desc":"Returns an already-existing [StorageResult] object, given a name.\\n\\n```lua\\nlocal storageResult = Storage:GetStorage(\\"TEST\\")\\n```\\n\\n\\n\\t","params":[{"name":"name","desc":"The name of the [Storage].","lua_type":"string"}],"returns":[{"desc":"","lua_type":"StorageResult?\\r\\n"}],"function_type":"method","source":{"line":136,"path":"lib/Storage/init.lua"}},{"name":"GetBaseStorage","desc":"Returns a [BaseResult] object.\\n\\n```lua\\nlocal baseResult = Storage:GetBaseStorage(\\"Base\\", \\"TEST2\\")\\n```\\n\\n\\n\\t","params":[{"name":"type","desc":"The type of [Storage]; \\"Base\\" or \\"Ordered\\".","lua_type":"BaseTypes"},{"name":"name","desc":"The name of the [Storage].","lua_type":"string"},{"name":"scope","desc":"The scope of the [Storage].","lua_type":"string?"},{"name":"options","desc":"Options to modify DataStores.","lua_type":"DataStoreOptions?"}],"returns":[{"desc":"","lua_type":"BaseResult\\r\\n"}],"function_type":"method","source":{"line":154,"path":"lib/Storage/init.lua"}}],"properties":[],"types":[{"name":"StorageType","desc":"The type of DataStore; Player contains specific functionality used for players, and Base creates a general-purpose\\n\\tDataStore.","lua_type":"\\"Player\\" | \\"Base\\"","source":{"line":12,"path":"lib/Storage/Types.lua"}},{"name":"Default","desc":"Default data to be used for blank entries.","lua_type":"{[string | number]: any}","source":{"line":18,"path":"lib/Storage/Types.lua"}},{"name":"Result","desc":"","lua_type":"<a>{success: boolean, message: string?, result: a, metadata: DataStoreKeyInfo?}","source":{"line":22,"path":"lib/Storage/Types.lua"}},{"name":"SaveResult","desc":"A dictionary containing a success boolean, and a message (if saving the data fails).","lua_type":"Result<boolean?>","source":{"line":28,"path":"lib/Storage/Types.lua"}},{"name":"DataStoreResult","desc":"A table containing data members for success, message, and result. The message data member is only used when success is\\n\\tfalse, and result is only used when success is true, and contains the DataStore.","lua_type":"Result<GlobalDataStore?>","source":{"line":49,"path":"lib/Storage/Types.lua"}},{"name":"SaveStatus","desc":"","lua_type":"\\"Saving\\" | \\"Failed\\" | \\"Ready\\" | \\"NotReady\\"","ignore":true,"source":{"line":54,"path":"lib/Storage/Types.lua"}},{"name":"LoadStatus","desc":"","lua_type":"\\"Loading\\" | \\"Failed\\" | \\"Ready\\"","ignore":true,"source":{"line":59,"path":"lib/Storage/Types.lua"}},{"name":"BaseData","desc":"","lua_type":"{saveStatus: SaveStatus, loadStatus: LoadStatus, canSave: boolean, data: any}","source":{"line":63,"path":"lib/Storage/Types.lua"}},{"name":"DataResult","desc":"A dictionary containing a success boolean, a message (if getting the data fails), and a result (if getting the data\\n\\tsucceeds, this is the data).","lua_type":"Result<any>","source":{"line":70,"path":"lib/Storage/Types.lua"}},{"name":"BaseResult","desc":"A dictionary containing a success boolean, a message (if getting the DataStore fails), and a result (if getting the\\n\\tDataStore succeeds, this is the DataStore).","lua_type":"Result<(GlobalDataStore | OrderedDataStore)?>","source":{"line":77,"path":"lib/Storage/Types.lua"}},{"name":"StorageResult","desc":"A dictionary containing a success boolean, a message (if getting the DataStore fails), and a result (if getting the\\n\\tDataStore succeeds, this is the Storage object).","lua_type":"Result<(PlayerStorage | BaseStorage)?>","source":{"line":105,"path":"lib/Storage/Types.lua"}}],"name":"Storage","desc":"A DataStore wrapper service.\\n\\t","realm":["Server"],"source":{"line":42,"path":"lib/Storage/init.lua"}}')}}]);