local client = require "PlayFab.PlayFabClientApi"

local M = {}

M.leaderboard = {}

M.playfab_id = nil

local function get_for_player()
	local request = {
		StatisticName = "score"
	}
	local response, error = client.GetLeaderboardAroundPlayer.flow(request)
	if not error then
		M.leaderboard = response.Leaderboard
	end
	return response, error
end

function M.on_login(playfab_id)
	M.playfab_id = playfab_id
	return get_for_player()
end


function M.on_logout()
	M.leaderboard = {}
	M.playfab_id = nil
end


function M.get_score(playfab_id)
	for k,v in pairs(M.leaderboard) do
		if v.PlayFabId == playfab_id then
			return v.StatValue
		end
	end
end

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
		return response, error
	end
	return get_for_player()
end

function M.get()
	return M.leaderboard
end

return M