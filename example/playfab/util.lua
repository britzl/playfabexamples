local flow = require "ludobits.m.flow"
local client = require "PlayFab.PlayFabClientApi"
--local server = require "PlayFab.PlayFabServerApi"

local M = {}

local function wrap(api)
	for name,value in pairs(api) do
		if type(value) == "function" and name ~= "IsClientLoggedIn" and name ~= "_MultiStepClientLogin" then
			local t = {
				flow = function(request)
					return flow.until_callback(function(cb)
						value(request, function(response)
							cb(response)
						end,
						function(error)
							cb(nil, error)
						end)
					end)
				end,
			}
			
			local mt = {
				__call = function(self, ...)
					value(...)
				end,
			}
		
			api[name] = setmetatable(t, mt)
		end
	end
end

function M.flow_apis()
	wrap(client)
	--wrap(server)
end


return M