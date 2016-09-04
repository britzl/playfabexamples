--- This module will add synchronous call functionality to the PlayFab API
-- The synchronous call functionality allows the API user to get rid of deeply
-- nested callback structures when making multiple API calls in sequence.
--
-- Instead of:
-- 
-- playfab.LoginWithPlayFab({}, function(response)
-- 	  playfab.GetUserData({}, function(response)
-- 		-- handle user data
-- 		playfab.GetLeaderboardAroundPlayer({}, function(response)
-- 			-- handle leaderboard
-- 		end,
-- 		function(error)
-- 			print(error)
-- 		end)
-- 	  end,
-- 	  function(error)
-- 		print(error)
-- 	end)
-- end,
-- function(error)
-- 	  print(error)
-- end)
--
-- It's possible to write something like this:
-- 
-- local response, error = playfab.LoginWithPlayFab.flow({})
-- if error then
-- 	  print(error)
-- 	  return
-- end
-- local response, error = playfab.GetUserData.flow({})
-- if error then
-- 	print(error)
-- 	  return
-- end
-- -- handle user data
-- local response, error = playfab.GetLeaderboardAroundPlayer.flow({})
-- if error then
-- 	  print(error)
-- 	  return
-- end
-- -- handle leaderboard

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