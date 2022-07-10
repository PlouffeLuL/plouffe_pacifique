CreateThread(Pac.Init)

RegisterNetEvent("plouffe_pacifique:sendConfig",function()
    local playerId = source
    local registred, key = Auth:Register(playerId)

    while not Server.ready do
        Wait(100)
    end

    if registred then
        local cbArray = Pac:GetData()
        cbArray.Utils.MyAuthKey = key
        TriggerClientEvent("plouffe_pacifique:getConfig", playerId, cbArray)
    else
        TriggerClientEvent("plouffe_pacifique:getConfig", playerId, nil)
    end
end)

RegisterNetEvent("plouffe_pacifique:removeItem", function(item, amount, authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) and Auth:Events(playerId,"plouffe_pacifique:removeItem") then
        exports.ox_inventory:RemoveItem(playerId, item, amount)
    end
end)

RegisterNetEvent("plouffe_pacifique:unlock_door", function(door, succes, bitType, authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) and Auth:Events(playerId,"plouffe_pacifique:unlock_door") then
        Pac:UnlockDoor(playerId, door, succes, bitType)
    end
end)

RegisterNetEvent("plouffe_pacifique:lockpickedDoor", function(door, succes, authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) and Auth:Events(playerId,"plouffe_pacifique:lockpickedDoor") then
        Pac:PlayerUnlockedDoor(playerId, door, succes)
    end
end)

RegisterNetEvent("plouffe_pacifique:hackFinished", function(zone, succes, authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) and Auth:Events(playerId,"plouffe_pacifique:hackFinished") then
        Pac:HackFinished(playerId, zone, succes)
    end
end)

RegisterNetEvent("plouffe_pacifique:requestLoots", function(netId, authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) and Auth:Events(playerId,"plouffe_pacifique:requestLoots") then
        Pac:RequestLoots(playerId, netId)
    end
end)

RegisterNetEvent("plouffe_pacifique:mainHackFinished", function(succes, authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) and Auth:Events(playerId,"plouffe_pacifique:mainHackFinished") then
        Pac:MainHackFinished(playerId, succes)
    end
end)