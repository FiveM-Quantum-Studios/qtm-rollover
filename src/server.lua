-- local ESX = exports['es_extended']:getSharedObject()

-- local function detectRollover(vehicle)
--     local isUpsideDown = IsVehicleUpsideDown(vehicle)
--     local isOnRoof = IsEntityUpsidedown(vehicle)

--     return isUpsideDown or isOnRoof
-- end

-- local function applyCrashDamage(ped, vehicle)
--     local speed = GetEntitySpeed(vehicle) * 3.6  -- Convert to km/h
--     local threshold = 50  -- Define a speed threshold for a "bad accident"

--     if speed > threshold then
--         local damage = (speed - threshold) * 2  -- Calculate damage based on speed
--         local currentHealth = GetEntityHealth(ped)
--         local newHealth = currentHealth - damage

--         if newHealth < 0 then
--             newHealth = 0
--         end

--         SetEntityHealth(ped, newHealth)
--         -- Optional: notify the player
--         TriggerClientEvent('esx:showNotification', GetPlayerServerId(NetworkGetEntityOwner(ped)), 'You were injured in a bad car accident!')
--     end
-- end

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(1000)  -- Check every second

--         local players = ESX.GetPlayers()
--         for _, playerId in ipairs(players) do
--             local xPlayer = ESX.GetPlayerFromId(playerId)
--             local ped = GetPlayerPed(playerId)
--             if IsPedInAnyVehicle(ped, false) then
--                 local vehicle = GetVehiclePedIsIn(ped, false)
--                 if detectRollover(vehicle) then
--                     SetVehicleEngineHealth(vehicle, 0)
--                     -- Apply damage to all players in the vehicle
--                     local occupants = GetVehicleNumberOfPassengers(vehicle)
--                     for i = -1, occupants - 1 do
--                         local occupantPed = GetPedInVehicleSeat(vehicle, i)
--                         if occupantPed and occupantPed ~= 0 then
--                             applyCrashDamage(occupantPed, vehicle)
--                         end
--                     end
--                     -- Optional: notify the driver
--                     TriggerClientEvent('esx:showNotification', playerId, 'Your vehicle has rolled over, engine is damaged, and you were injured!')
--                 end
--             end
--         end
--     end
-- end)
