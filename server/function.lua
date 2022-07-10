
local lastRob = GetResourceKvpInt(("lastRob")) or 0
local robTimer = 60 * 60 * 24 * 2
local trolleyValues = {
    cash = {min = 100000, max = 200000},
    gold = {min = 200000, max = 300000}
}
local hackedZone = {}
local hacksLeft = 2
local mainHackChances = 3
local mainHackFinished = false

function Pac.Init()
    Server.ready = true
    GlobalState.PacifiqueBankRobbery = "Starting"

    Wait(Pac.Utils.readyDelay)

    GlobalState.PacifiqueBankRobbery = "Ready"
end

function Pac:GetData()
    local retval = {}

    for k,v in pairs(self) do
        if type(v) ~= "function" then
            retval[k] = v
        end
    end

    return retval
end

function Pac:DoesDoorExist(door)
    for k,v in pairs(self.Doords) do
        for x,y in pairs(v) do
            if y == door then
                return true
            end
        end
    end

    return false
end

function Pac:UnlockDoor(playerId, door, succes, bitType) 
    if GlobalState.PacifiqueBankRobbery ~= "Started" then
        return
    end

    local drillType = bitType:find("laser") and "laser_drill" or "drill"
    
    if not succes then
        exports.ox_inventory:RemoveItem(playerId, bitType, 1)
        return Utils:ReduceDurability(playerId, drillType, 60 * 60 * 24)
    end

    if not Utils:ReduceDurability(playerId, drillType, 60 * 60 * 6) then
        return
    end

    if succes and self:DoesDoorExist(door) then
        exports.plouffe_doorlock:UpdateDoorState(door, false)
    end
end

function Pac:PlayerUnlockedDoor(playerId, doorIndex, succes)
    if not succes then
        return Utils:ReduceDurability(playerId, "advancedlockpick", 60 * 60 * 24)
    end

    if not Utils:ReduceDurability(playerId, "advancedlockpick", 60 * 60 * 6) then
        return
    end

    if not self:DoesDoorExist(doorIndex) then
        return
    end

    exports.plouffe_doorlock:UpdateDoorState(doorIndex, false)
end

function Pac:AddHackedZone(zone)
    if hackedZone[zone] then
        return false
    end

    hackedZone[zone] = os.time()
    
    if Utils:TableLen(hackedZone) > 1 then
        return true
    end

    local timeout = 1000 * 60 * 30

    CreateThread(function()
        Wait(1000 * 60 * 10)

        local time = os.time()
        local remove = {}

        for k,v in pairs(hackedZone) do
            if time - v > timeout then
                remove[#remove + 1] = k
            end
        end

        if #remove > 0 then
            for k,v in pairs(remove) do
                hackedZone[v] = nil
            end
        end
    end)

    return true
end

function Pac:HackFinished(playerId, zone, succes)
    if GlobalState.PacifiqueBankRobbery ~= "Ready" then
       return Utils:Notify(playerId, "Cette ordinateur est bloquer par le reseaux")
    end 

    if not Utils:ReduceDurability(playerId, "laptop", 60 * 60 * 12) or not Utils:ReduceDurability(playerId, "usb_green", 60 * 60 * 24) then
        return
    end
        
    if not self:AddHackedZone(zone) then
        return Utils:Notify(playerId,"Cette ordinateur est bloquer par le reseaux")
    end
    
    if not succes then
        return
    end

    hacksLeft = hacksLeft - 1

    if hacksLeft > 0 then
        return
    end

    self:StartRobbery(playerId)
end

function Pac:MainHackFinished(playerId, succes)
    if not Utils:ReduceDurability(playerId, "laptop", 60 * 60 * 12) or not Utils:ReduceDurability(playerId, "usb_yellow", 60 * 60 * 24) then
        return
    end

    if not succes then
        mainHackChances = mainHackChances - 1
        return
    end

    mainHackFinished = true

    TriggerClientEvent("plouffe_pacifique:mainHack", playerId)
end

function Pac:StartRobbery(playerId)
    if not self:CanRob() then
        return
    end

    GlobalState.PacifiqueBankRobbery = "Started"
    
    lastRob = os.time()
    SetResourceKvpInt("lastRob", lastRob)
    self:CreateAllTrolley()

    TriggerClientEvent("plouffe_pacifique:start_robbery",playerId)
end

function Pac:CreateAllTrolley()
    for x,y in pairs(self.TrolleySpawns) do
        for k,v in pairs(y) do
            local model = joaat(self.Trolley[v.model].trolley)

            local entity = CreateObject(model, v.coords.x, v.coords.y, v.coords.z, true, true, false)
            local init = os.time()

            while not DoesEntityExist(entity) and os.time() - init < 2 do
                Wait(0)
            end

            if DoesEntityExist(entity) then
                local netId = NetworkGetNetworkIdFromEntity(entity) 
                
                SetEntityRotation(entity, v.rotation.x, v.rotation.y, v.rotation.z, 2, true)

                v.value = math.ceil(math.random(trolleyValues[v.model].min, trolleyValues[v.model].max))
                v.netId = netId
                v.model = model
            end
        end
    end
end

function Pac:DeleteAllTrolley()
    for x,y in pairs(self.TrolleySpawns) do
        for k,v in pairs(y) do
            local entity = NetworkGetEntityFromNetworkId(v.netId)
            DeleteEntity(entity)
            v.netId = nil
        end
    end
end

function Pac:IsAnyLootsLeft()
    for x,y in pairs(self.TrolleySpawns) do
        for k,v in pairs(y) do
            if v.netId then
                return true
            end
        end
    end

    return false
end

function Pac:RequestLoots(playerId,netId)
    if GlobalState.PacifiqueBankRobbery ~= "Started" then
        return
    end

    for x,y in pairs(self.TrolleySpawns) do
        for k,v in pairs(y) do
            if netId == v.netId then
                if v.model ~= "cash" and not mainHackFinished then
                    return
                end

                if exports.ox_inventory:CanCarryItem(playerId, "money_bag", 1, {weight = math.ceil(0.1 * v.value), description = ("Contiens pour %s $ de billets marquer"):format(v.value), value = v.value}) then
                    local entity = NetworkGetEntityFromNetworkId(v.netId)
    
                    DeleteEntity(entity)
                    v.netId = nil
    
                    exports.ox_inventory:AddItem(playerId, "money_bag", 1, {weight = math.ceil(0.1 * v.value), description = ("Contiens pour %s $ de billets marquer"):format(v.value), value = v.value})
                    break
                else
                    TriggerClientEvent("plouffe_lib:notify", playerId, {type = "inform", txt = ("Vous ne pouvez pas porter ce sac d'argent"), length = 5000})
                    break
                end
            end
        end
    end

    if not self:IsAnyLootsLeft() then
        GlobalState.PacifiqueBankRobbery = "Finished"
    end
end

function Pac:CanRob()
    if GlobalState.PacifiqueBankRobbery ~= "Ready" then
        return false
    end

    if os.time() - lastRob < robTimer then
        return false
    end

    local cops = exports.plouffe_society:GetPlayersPerJob("police")

    if not cops or Utils:TableLen(cops) < 6 then
        return false, ("Il n'y a pas asser de policier en service présentement")
    end

    return true
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == "plouffe_pacifique" then
        Pac:DeleteAllTrolley()
    end
end)

Callback:RegisterServerCallback("plouffe_pacifique:canRob", function(source, cb, authkey)
    local _source = source
    if Auth:Validate(_source,authkey) and Auth:Events(_source,"plouffe_pacifique:canRob") then
        cb(Pac:CanRob())
    else
        cb(false)
    end
end)