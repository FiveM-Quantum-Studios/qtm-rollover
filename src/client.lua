local triggered = false

local function detectRollover(vehicle)
    return IsEntityUpsidedown(vehicle)
end

local function applyCrashDamage(ped, vehicle)
    local speed = GetEntitySpeed(vehicle) * Config.Unit
    local threshold = 50
    local intensity = math.min(1.0, (speed - threshold) / 100) -- Cap the intensity to a maximum of 1.0
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', intensity)
end

local function notifyRollover()
    lib.notify({
        id = 'Rollover',
        title = Config.Language.notifyTitle,
        description = Config.Language.notifyDesc,
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

local function handleRollover(vehicle)
    triggered = true
    SetVehicleEngineHealth(vehicle, 0)
    local occupants = GetVehicleNumberOfPassengers(vehicle)
    for i = -1, occupants - 1 do
        local occupantPed = GetPedInVehicleSeat(vehicle, i)
        if occupantPed and occupantPed ~= 0 then
            applyCrashDamage(occupantPed, vehicle)
        end
    end
    notifyRollover()
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) 
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) and not triggered then
            local vehicle = GetVehiclePedIsIn(ped, false)
            if detectRollover(vehicle) then
                handleRollover(vehicle)
            end
        end
    end
end)

lib.onCache('vehicle', function(value)
    if triggered and not value and cache.vehicle then
        triggered = false
    end
end)
