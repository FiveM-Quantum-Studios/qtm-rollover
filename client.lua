local triggered = false

local function detectRollover(vehicle)
    local isOnRoof = IsEntityUpsidedown(vehicle)
    return isOnRoof
end

local function applyCrashDamage(ped, vehicle)
    local speed = GetEntitySpeed(vehicle) * 3.6  -- Convert to km/h
    local threshold = 50
    -- Apply camera shake
    local intensity = math.min(1.0, (speed - threshold) / 100) -- Cap the intensity to a maximum of 1.0
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', intensity)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)  -- Check every second

        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) and not triggered then
            local vehicle = GetVehiclePedIsIn(ped, false)
            if detectRollover(vehicle) then
                triggered = true
                SetVehicleEngineHealth(vehicle, 0)
                --Apply damage to all players in the vehicle
                local occupants = GetVehicleNumberOfPassengers(vehicle)
                for i = -1, occupants - 1 do
                    local occupantPed = GetPedInVehicleSeat(vehicle, i)
                    if occupantPed and occupantPed ~= 0 then
                        applyCrashDamage(occupantPed, vehicle)
                    end
                end
                --Optional: notify the driver




                lib.notify({
                    id = 'Rollover',
                    title = 'Rollover',
                    description = 'You just had a rollover, wait in the vehicle for emergency responders',
                    showDuration = true,
                    position = 'top-left',
                    style = {
                        backgroundColor = '#141517',
                        color = '#C1C2C5',
                        ['.description'] = {
                          color = '#909296'
                        }
                    },
                    iconColor = '#C53030',
                    duration = 10000
                })
            end
        end
    end
end)
lib.onCache('vehicle', function(value)
    if triggered and not value and cache.vehicle then
        triggered = false
    end
end)