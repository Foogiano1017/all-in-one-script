Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) -- Prevent crashing.

		-- Stop Spawn
		SetCreateRandomCops(true)
		SetCreateRandomCopsNotOnScenarios(true)
		SetCreateRandomCopsOnScenarios(true)
		SetGarbageTrucks(true)
		SetRandomBoats(true)
       		SetVehicleDensityMultiplierThisFrame(2.5)
       		SetPedDensityMultiplierThisFrame(3.0)
		SetRandomVehicleDensityMultiplierThisFrame(3.0)
		SetScenarioPedDensityMultiplierThisFrame(1.0, 0.8)
		SetParkedVehicleDensityMultiplierThisFrame(2.6)

		-- Clear NPC
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
		ClearAreaOfVehicles(x, y, z, 1000, false, false, false, false, false)
		RemoveVehiclesFromGeneratorsInArea(x - 500.0, y - 500.0, z - 500.0, x + 500.0, y + 500.0, z + 500.0);
    end
end)
