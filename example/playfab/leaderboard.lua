--- This module keeps track of a PlayFab leaderboard

local client = require "PlayFab.PlayFabClientApi"

local M = {}

M.leaderboard = {}

M.playfab_id = nil

local function get_for_player()
	local request = {
		StatisticName = "score"
	}
	local response, error = client.GetLeaderboardAroundPlayer.flow(request)
	if error then
		return false, error
	else
		M.leaderboard = response.Leaderboard
		return true, error
	end
end

--- Should be called when the user has logged in.
-- The function will get the leaderboard for the currently
-- logged in player
-- @param playfab_id
-- @return success
-- @return error 
function M.on_login(playfab_id)
	M.playfab_id = playfab_id
	return get_for_player()
end

--- Call this function when the user logs out
-- Will clear the current leaderboard
function M.on_logout()
	M.leaderboard = {}
	M.playfab_id = nil
end


--- Get the score of a player in the leaderboard
-- @param playfab_id
-- @return The score or nil 
function M.get_score(playfab_id)
	for k,v in pairs(M.leaderboard) do
		if v.PlayFabId == playfab_id then
			return v.StatValue
		end
	end
end

--- Update the score for the currently logged in user
-- @param score
-- @return success
-- @return error
function M.update(score)
	local current_score = M.get_score(M.playfab_id)
	if current_score > score then
		return true
	end
	
	local request = {
		Statistics = {
			{
				StatisticName = "score",
				Value = score,
			},
		}
	}
	local response, error = client.UpdatePlayerStatistics.flow(request)
	if error then
		return false, error
	end
	return get_for_player()
end


--- Get the leaderboard data
-- @return Leaderboard data
function M.get()
	return M.leaderboard
end

return M