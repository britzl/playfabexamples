local clientapi = require "PlayFab.PlayFabClientApi"
 
local M = {}

local data = {}

function M.on_login()
	local response, error = clientapi.GetUserData.flow({})
	data = response and response.Data or {}
	return response, error
end

function M.on_logout()
	data = {}
end

function M.get(key, default)
	return data[key] and data[key].Value or default
end

function M.set(key, value)
	local response, error = clientapi.UpdateUserData.flow({ Data = { [key] = value }})
	if not error then
		data[key] = { Value = value }
	end
	return response, error
end

return M