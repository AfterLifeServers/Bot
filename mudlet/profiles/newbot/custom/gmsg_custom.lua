Reports = {}
RCount = 0
ActiveAdmins = {}
Blue = "4D4DFF"
Green = "00E600"
Red = "E63900"
LRed = "FF794D"
White = "FFFFFF"
Grey = "BFBFBF"
Orange = "FFA31A"
function gmsg_custom()
	calledFunction = "gmsg_custom"
	-- ###################  do not allow remote commands beyond this point ################
	if (chatvars.playerid == nil) then
		botman.faultyChat = false
		return false
	end
	-- ####################################################################################
	if (chatvars.words[1] == "test" and chatvars.words[2] == "command") then
		message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]This is a sample command in gmsg_custom.lua in the scripts folder.[-]")
		botman.faultyChat = false
		return true
	end
	
	function getIndex(tab, val)
		index = nil
		for i, v in ipairs(tab) do
			if (v.id == val) then
				index = i
			end
		end
		return index
	end
	
	function getRID(tab, val)
		index = nil
		for i, v in ipairs(tab) do
			if (v.rid == val) then
				index = i
			end
		end
		return index
	end
	
	function getADM(tab, val)
		index = nil
		for i, v in ipairs(tab) do
			if (v.acceptingAdmin == val) then
				index = i
			end
		end
		return index
	end
	
	
	
	-- ######################### Report System #########################
	
	-- /REPORT
	if (chatvars.words[1] == "report" and chatvars.words[2] ~= nil) then
		activeReport = getIndex(Reports, chatvars.playerid)
		currentAdmin = getIndex(ActiveAdmins, chatvars.playerid)
		if activeReport ~= nil then
			message("pm " .. chatvars.playerid .. " [" .. Red .. "]You can only have 1 active report at a time. (/cancelreport).[-]")
			return true
		end
		if currentAdmin ~= nil then
			message("pm " .. chatvars.playerid .. " [" .. Red .. "]You can't submit reports as an administrator.[-]")
			return true
		end	
		
		if players[chatvars.playerid].rtoTime - os.time() > 0 then
			message("pm " .. chatvars.playerid .. " [" .. server.chatColour .. "]You have to wait " .. os.date("%M minutes %S seconds",players[chatvars.playerid].rtoTime - os.time()) .. " before you can use /report")
			return true
		end
	
		RCount = RCount + 1
		messages = stripQuotes(string.sub(chatvars.oldLine, string.find(chatvars.oldLine, "report") + 6))	
		table.insert(Reports, { rid = RCount, id = chatvars.playerid, name = players[chatvars.playerid].name, report = messages, acceptingAdmin = 0, Accepted = 0 })	
		if next(ActiveAdmins) == nil then
			message("pm " .. chatvars.playerid .. " [" .. Blue .. "]A new ticket has been generated. There are currently no admins online, you're report will answered shortly.[-]")
		else
			message("pm " .. chatvars.playerid .. " [" .. Blue .. "]A new ticket has been generated, wait for a staff member to answer it.[-]")
		end
		for k,v in pairs(ActiveAdmins) do		
			message("pm " .. v.id .. " [" .. Blue .. "]There's a new incomming assistant ticket. [-]")
		end
		return true
	end
	
	-- View Reports
	if (chatvars.words[1] == "reports") then
		currentAdmin = getIndex(ActiveAdmins, chatvars.playerid)
		if currentAdmin == nil then
			message("pm " .. chatvars.playerid .. " [" .. Red .. "]You don't have access to that command.[-]")
			return true
		end
		message("pm " .. chatvars.playerid .. " [" .. Green .. "]______________ REPORTS ______________[-]")	
		for key, value in pairs(Reports) do		
				
			message("pm " .. chatvars.playerid .. " [" .. Green .. "] RID: " .. value.rid .. " | Pr: " .. players[value.id].name .. " |  Report: " .. value.report .. "[-]")
				
		end
		message("pm " .. chatvars.playerid .. " [" .. Green .. "]__________________________________[-]")	
		return true
	end
	
	
	
	-- Accept Reports	
	if (chatvars.words[1] == "acceptreport") then
		currentReport = getRID(Reports, tonumber(chatvars.words[2]))
		currentAdmin = getIndex(ActiveAdmins, chatvars.playerid)
		if currentAdmin == nil then
			message("pm " .. chatvars.playerid .. " [" .. Red .. "]You don't have access to that command.[-]")
			return true
		end
		if chatvars.words[2] == nil then
			message("pm " .. chatvars.playerid .. " [" .. Grey .. "]USAGE: /acceptreport [reportid].[-]")
			return true
		end
		if currentReport == nil then
			message("pm " .. chatvars.playerid .. " [" .. Grey .. "]That report ID is not being used.[-]")
			return true
		end
		acceptingAdmin = chatvars.playerid
		-- Send message to staff
		for k, v in pairs(ActiveAdmins) do
			for i,o in pairs(Reports) do
				message("pm " .. v.id .. " [" .. Blue .. "]" .. players[acceptingAdmin].name .. " has accepted the report from " .. players[o.id].name .." (RID: " .. chatvars.words[2] .. ")[-]")	
			end
		end
		ActiveAdmins[currentAdmin]["reportCount"] = ActiveAdmins[currentAdmin]["reportCount"] + 1
		Reports[currentReport]["acceptingAdmin"] = chatvars.playerid
		Reports[currentReport]["Accepted"] = 1
		message("pm " .. Reports[currentReport]["id"] .. " [" .. White .. "]" .. players[chatvars.playerid].name .. " has accepted your report and is reviewing it, you can /reply to send messages to the admin reviewing your report.[-]")
		--table.remove(Reports, currentReport)
		return true
	end
	
	if (chatvars.words[1] == "cr") then
		currentReport = getRID(Reports, tonumber(chatvars.words[2]))
		currentAdmin = getIndex(ActiveAdmins, chatvars.playerid)
		if currentAdmin == nil then
			message("pm " .. chatvars.playerid .. " [" .. Red .. "]You don't have access to that command.[-]")
			return true
		end
		if chatvars.words[2] == nil then
			message("pm " .. chatvars.playerid .. " [" .. Grey .. "]USAGE: /cr [reportid].[-]")
			return true
		end
		if currentReport == nil then
			message("pm " .. chatvars.playerid .. " [" .. Grey .. "]That report ID is not being used.[-]")
			return true
		end
		if Reports[currentReport]["acceptingAdmin"] == chatvars.playerid then
			message("pm " .. Reports[currentReport]["id"] .. " [" .. Grey .. "]You're report has been marked complete. If you feel this is in error, please send an email to Info@multiplayergaming.com.[-]")
			table.remove(Reports, currentReport)
			return true
		end
		return true
	end
	
	-- Start Duty
	if (chatvars.words[1] == "start" and chatvars.words[2] == "duty") then	
		if (chatvars.accessLevel < 3) then
			table.insert(ActiveAdmins, {id = chatvars.playerid, reportCount = 0, duty = 0})
			message("pm " .. chatvars.playerid .. " [" .. White .. "]You are now on duty.[-]")
			for key, value in pairs(ActiveAdmins) do
				message("pm " .. value.id .. " [" .. Blue .. "]" .. players[chatvars.playerid].name .. " is now on duty.[-]")					
			end
			activeReport = getIndex(Reports, chatvars.playerid)
			if activeReport ~= nil then
				table.remove(Reports, activeReport)
			end
		end	
		return true
	end
	
	-- End Duty
	if (chatvars.words[1] == "end" and chatvars.words[2] == "duty") then	
		if (chatvars.accessLevel < 3) then
			idx = getIndex(ActiveAdmins, chatvars.playerid)	
			table.remove(ActiveAdmins, idx)	
			message("pm " .. chatvars.playerid .. " [" .. White .. "]You are now off duty.[-]")	
			for k,v in pairs(ActiveAdmins) do
				message("pm " .. v.id .. " [" .. Blue .. "]" .. players[chatvars.playerid].name .. " has went off duty.[-]")
			end			
		end	
		return true
	end
	
	
	-- Cancel Report
	if (chatvars.words[1] == "cancelreport") then
		idx = getIndex(Reports, chatvars.playerid)
		if (idx == nil) then
			message("pm " .. chatvars.playerid .. " [" .. White .. "]You don't have any pending reports.[-]")
		else
			table.remove(Reports, idx)
			message("pm " .. chatvars.playerid .. " [" .. White .. "]You have successfully canceled your report.[-]")
		end
		return true
	end
	
	-- Check On Duty Admins
	if (chatvars.words[1] == "checkduty") then
		if ActiveAdmins == nil then
			message("pm " .. v.id .. " [" .. AErrColor .. "]No admins are on duty.[-]")
		else
			message("pm " .. chatvars.playerid .. " [" .. Green .. "]___________ On Duty Admins ___________[-]")
			for key,value in pairs(ActiveAdmins) do
			message("pm " .. chatvars.playerid .. " [" .. Green .. "] Admin: " .. players[value.id].name .. " |  Report Count: " .. value.reportCount .. "[-]")
			end
			message("pm " .. chatvars.playerid .. " [" .. Green .. "]__________________________________[-]")
		end
		return true
	end
	
	
	
	-- Trash Report
	if (chatvars.words[1] == "tr") then
		currentReport = getRID(Reports, tonumber(chatvars.words[2]))
		currentAdmin = getIndex(ActiveAdmins, chatvars.playerid)
		if currentAdmin == nil then
			message("pm " .. chatvars.playerid .. " [" .. Red .. "]You do not have access to that command.[-]")
			return true
		end
		if chatvars.words[2] == nil then
			message("pm " .. chatvars.playerid .. " [" .. Grey .. "]USAGE: /tr [reportid].[-]")
			return true
		end
		if currentReport == nil then
			message("pm " .. chatvars.playerid .. " [" .. Grey .. "]That report ID is not being used.[-]")
			return true
		end
		for k,v in pairs(ActiveAdmins) do 
			message("pm " .. v.id .. " [" .. Orange .. "]" .. players[chatvars.playerid].name .. " has trashed the report from " .. players[Reports[currentReport]["id"]].name .. "[-]")
		end
		message("pm " .. Reports[currentReport]["id"] .. " [" .. White .. "]" .. players[chatvars.playerid].name .. " has marked your report invalid. It will not be reviewed. Please check /reporttips[-]")
		table.remove(Reports, currentReport)
		return true
	end
	
	
	-- Report Tips	
	if (chatvars.words[1] == "reporttips") then
		message("pm " .. chatvars.playerid .. " [" .. Orange .. "]Tips for reporting:[-]")
		message("pm " .. chatvars.playerid .. " [" .. Orange .. "] - Report what you need, not who you need.[-]")
		message("pm " .. chatvars.playerid .. " [" .. Orange .. "] - Be specific, report exactly what you need.[-]")
		message("pm " .. chatvars.playerid .. " [" .. Orange .. "] - Do not make false reports.[-]")
		message("pm " .. chatvars.playerid .. " [" .. Orange .. "] - Do not flame admins.[-]")
		message("pm " .. chatvars.playerid .. " [" .. Orange .. "] - Report only for in-game items.[-]")
		return true
	end
	
	
	-- Reply
	if (chatvars.words[1] == "reply") then
		currentAdmin = getIndex(ActiveAdmins, chatvars.playerid)
		if currentAdmin == nil then
			currentReport = getIndex(Reports, chatvars.playerid)
			if currentReport == nil then
				message("pm " .. chatvars.playerid .. " [" .. Grey .. "]You do not have any open reports.[-]")
				return true
			end		
			if chatvars.words[2] == nil then
				message("pm " .. chatvars.playerid .. " [" .. Grey .. "]USAGE: /reply [message][-]")
				return true
			end
			messages = stripQuotes(string.sub(chatvars.oldLine, string.find(chatvars.oldLine, "reply") + 6))	
			message("pm " .. Reports[currentReport]["acceptingAdmin"] .. " [" .. Grey .. "]" .. players[Reports[currentReport]["id"]].name .. " says: " .. messages .. "[-]")
			return true
		else
			currentReport = getADM(Reports, chatvars.playerid)	
			if currentReport == nil then
				message("pm " .. chatvars.playerid .. " [" .. Grey .. "]You do not have any open reports.[-]")
				return true
			end	
			if chatvars.words[2] == nil then
				message("pm " .. chatvars.playerid .. " [" .. Grey .. "]USAGE: /reply [message][-]")
				return true
			end
			messages = stripQuotes(string.sub(chatvars.oldLine, string.find(chatvars.oldLine, "reply") + 6))		
			message("pm " .. Reports[currentReport]["id"] .. " [" .. Grey .. "]" .. players[Reports[currentReport]["acceptingAdmin"]].name .. " says: " .. messages .. "[-]")	
			return true
		end
		
	end
	
	
	
	-- Report Mute
	if (chatvars.words[1] == "rmute") then
		currentReport = getRID(Reports, chatvars.words[2])
		currentAdmin = getIndex(ActiveAdmins, chatvars.playerid)
		if currentAdmin == nil then
			message("pm " .. chatvars.playerid .. " [" .. Red .. "]You do not have access to that command.[-]")
			return true
		end
		if chatvars.words[2] == nil then
			message("pm " .. chatvars.playerid .. " [" .. Grey .. "]USAGE: /rmute [Player Name].[-]")
			return true
		end
		if currentReport == nil then
			message("pm " .. chatvars.playerid .. " [" .. Grey .. "]That report ID is not being used.[-]")
			return true
		end
		if player[Reports[currentReport]["id"]].rMute == 1 then
			players[Reports[currentReport]["id"]].rMute = 0
			message("pm " .. Reports[currentReport]["id"] .. " [" .. Grey .. "]You have been re-allowed to submit /reports again by " .. chatvars.playerid .. "[-]")
			if botman.dbConnected then conn:execute("UPDATE players SET rMute = 0 WHERE steam = " .. Reports[currentReport]["id"]) end
			for k, v in pairs(ActiveAdmins) do
				message("pm " .. v.id .. " [" .. LRed .. "]" .. players[chatvars.playerid].name .. " has been re-allowed to submit reports by " .. players[Reports[currentReport]["id"]].name .. " from submitting reports.[-]")
			end
		end	
		if player[Reports[currentReport]["id"]].rMute == 0 then
			players[Reports[currentReport]["id"]].rMute = 1
			message("pm " .. Reports[currentReport]["id"] .. " [" .. Grey .. "]You have been blocked from submitting /reports by " .. chatvars.playerid .. "[-]")
			if botman.dbConnected then conn:execute("UPDATE players SET rMute = 1 WHERE steam = " .. Reports[currentReport]["id"]) end
			for k, v in pairs(ActiveAdmins) do
				message("pm " .. v.id .. " [" .. LRed .. "]" .. players[chatvars.playerid].name .. " has indefinitely blocked " .. players[Reports[currentReport]["id"]].name .. " from submitting reports.[-]")
			end
		end
		return true
	end
	
	-- Report RTO/Strikes	
	if (chatvars.words[1] == "rto") then
		currentReport = getRID(Reports, tonumber(chatvars.words[2]))
		currentAdmin = getIndex(ActiveAdmins, chatvars.playerid)	
		if currentAdmin == nil then
			message("pm " .. chatvars.playerid .. " [" .. Red .. "]You do not have access to that command.[-]")
			return true
		end
		if chatvars.words[2] == nil then
			message("pm " .. chatvars.playerid .. " [" .. Grey .. "]USAGE: /rto [reportid].[-]")
			return true
		end
		if currentReport == nil then
			message("pm " .. chatvars.playerid .. " [" .. Grey .. "]That report ID is not being used.[-]")
			return true
		end	
		if players[Reports[currentReport]["id"]].rto == 0 then
			message("pm " .. Reports[currentReport]["id"] .. " [" .. Grey .. "]You have been warned not to abuse /report.[-]")
			message("pm " .. Reports[currentReport]["id"] .. " [" .. Grey .. "]Note that future abuse of /report could resut in a mute from /report or loss of that privilege altogether.[-]")
			if botman.dbConnected then conn:execute("UPDATE players SET rto = 1 WHERE steam = " .. Reports[currentReport]["id"]) end
			players[Reports[currentReport]["id"]].rto = players[Reports[currentReport]["id"]].rto + 1
			for k, v in pairs(ActiveAdmins) do
				message("pm " .. v.id .. " [" .. LRed .. "]" .. players[chatvars.playerid].name .. " has given " .. players[Reports[currentReport]["id"]].name .. " their first wanring about report abuse.[-]")
			end
			return true
		end
		if players[Reports[currentReport]["id"]].rto == 1 then
			message("pm " .. Reports[currentReport]["id"] .. " [" .. Grey .. "]You have been temporarily blocked from submitting reports by " .. chatvars.playerid .. "[-]")
			message("pm " .. Reports[currentReport]["id"] .. " [" .. Grey .. "]As this is the second time you have been blocked from reporting, you will not be able to use /report for 15 minutes.[-]")
			message("pm " .. Reports[currentReport]["id"] .. " [" .. Grey .. "]Note that future abuse of /report could result in a longer mute from /report or loss of that privilege altogether.[-]")
			players[Reports[currentReport]["id"]].rto = players[Reports[currentReport]["id"]].rto + 1
			players[Reports[currentReport]["id"]].rtoTime = (os.time() + 900)
			if botman.dbConnected then conn:execute("UPDATE players SET rto = 2, rtoTime = ".. players[Reports[currentReport]["id"]].rtoTime .." WHERE steam = " .. Reports[currentReport]["id"]) end
			for k, v in pairs(ActiveAdmins) do
				message("pm " .. v.id .. " [" .. LRed .. "]" .. players[chatvars.playerid].name .. " has temporarily blocked " .. players[Reports[currentReport]["id"]].name .. " from submitting reports.[-]")
			end
			return true
		end
		if players[Reports[currentReport]["id"]].rto == 2 then
			message("pm " .. Reports[currentReport]["id"] .. " [" .. Grey .. "]You have been temporarily blocked from submitting reports by " .. chatvars.playerid .. "[-]")
			message("pm " .. Reports[currentReport]["id"] .. " [" .. Grey .. "]As this is the third time you have been blocked from reporting, you will not be able to use /report for 30 minutes.[-]")
			message("pm " .. Reports[currentReport]["id"] .. " [" .. Grey .. "]Note that future abuse of /report could result in a longer mute from /report or loss of that privilege altogether.[-]")
			players[Reports[currentReport]["id"]].rto = players[Reports[currentReport]["id"]].rto + 1
			players[Reports[currentReport]["id"]].rtoTime = (os.time() + 1800)
			if botman.dbConnected then conn:execute("UPDATE players SET rto = 2, rtoTime = ".. players[Reports[currentReport]["id"]].rtoTime .." WHERE steam = " .. Reports[currentReport]["id"]) end
			for k, v in pairs(ActiveAdmins) do
				message("pm " .. v.id .. " [" .. LRed .. "]" .. players[chatvars.playerid].name .. " has temporarily blocked " .. players[Reports[currentReport]["id"]].name .. " from submitting reports.[-]")
			end
			return true
		end
		if players[Reports[currentReport]["id"]].rto == 3 then
			message("pm " .. Reports[currentReport]["id"] .. " [" .. Grey .. "]You have been temporarily blocked from submitting reports by " .. chatvars.playerid .. "[-]")
			message("pm " .. Reports[currentReport]["id"] .. " [" .. Grey .. "]As this is the fourth time you have been blocked from reporting, you will not be able to use /report for 45 minutes.[-]")
			message("pm " .. Reports[currentReport]["id"] .. " [" .. Grey .. "]Note that future abuse of /report could result in a longer mute from /report or loss of that privilege altogether.[-]")
			players[Reports[currentReport]["id"]].rto = players[Reports[currentReport]["id"]].rto + 1
			players[Reports[currentReport]["id"]].rtoTime = (os.time() + 2700)
			if botman.dbConnected then conn:execute("UPDATE players SET rto = 3, rtoTime = ".. players[Reports[currentReport]["id"]].rtoTime .." WHERE steam = " .. Reports[currentReport]["id"]) end
			for k, v in pairs(ActiveAdmins) do
				message("pm " .. v.id .. " [" .. LRed .. "]" .. players[chatvars.playerid].name .. " has temporarily blocked " .. players[Reports[currentReport]["id"]].name .. " from submitting reports.[-]")
			end
			return true
		end
		if players[Reports[currentReport]["id"]].rto == 4 then
			message("pm " .. Reports[currentReport]["id"] .. " [" .. Grey .. "]You have been temporarily blocked from submitting reports by " .. chatvars.playerid .. "[-]")
			message("pm " .. Reports[currentReport]["id"] .. " [" .. Grey .. "]As this is the fifth time you have been blocked from reporting, you will not be able to use /report for 60 minutes.[-]")
			message("pm " .. Reports[currentReport]["id"] .. " [" .. Grey .. "]Note that future abuse of /report could result in a longer mute from /report or loss of that privilege altogether.[-]")
			players[Reports[currentReport]["id"]].rto = players[Reports[currentReport]["id"]].rto + 1
			players[Reports[currentReport]["id"]].rtoTime = (os.time() + 3600)
			if botman.dbConnected then conn:execute("UPDATE players SET rto = 4, rtoTime = ".. players[Reports[currentReport]["id"]].rtoTime .." WHERE steam = " .. Reports[currentReport]["id"]) end
			for k, v in pairs(ActiveAdmins) do
				message("pm " .. v.id .. " [" .. LRed .. "]" .. players[chatvars.playerid].name .. " has temporarily blocked " .. players[Reports[currentReport]["id"]].name .. " from submitting reports.[-]")
			end
			return true
		end
		if players[Reports[currentReport]["id"]].rto == 5 then
			message("pm " .. Reports[currentReport]["id"] .. " [" .. Grey .. "]You have been temporarily blocked from submitting reports by " .. chatvars.playerid .. "[-]")
			message("pm " .. Reports[currentReport]["id"] .. " [" .. Grey .. "]As this is the sixth time you have been blocked from reporting, you will not be able to use /report for 5 hours.[-]")
			message("pm " .. Reports[currentReport]["id"] .. " [" .. Grey .. "]Note that future abuse of /report could result in a longer mute from /report or loss of that privilege altogether.[-]")
			players[Reports[currentReport]["id"]].rto = players[Reports[currentReport]["id"]].rto + 1
			players[Reports[currentReport]["id"]].rtoTime = (os.time() + 18000)
			if botman.dbConnected then conn:execute("UPDATE players SET rto = 5, rtoTime = ".. players[Reports[currentReport]["id"]].rtoTime .." WHERE steam = " .. Reports[currentReport]["id"]) end
			for k, v in pairs(ActiveAdmins) do
				message("pm " .. v.id .. " [" .. LRed .. "]" .. players[chatvars.playerid].name .. " has temporarily blocked " .. players[Reports[currentReport]["id"]].name .. " from submitting reports.[-]")
			end
			return true
		end
		return true
	end
	
	-- Tacos
	if (chatvars.words[1] == "taco4gekko") then
		sendCommand("bc-give " .. chatvars.playerid .. " taco /c=1 /q=600 /silent")
		return true
	end
	
	
	-- Clear Reports table
	if (chatvars.words[1] == "cleartable") then
		Reports = {}
		RCount = 0
		return true
	end
	
	-- ########### End Admin Reports ##############
	
	
	
	
	
	
end
