local M = {}

M.CONTROLLER = "main:/controller"

function M.startmenu()
	msg.post(M.CONTROLLER, "show_startmenu")
end

function M.game()
	msg.post(M.CONTROLLER, "show_game")
end

function M.login()
	msg.post(M.CONTROLLER, "show_login")
end

function M.register()
	msg.post(M.CONTROLLER, "show_register")
end

function M.settings()
	msg.post(M.CONTROLLER, "show_settings")
end

function M.leaderboard()
	msg.post(M.CONTROLLER, "show_leaderboard")
end

function M.show_popup(text)
	msg.post(M.CONTROLLER, "show_popup", { text = text })
end

function M.hide_popup()
	msg.post(M.CONTROLLER, "hide_popup")
end

function M.show_spinner()
	msg.post("main:/spinner#spinner", "show")
end

function M.hide_spinner()
	msg.post("main:/spinner#spinner", "hide")
end

return M