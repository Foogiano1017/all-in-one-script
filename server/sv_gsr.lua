RegisterNetEvent("gsr:doTest")
AddEventHandler("gsr:doTest", function(target)
	local src = source
	TriggerClientEvent('gsr:requestGSR', target, src)	
end)

RegisterNetEvent("gsr:returnGSR")
AddEventHandler("gsr:returnGSR", function(shotRecently, policeId)
	local src = source
	local result = '~r~NEGATIVE'
	if shotRecently then result = '~g~POSITIVE'; end
	TriggerClientEvent('notify', policeId, "The GSR Test has returned "..result)
end)