--- Store user data using the PlayFab API

local clientapi = require "PlayFab.PlayFabClientApi"
local listener = require "ludobits.m.listener"

 
local M = {
	listeners = listener.create()
}

--- Will be triggered when userdata has refreshed
M.REFRESH_SUCCESS = hash("USERDATA_REFRESH_SUCCESS")

--- Will be triggered when userdata failed to refresh
M.REFRESH_FAILED = hash("USERDATA_REFRESH_FAILED")

local data = {}


--- Refresh the user data for the currently logged in player
-- Will trigger a @{REFRESH_SUCCESS} or @{REFRESH_FAILED}
function M.refresh()
	local response, error = clientapi.GetUserData({},
	function(response)
		data = response and response.Data or {}
		M.listeners.trigger(M.REFRESH_SUCCESS)
	end,
	function(error)
		M.listeners.trigger(M.REFRESH_FAILED)
	end)
end


--- Call this function when the user has logged out
-- This will clear any locally stored user data
function M.clear()
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