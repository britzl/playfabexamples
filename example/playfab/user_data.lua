local playfab = require "playfab_defold.playfab"
local clientapi = require "playfab.client_api.ClientApi"
local GetUserDataRequest = require "playfab.client_api.datatype.GetUserDataRequest"
local UpdateUserDataRequest = require "playfab.client_api.datatype.UpdateUserDataRequest"
 
local M = {}

local data = {}

function M.on_login()
	local response, error = clientapi.GetUserData.flow({})
	data = response and response.data and response.data.Data or {}
	return response, error
end

function M.on_logout()
	data = {}
end

function M.get(key, default)
	return data[key] and data[key].Value or default
end

function M.set(key, value)
	local response, error = clientapi.UpdateUserData.flow(UpdateUserDataRequest.create({ [key] = value }))
	if response and response.data then
		data[key] = { Value = value }
	end
	return response, error
end

return M