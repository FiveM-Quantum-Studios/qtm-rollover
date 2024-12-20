local triggered = false
local isInVehicle = false
local vehicleClassTable = {
    8, 13, 14, 15, 16, 21
}

local function applyCrashDamage(ped, vehicle)
    local speed = GetEntitySpeed(vehicle) * Config.Unit
    local threshold = 50
    local intensity = math.min(1.0, (speed - threshold) / 100)
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', intensity)
end

local function handleDispatch()
    qtm.Dispatch.CreateDispatch({
        sprite = 431,
        title = Config.Language.DispatchTitle,
        text = Config.Language.DispatchDesc,
        blipText = Config.Language.BlipText,
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
    qtm.Notification(nil, Config.Language.NotifyTitle, 'error', Config.Language.NotifyDesc)
end

local function handleRollover(vehicle)
    triggered = true
    SetVehicleEngineHealth(vehicle, -4001)
    SetVehicleEngineOn(vehicle, false, true, true)
    local occupants = GetVehicleNumberOfPassengers(vehicle)
    for i = -1, occupants - 1 do
        local occupantPed = GetPedInVehicleSeat(vehicle, i)
        if occupantPed and occupantPed ~= 0 then
            applyCrashDamage(occupantPed, vehicle)
        end
    end
    notifyRollover()

    -- Prevent the player from flipping the vehicle back over
    CreateThread(function()
        while triggered do
            DisableControlAction(0, 59, true)  -- Disable lean left/right
            DisableControlAction(0, 60, true)  -- Disable lean up/down
            DisableControlAction(0, 61, true)  -- Disable lean back/front
            DisableControlAction(0, 62, true)  -- Disable handbrake
            DisableControlAction(0, 63, true)  -- Disable steering left
            DisableControlAction(0, 64, true)  -- Disable steering right
            Wait(0)
        end
    end)
end

CreateThread(function()
    while true do
        Wait(1000)
        if isInVehicle and not triggered then
            local vehicle = cache.vehicle
            if IsEntityUpsidedown(vehicle) then
                handleRollover(vehicle)
            end
        end
    end
end)

lib.onCache('vehicle', function(value)
    if Config.Debug then
        print('vehicle', value, "triggered", triggered, "cache.vehicle", cache.vehicle)
    end
    if triggered and not value and cache.vehicle then
        triggered = false
    end

    if value and not cache.vehicle and not lib.table.contains(vehicleClassTable, GetVehicleClass(value)) then
        isInVehicle = true
    end
end)
