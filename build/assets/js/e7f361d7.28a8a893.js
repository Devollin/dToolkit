"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[9529],{99986:e=>{e.exports=JSON.parse('{"functions":[{"name":"GetDataStore","desc":"Returns a [DataStoreResult] object, given a name and optional scope and [DataStoreOptions] parameters.","params":[{"name":"name","desc":"The name of the [GlobalDataStore].","lua_type":"string"},{"name":"scope","desc":"The scope of the [GlobalDataStore].","lua_type":"string?"},{"name":"options","desc":"The [DataStoreOptions] used when getting the [GlobalDataStore].","lua_type":"DataStoreOptions?"}],"returns":[{"desc":"","lua_type":"DataStoreResult\\r\\n"}],"function_type":"method","yields":true,"source":{"line":199,"path":"lib/Storage/DataStore.lua"}},{"name":"new","desc":"Creates a new [BaseStorageResult] object.","params":[{"name":"name","desc":"The name of the [GlobalDataStore].","lua_type":"string"},{"name":"scope","desc":"The scope of the [GlobalDataStore].","lua_type":"string?"},{"name":"options","desc":"Options to modify [GlobalDataStore]s.","lua_type":"DataStoreOptions?"},{"name":"default","desc":"Default data to be used for blank entries.","lua_type":"Default"}],"returns":[{"desc":"","lua_type":"BaseStorageResult\\r\\n"}],"function_type":"static","yields":true,"source":{"line":243,"path":"lib/Storage/DataStore.lua"}},{"name":"HardLoad","desc":"Performs GetAsync if the data requested by the index does not exist, and returns the data.\\n\\n\\n\\t","params":[{"name":"index","desc":"The key within the [GlobalDataStore].","lua_type":"string"}],"returns":[{"desc":"","lua_type":"DataResult\\r\\n"}],"function_type":"method","yields":true,"source":{"line":277,"path":"lib/Storage/DataStore.lua"}},{"name":"SoftLoad","desc":"Returns data associated with the index, if it has been loaded already.\\n\\n\\n\\t","params":[{"name":"index","desc":"The key within the [GlobalDataStore].","lua_type":"string"}],"returns":[{"desc":"","lua_type":"DataResult\\r\\n"}],"function_type":"method","source":{"line":370,"path":"lib/Storage/DataStore.lua"}},{"name":"HardSave","desc":"Performs SetAsync with the data associated with the index, if it isn\'t already being saved.\\n\\n\\n\\t","params":[{"name":"index","desc":"The key within the [GlobalDataStore].","lua_type":"string"},{"name":"ids","desc":"An optional list of user IDs associated with the data.","lua_type":"{number}?"},{"name":"setOptions","desc":"Options used to adjust SetAsync.","lua_type":"DataStoreSetOptions?"}],"returns":[{"desc":"","lua_type":"SaveResult\\r\\n"}],"function_type":"method","yields":true,"source":{"line":416,"path":"lib/Storage/DataStore.lua"}},{"name":"SoftSave","desc":"Replaces all the data associated with the index.\\n\\n\\n\\t","params":[{"name":"index","desc":"The key within the [GlobalDataStore].","lua_type":"string"},{"name":"newData","desc":"","lua_type":"any"}],"returns":[{"desc":"","lua_type":"SaveResult\\r\\n"}],"function_type":"method","source":{"line":487,"path":"lib/Storage/DataStore.lua"}},{"name":"Update","desc":"Saves the data associated with the index, if it isn\'t already being saved.\\n\\n\\n\\t","params":[{"name":"index","desc":"The key within the [GlobalDataStore].","lua_type":"string"},{"name":"key","desc":"The key within the data.","lua_type":"(string | number)"},{"name":"newData","desc":"The data to replace the contents of the key.","lua_type":"any"}],"returns":[{"desc":"","lua_type":"SaveResult\\r\\n"}],"function_type":"method","source":{"line":534,"path":"lib/Storage/DataStore.lua"}},{"name":"DeepUpdate","desc":"Saves the data associated with the indexes, if it isn\'t already being saved.\\n\\n\\n\\t","params":[{"name":"index","desc":"The key within the [GlobalDataStore].","lua_type":"string"},{"name":"newData","desc":"The data to replace the contents of the key.","lua_type":"any"},{"name":"key","desc":"The key within the data.","lua_type":"(string | number)"},{"name":"...","desc":"The key indexer(s) within the data.","lua_type":"(string | number)"}],"returns":[{"desc":"","lua_type":"SaveResult\\r\\n"}],"function_type":"method","source":{"line":586,"path":"lib/Storage/DataStore.lua"}},{"name":"Clear","desc":"Hard saves the data, then removes the data associated with the index.\\n\\n\\n\\t","params":[{"name":"index","desc":"The key within the [GlobalDataStore].","lua_type":"string"}],"returns":[],"function_type":"method","yields":true,"source":{"line":664,"path":"lib/Storage/DataStore.lua"}},{"name":"Close","desc":"Saves all data, and clears it\'s own members.\\n\\t","params":[],"returns":[],"function_type":"method","yields":true,"source":{"line":679,"path":"lib/Storage/DataStore.lua"}}],"properties":[{"name":"LoadRetry","desc":"Fired when Storage is going to retry loading the requested data, if it previously failed.\\nThe first param is the error message, the second param is the name of the Storage, the third param is the scope, and the\\nlast param is the key.","lua_type":"Signal<string, string, string?, string>","tags":["Event"],"source":{"line":119,"path":"lib/Storage/DataStore.lua"}},{"name":"LoadFail","desc":"Fired when Storage failed to load the requested data after retrying several times.\\nThe first param is the error message, the second param is the name of the Storage, the third param is the scope, and the\\nlast param is the key.","lua_type":"Signal<string, string, string?, string>","tags":["Event"],"source":{"line":128,"path":"lib/Storage/DataStore.lua"}},{"name":"SaveStart","desc":"Fired when Storage is going to try to save to [GlobalDataStore].\\nThe only param passed is the index.","lua_type":"Signal<string>","tags":["Event"],"source":{"line":136,"path":"lib/Storage/DataStore.lua"}},{"name":"SaveRetry","desc":"Fired when Storage is going to retry saving the requested data, if it previously failed.\\nThe first param is the error message, the second param is the name of the Storage, the third param is the scope, and the\\nlast param is the key.","lua_type":"Signal<string, string, string?, string>","tags":["Event"],"source":{"line":145,"path":"lib/Storage/DataStore.lua"}},{"name":"SaveFail","desc":"Fired when Storage failed to load the requested data after retrying several times.\\nThe first param is the error message, the second param is the name of the Storage, the third param is the scope, and the\\nlast param is the key.","lua_type":"Signal<string, string, string?, string>","tags":["Event"],"source":{"line":154,"path":"lib/Storage/DataStore.lua"}},{"name":"SaveSuccess","desc":"Fired when Storage successfully saved to the [GlobalDataStore].\\nThe only param passed is the index.","lua_type":"Signal<string>","tags":["Event"],"source":{"line":162,"path":"lib/Storage/DataStore.lua"}},{"name":"FilledBlankStorage","desc":"Fired when Storage fills in an empty key.\\nThe first param is the name of the Storage, the second param is the scope, and the last param is the index.","lua_type":"Signal<string, string?, string>","tags":["Event"],"source":{"line":170,"path":"lib/Storage/DataStore.lua"}},{"name":"KeyUpdated","desc":"Fired when a key in Storage is updated.\\nThe first param is the name of the Storage, the second param is the name of the key, the third param is the new data, and\\nthe last param is the old data.","lua_type":"Signal<string, string | number, any, any>","tags":["Event"],"source":{"line":179,"path":"lib/Storage/DataStore.lua"}},{"name":"DeepKeyUpdated","desc":"Fired when a key deep in Storage is updated.\\nThe first param is the name of the index, the second param is the new data, the third param is the new old data, and the\\nlast param is an array of all the additional keys given.","lua_type":"Signal<string, any, any, {string | number}>","tags":["Event"],"source":{"line":188,"path":"lib/Storage/DataStore.lua"}}],"types":[{"name":"BaseStorageResult","desc":"A dictionary containing a success boolean, a message (if getting the DataStore fails), and a result (if getting the\\n\\tDataStore succeeds, this is the BaseStorage object).","lua_type":"Result<BaseStorage?>","source":{"line":84,"path":"lib/Storage/Types.lua"}}],"name":"BaseStorage","desc":"A basic [GlobalDataStore] wrapper object.","realm":["Server"],"source":{"line":110,"path":"lib/Storage/DataStore.lua"}}')}}]);