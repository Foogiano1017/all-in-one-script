local clearGSR = 15 -- minutes
local shotRecently = false

RegisterCommand("cleargsr", function(source, args, raw)
	if shotRecently then
		local plyPed = PlayerPedId()
		ClearPedBloodDamage(plyPed)
		ClearPedEnvDirt(plyPed)
		ResetPedVisibleDamage(plyPed)
		shotRecently = false
		Notify("You have cleared GSR from yourself")
	end
end)
TriggerEvent('chat:addSuggestion', "/cleargsr", "Clear GSR", {})

RegisterCommand("gsrtest", function(source, args, raw)
	local target = GetClosestPlayerRadius(2.0)
	if target == nil then Notify("Target player not found") return; end
	TriggerServerEvent("gsr:doTest", GetPlayerServerId(target))
end)
TriggerEvent('chat:addSuggestion', "/gsrtest", "Do GSR test on closest player", {})

local whitelistedWeapons = {
    [GetHashKey('WEAPON_FIREEXTINGUISHER')] = true,
    [GetHashKey('WEAPON_SNOWBALL')] = true,
    [GetHashKey('WEAPON_PETROLCAN')] = true,
    [GetHashKey('WEAPON_BALL')] = true,
    [GetHashKey("WEAPON_STUNGUN")] = true,

}
Citizen.CreateThread(function()
	local lastShot = 0
	while true do
		Citizen.Wait(1)
		local plyPed = PlayerPedId()
		if IsPedShooting(plyPed) then
			local whash = GetSelectedPedWeapon(plyPed)
			if not whitelistedWeapons[whash] then		
				lastShot = GetGameTimer()
				shotRecently = true
			end
		end
		--print(tostring(shotRecently))

		if shotRecently and GetGameTimer() - lastShot >= (clearGSR * 60 * 1000) then; shotRecently = false; end 
	end
end)

RegisterNetEvent("gsr:requestGSR")
AddEventHandler("gsr:requestGSR", function(policeId)
	TriggerServerEvent("gsr:returnGSR", shotRecently, policeId)
end)

function GetClosestPlayerRadius(radius)
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply)

    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = #(targetCoords - plyCoords)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
	if closestDistance ~= -1 and closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end

function GetPlayers()
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            table.insert(players, player)
        end
    end
    return players
end

RegisterNetEvent("notify")
AddEventHandler("notify", function(s) Notify(s); end)

function Notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(false, true)
end