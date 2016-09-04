--- Store user data using the PlayFab API

local clientapi = require "PlayFab.PlayFabClientApi"
 
local M = {}

local data = {}

--- Get the user data for the currently logged in player
-- Call this function when the user has logged in
-- @return success
-- @return error
function M.on_login()
	local response, error = clientapi.GetUserData.flow({})
	if error then
		return false, error
	end
	data = response and response.Data or {}
	return true, error
end

--- Call this function when the user has logged out
-- This will clear any locally stored user data
function M.on_logout()
	data = {}
end

--- Get stored user data
-- @param key The key to get value for
-- @param default Default value to return if no value exists
-- @return The value stored for the key, or default value
function M.get(key, default)
	return data[key] and data[key].Value or default
end

--- Set user data for a specific key
-- @param key
-- @param value
-- @return success
-- @return error
function M.set(key, value)
	local response, error = clientapi.UpdateUserData.flow({ Data = { [key] = value }})
	if error then
		return false, error
	else
		data[key] = { Value = value }
		return true, error
	end
end

return M