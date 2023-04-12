"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[7189],{44035:e=>{e.exports=JSON.parse('{"functions":[{"name":"GetOrderedDataStore","desc":"Returns a [OrderedDataStore] object, given a name and an optional scope parameter.","params":[{"name":"name","desc":"The name of the [OrderedDataStore].","lua_type":"string"},{"name":"scope","desc":"The scope of the [OrderedDataStore].","lua_type":"string?"}],"returns":[{"desc":"","lua_type":"OrderedDataStoreResult\\r\\n"}],"function_type":"method","yields":true,"source":{"line":226,"path":"lib/Storage/OrderedDataStore.lua"}},{"name":"new","desc":"Creates a new [OrderedStorageResult] object.","params":[{"name":"name","desc":"The name of the [OrderedDataStore].","lua_type":"string"},{"name":"scope","desc":"The scope of the [OrderedDataStore].","lua_type":"string?"},{"name":"default","desc":"Default data to be used for blank entries.","lua_type":"number"}],"returns":[{"desc":"","lua_type":"OrderedStorageResult\\r\\n"}],"function_type":"static","yields":true,"source":{"line":269,"path":"lib/Storage/OrderedDataStore.lua"}},{"name":"HardLoad","desc":"Performs GetAsync if the data requested by the index does not exist, and returns the data.\\n\\n\\n\\t","params":[{"name":"self","desc":"","lua_type":"OrderedStorage"},{"name":"index","desc":"The key within the [OrderedDataStore].","lua_type":"string"}],"returns":[{"desc":"","lua_type":"DataResult\\r\\n"}],"function_type":"static","yields":true,"source":{"line":303,"path":"lib/Storage/OrderedDataStore.lua"}},{"name":"SoftLoad","desc":"Returns data associated with the index, if it has been loaded already.\\n\\n\\n\\t","params":[{"name":"self","desc":"","lua_type":"OrderedStorage"},{"name":"index","desc":"The key within the [OrderedDataStore].","lua_type":"string"}],"returns":[{"desc":"","lua_type":"DataResult\\r\\n"}],"function_type":"static","source":{"line":402,"path":"lib/Storage/OrderedDataStore.lua"}},{"name":"HardSave","desc":"Performs SetAsync with the data associated with the index, if it isn\'t already being saved.\\n\\n\\n\\t","params":[{"name":"self","desc":"","lua_type":"OrderedStorage"},{"name":"index","desc":"The key within the [OrderedDataStore].","lua_type":"string"},{"name":"ids","desc":"","lua_type":"{number}?"},{"name":"setOptions","desc":"","lua_type":"DataStoreSetOptions?"}],"returns":[{"desc":"","lua_type":"SaveResult\\r\\n"}],"function_type":"static","yields":true,"source":{"line":446,"path":"lib/Storage/OrderedDataStore.lua"}},{"name":"SoftSave","desc":"Replaces all the data associated with the index.\\n\\n\\n\\t","params":[{"name":"self","desc":"","lua_type":"OrderedStorage"},{"name":"index","desc":"The key within the [OrderedDataStore].","lua_type":"string"},{"name":"newData","desc":"","lua_type":"any"}],"returns":[{"desc":"","lua_type":"SaveResult\\r\\n"}],"function_type":"static","source":{"line":516,"path":"lib/Storage/OrderedDataStore.lua"}},{"name":"GetPages","desc":"Returns a [PageResult] object.\\n\\n\\n\\t","params":[{"name":"self","desc":"","lua_type":"OrderedStorage"},{"name":"ascending","desc":"Whether the list is in descending order or ascending order.","lua_type":"boolean"},{"name":"pageSize","desc":"The length of each page.","lua_type":"number"},{"name":"min","desc":"The minimum value to be included in the pages.","lua_type":"number"},{"name":"max","desc":"The maximum value to be included in the pages.","lua_type":"number"}],"returns":[{"desc":"","lua_type":"PageResult\\r\\n"}],"function_type":"static","yields":true,"source":{"line":565,"path":"lib/Storage/OrderedDataStore.lua"}},{"name":"Clear","desc":"Hard saves the data, then removes the data associated with the index.\\n\\n\\n\\t","params":[{"name":"self","desc":"","lua_type":"OrderedStorage"},{"name":"index","desc":"The key within the [OrderedDataStore].","lua_type":"string"}],"returns":[],"function_type":"static","yields":true,"source":{"line":609,"path":"lib/Storage/OrderedDataStore.lua"}},{"name":"Close","desc":"Saves all data, and clears it\'s own members.\\n\\t","params":[{"name":"self","desc":"","lua_type":"OrderedStorage"}],"returns":[],"function_type":"static","yields":true,"source":{"line":628,"path":"lib/Storage/OrderedDataStore.lua"}}],"properties":[{"name":"LoadRetry","desc":"Fired when Storage is going to retry loading the requested data, if it previously failed.\\nThe first param is the error message, the second param is the name of the Storage, the third param is the scope, and the\\nlast param is the key.","lua_type":"Signal<string, string, string?, string>","tags":["Event"],"source":{"line":149,"path":"lib/Storage/OrderedDataStore.lua"}},{"name":"LoadFail","desc":"Fired when Storage failed to load the requested data after retrying several times.\\nThe first param is the error message, the second param is the name of the Storage, the third param is the scope, and the\\nlast param is the key.","lua_type":"Signal<string, string, string?, string>","tags":["Event"],"source":{"line":158,"path":"lib/Storage/OrderedDataStore.lua"}},{"name":"SaveStart","desc":"Fired when Storage is going to try to save to [OrderedDataStore].\\nThe only param passed is the index.","lua_type":"Signal<string>","tags":["Event"],"source":{"line":166,"path":"lib/Storage/OrderedDataStore.lua"}},{"name":"SaveRetry","desc":"Fired when Storage is going to retry saving the requested data, if it previously failed.\\nThe first param is the error message, the second param is the name of the Storage, the third param is the scope, and the\\nlast param is the key.","lua_type":"Signal<string, string, string?, string>","tags":["Event"],"source":{"line":175,"path":"lib/Storage/OrderedDataStore.lua"}},{"name":"SaveFail","desc":"Fired when Storage failed to load the requested data after retrying several times.\\nThe first param is the error message, the second param is the name of the Storage, the third param is the scope, and the\\nlast param is the key.","lua_type":"Signal<string, string, string?, string>","tags":["Event"],"source":{"line":184,"path":"lib/Storage/OrderedDataStore.lua"}},{"name":"SaveSuccess","desc":"Fired when Storage successfully saved to the [OrderedDataStore].\\nThe only param passed is the index.","lua_type":"Signal<string>","tags":["Event"],"source":{"line":192,"path":"lib/Storage/OrderedDataStore.lua"}},{"name":"FilledBlankStorage","desc":"Fired when Storage fills in an empty key.\\nThe first param is the name of the Storage, the second param is the scope, and the last param is the index.","lua_type":"Signal<string, string?, string>","tags":["Event"],"source":{"line":200,"path":"lib/Storage/OrderedDataStore.lua"}},{"name":"GetSortedAsyncRetry","desc":"Fired when Storage is going to retry getting the requested page data, if it previously failed.\\nThe first param is the error message, the second param is the name of the Storage, and the last param is the scope.","lua_type":"Signal<string, string, string?>","tags":["Event"],"source":{"line":208,"path":"lib/Storage/OrderedDataStore.lua"}},{"name":"GetSortedAsyncFail","desc":"Fired when Storage failed to load the requested page data after retrying several times.\\nThe first param is the error message, the second param is the name of the Storage, and the last param is the scope.","lua_type":"Signal<string, string, string?>","tags":["Event"],"source":{"line":216,"path":"lib/Storage/OrderedDataStore.lua"}}],"types":[{"name":"PageResult","desc":"A dictionary containing a success boolean, a message (if saving the data fails), and a result (if getting the data\\n\\tsucceeds, then this is the DataStoreKeyPages object).","lua_type":"Result<DataStoreKeyPages?>","source":{"line":38,"path":"lib/Storage/Types.lua"}},{"name":"OrderedDataStoreResult","desc":"A table containing data members for success, message, and result. The message data member is only used when success is\\n\\tfalse, and result is only used when success is true, and contains the OrderedDataStore.","lua_type":"Result<OrderedDataStore?>","source":{"line":45,"path":"lib/Storage/Types.lua"}},{"name":"OrderedStorageResult","desc":"A dictionary containing a success boolean, a message (if getting the DataStore fails), and a result (if getting the\\n\\tDataStore succeeds, this is the OrderedStorage object).","lua_type":"Result<OrderedStorage?>","source":{"line":129,"path":"lib/Storage/Types.lua"}}],"name":"OrderedStorage","desc":"A basic [OrderedDataStore] wrapper object.","realm":["Server"],"source":{"line":140,"path":"lib/Storage/OrderedDataStore.lua"}}')}}]);