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
    qtm.Dispatch.CreateDispatch({
        sprite = 431 ,      
        title = "Rollover",     
        text = 'A person has rolled over their vehicle!',       
        blipText = "Rollover",      
        scale = 1.2,        
        colour = 3,     
        flashes = false,        
        time = 5,       
        radius = 0,     
    })
end
local function notifyRollover()
    if Config.Dispatch then
        handleDispatch()
    end
    qtm.Notification(nil, Config.Language.notifyTitle, 'error', Config.Language.notifyDesc)
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
