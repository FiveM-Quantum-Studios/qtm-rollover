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
local function handleDispatch()
    --Handle the dispatch here | Example below:
    local data = exports['cd_dispatch']:GetPlayerInfo()
    TriggerServerEvent('cd_dispatch:AddNotification', {
        job_table = {'police', 'ambulance' }, 
        coords = data.coords,
        title = '10-25 Vehicle Rolled over',
        message = 'A '..data.sex..' has rolled over their vehicle at '..data.street, 
        flash = 0,
        unique_id = data.unique_id,
        sound = 1,
        blip = {
            sprite = 431, 
            scale = 1.2, 
            colour = 3,
            flashes = false, 
            text = '911 - Vehicle Roll Over',
            time = 5,
            radius = 0,
        }
    })
end
local function notifyRollover()
    if Config.Dispatch then
        handleDispatch()
    end
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
                if Config.PreventFromUnflip then
                    handleRollover(vehicle)
                    local roll = GetEntityRoll(vehicle)
                    if (roll > 75.0 or roll < -75.0) and GetEntitySpeed(vehicle) < 2 then
                        DisableControlAction(2,59,true)
                        DisableControlAction(2,60,true)
                    end
                end
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
