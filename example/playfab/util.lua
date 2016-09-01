local flow = require "ludobits.m.flow"
local clientapi = require "playfab.client_api.ClientApi"

local M = {}


function M.flow_apis()
	for name,fn in pairs(clientapi) do
	
		local t = {
			flow = function(request)
				return flow.until_callback(function(cb)
					fn(request, cb)
				end)
			end,
		}
		
		local mt = {
			__call = function(self, ...)
				fn(...)
			end,
		}
	
		clientapi[name] = setmetatable(t, mt)
	end
end

return M