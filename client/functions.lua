local Utils = exports.plouffe_lib:Get("Utils")
local Callback = exports.plouffe_lib:Get("Callback")

local keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118,
    ["WHEELUP"] = 17, ["WHEELDOWN"] = 16, ["RIGHTMOUSE"] = 222
}

local Animation = {
    ComputerHack = {dict = "missheist_jewel@hacking"},
    Trolley = {dict = "anim@heists@ornate_bank@grab_cash", cash_appear = joaat("CASH_APPEAR"), cash_destroyed = joaat("RELEASE_CASH_DESTROY")},
    Drill = {dict = "anim_heist@hs3f@ig9_vault_drill@laser_drill@", ptfxAsset = "FM_Mission_Controler"}
}

local Scaleform = {
    Instruction = {},
    Drill = {
        speed = 0.0,
        position = 0.0,
        temperature = 0.0,
        stages = {
            {
                min = 0.113,
                max = 0.184
            },

            {
                min = 0.269,
                max = 0.339
            },

            {
                min = 0.424,
                max = 0.494
            },

            {
                min = 0.5808,
                max = 0.651
            },

            {
                min = 0.735,
                max = 0.805
            },

            {
                min = 0.8914,
                max = 0.9613
            },
        },
        keys = {
            {key = keys.W, label = "Percer"},
            {key = keys.S, label = "Reculer"},
            {key = keys.D, label = "Augmenter la vitesse"},
            {key = keys.A, label = "Reduire la vitesse"},
        }
    }
}

local PlayerPedId = PlayerPedId
local GetEntityCoords = GetEntityCoords
local GetPedBoneIndex = GetPedBoneIndex

local RemoveAnimDict = RemoveAnimDict
local DeleteEntity = DeleteEntity
local FreezeEntityPosition = FreezeEntityPosition

local SetEntityNoCollisionEntity = SetEntityNoCollisionEntity
local SetEntityVisible = SetEntityVisible
local AttachEntityToEntity = AttachEntityToEntity
local SetEntityRotation = SetEntityRotation

local PlayEntityAnim = PlayEntityAnim
local NetworkCreateSynchronisedScene = NetworkCreateSynchronisedScene
local NetworkAddPedToSynchronisedScene = NetworkAddPedToSynchronisedScene
local NetworkAddEntityToSynchronisedScene = NetworkAddEntityToSynchronisedScene
local NetworkStartSynchronisedScene = NetworkStartSynchronisedScene

local GetGameTimer = GetGameTimer
local SetEntityCoords = SetEntityCoords
local PlaceObjectOnGroundProperly = PlaceObjectOnGroundProperly
local SetEntityAsNoLongerNeeded = SetEntityAsNoLongerNeeded

local GetEntityRotation = GetEntityRotation
local GetOffsetFromEntityInWorldCoords = GetOffsetFromEntityInWorldCoords

local DisableControlAction = DisableControlAction
local HasAnimEventFired = HasAnimEventFired
local IsEntityVisible = IsEntityVisible

local DoesEntityExist = DoesEntityExist
local GetClosestObjectOfType = GetClosestObjectOfType
local SetEntityCollision = SetEntityCollision

local RequestScriptAudioBank = RequestScriptAudioBank
local StopSound = StopSound
local GetSoundId = GetSoundId
local ReleaseScriptAudioBank = ReleaseScriptAudioBank
local PlaySoundFromEntity = PlaySoundFromEntity
local HasSoundFinished = HasSoundFinished
local PlaySoundFrontend = PlaySoundFrontend

local RequestScaleformMovie = RequestScaleformMovie
local HasScaleformMovieLoaded = HasScaleformMovieLoaded
local CallScaleformMovieMethod = CallScaleformMovieMethod
local CallScaleformMovieMethodWithNumber = CallScaleformMovieMethodWithNumber
local DrawScaleformMovieFullscreen = DrawScaleformMovieFullscreen

local BeginTextCommandScaleformString = BeginTextCommandScaleformString
local AddTextComponentScaleform = AddTextComponentScaleform
local EndTextCommandScaleformString = EndTextCommandScaleformString

local BeginScaleformMovieMethod = BeginScaleformMovieMethod
local SetScaleformMovieAsNoLongerNeeded = SetScaleformMovieAsNoLongerNeeded
local PushScaleformMovieFunction = PushScaleformMovieFunction
local ScaleformMovieMethodAddParamInt = ScaleformMovieMethodAddParamInt
local ScaleformMovieMethodAddParamPlayerNameString = ScaleformMovieMethodAddParamPlayerNameString
local EndScaleformMovieMethod = EndScaleformMovieMethod
local GetControlInstructionalButton = GetControlInstructionalButton

local IsDisabledControlJustPressed = IsDisabledControlJustPressed
local DisableAllControlActions = DisableAllControlActions
local IsDisabledControlPressed = IsDisabledControlPressed

local RemovePtfxAsset = RemovePtfxAsset

local Wait = Wait

function Pac:Start()
    self:ExportAllZones()
    self:RegisterEvents()

    if GlobalState.PacifiqueBankRobbery == "Started" then
        local registered, reason = exports.plouffe_lib:Register({
            name = "pac_main_office_hack",
            coords = vector3(279.66110229492, 212.57180786133, 110.17305755615), 
            distance = 0.5,
            isZone = true,
            label = "Connection",
            params = {fnc = "MainHack", zone = "pac_main_office_hack"},
            keyMap = {
              key = "E", 
              event = "plouffe_pacifique:onZone"
            }
        })
    end
end

function Pac:ExportAllZones()
    for k,v in pairs(self.Zones) do
        local registered, reason = exports.plouffe_lib:Register(v)
    end
end

function Pac:RegisterEvents()
    RegisterNetEvent("plouffe_lib:inVehicle", function(inVehicle, vehicle)
        self.Utils.inVehicle = inVehicle
        self.Utils.vehicle = vehicle
    end)

    RegisterNetEvent("plouffe_pacifique:start_robbery", function()
        self:StartRobbery()
    end)

    RegisterNetEvent("plouffe_pacifique:mainHack", function()
        exports.plouffe_doorlock:OpenAutomated("pacifique_vault")
    end)

    AddEventHandler("plouffe_pacifique:onZone", function(params)
        if self[params.fnc] then
            self[params.fnc](self, params)
        end
    end)

    AddStateBagChangeHandler("PacifiqueBankRobbery" ,"global", self.HandleState)

    AddEventHandler("trolley:TryLoot", self.TryLoot)
    -- AddEventHandler("trolley:destroy", self.DestroyLoot)
end

function Pac.HandleState(bagName,key,value,reserved,replicated)
    if value == "Started" then
        local registered, reason = exports.plouffe_lib:Register({
            name = "pac_main_office_hack",
            coords = vector3(279.66110229492, 212.57180786133, 110.17305755615), 
            distance = 0.5,
            isZone = true,
            label = "Connection",
            params = {fnc = "MainHack", zone = "pac_main_office_hack"},
            keyMap = {
              key = "E", 
              event = "plouffe_pacifique:onZone"
            }
        })
    elseif value == "Finished" then
        exports.plouffe_lib:DestroyZone("pac_main_office_hack")
    end
end

function Pac:GetCloestDoorOfType(doorType)
    for k,v in pairs(self.Doords[doorType]) do
        if exports.plouffe_lib:IsInZone(("%s_1"):format(v)) then
            return v
        end
    end
end

function Pac:MainHack(params)
    if GlobalState.PacifiqueBankRobbery ~= "Started" then
        return
    end

    if Utils:GetItemCount("laptop") < 1 then
        return Utils:Notify("Vous avez besoin d'un laptop")
    elseif Utils:GetItemCount("usb_yellow") < 1 then
        return Utils:Notify("Ils vous manque un connecteur")
    end

    local Hack = Animation.ComputerHack:Start()

    local success = exports.varhack:start(8, 20)

    Hack:Exit()
    
    TriggerServerEvent("plouffe_pacifique:mainHackFinished", success, self.Utils.MyAuthKey)
end

function Pac:TryHack(params)
    if Utils:GetItemCount("laptop") < 1 then
        return Utils:Notify("Vous avez besoin d'un laptop")
    elseif Utils:GetItemCount("usb_green") < 1 then
        return Utils:Notify("Ils vous manque un connecteur")
    end
    
    local canRob, reason = Callback:Sync("plouffe_pacifique:canRob", self.Utils.MyAuthKey)
    
    if not canRob then
        return
    end

    local Hack = Animation.ComputerHack:Start()

    local success = exports.varhack:start(6, 10)

    Hack:Exit()
    
    TriggerServerEvent("plouffe_pacifique:hackFinished", params.zone, success, self.Utils.MyAuthKey)
end

function Pac.TryLoot()
    if GlobalState.PacifiqueBankRobbery ~= "Started" then
        return
    end

    local Trolley = Animation.Trolley:Start()

    if not Trolley then
        return
    end
    
    while not Trolley.looted do
        Wait(0)
    end

    TriggerServerEvent("plouffe_pacifique:requestLoots", NetworkGetNetworkIdFromEntity(Trolley.trolleyEntity), Pac.Utils.MyAuthKey)
    
    local init = GetGameTimer()

    while DoesEntityExist(Trolley.trolleyEntity) and GetGameTimer() - init < 5000 do
        Wait(0)
    end

    Trolley:Exit()
end

function Pac:StartRobbery()
    exports.plouffe_dispatch:SendAlert("10-90 C") 
end

function Pac.TryDrill(data)
    if GlobalState.PacifiqueBankRobbery ~= "Started" then
        return
    end

    local door = Pac:GetCloestDoorOfType("drill")

    if not door then
        return
    end

    local quality = data.name == "laser_drill"
    local bitType = quality and "laser_drill_bit" or "drill_bit"

    if Utils:GetItemCount(bitType) < 1 then
        return Utils:Notify("Vous avez besoin de meches")
    end

    local Drill = Animation.Drill:Start(quality)
    local success = Scaleform.Drill:Start(quality)
    
    TriggerServerEvent("plouffe_pacifique:unlock_door", door, success, bitType, Pac.Utils.MyAuthKey)

    if not success then
        return Drill:Failed()
    end

    Drill:Exit()
end
exports("TryDrill", Pac.TryDrill)

function Pac.TryLockpick(data)
    local door = Pac:GetCloestDoorOfType("lockpick")
    
    if not door then
        return
    end

    if Utils:GetItemCount("advancedlockpick") < 1 then
        return
    end

    local amount = Pac.Utils.lockpickAmount

    Utils:PlayAnim(nil, "mp_arresting", "a_uncuff" , 49, 3.0, 2.0, 5000, true, true, true)
    
    local succes = exports.roundbar:Start(amount, 5000)

    Utils:StopAnim()

    TriggerServerEvent("plouffe_pacifique:lockpickedDoor", door, succes, Pac.Utils.MyAuthKey)
end
exports("TryLockpick", Pac.TryLockpick)

function Pac:GetClosestTrolley(coords)
    local entity = nil

    for k,v in pairs(self.Trolley) do
        entity = GetClosestObjectOfType(coords.x, coords.y, coords.z, 1.5, v.trolley, false, false, false)
        if entity ~= 0 then
            return entity, v, k
        end
    end
end

function Animation.Trolley:Prepare()
    Utils:AssureAnim(self.dict, true)
    
    local trolleyData
    
    self.looted = false

    self.ped = PlayerPedId()
    self.pedCoords = GetEntityCoords(self.ped)
    self.boneIndex = GetPedBoneIndex(self.ped, 60309)

    self.trolleyEntity, trolleyData = Pac:GetClosestTrolley(self.pedCoords)
    
    Utils:AssureEntityControl(self.trolleyEntity)

    if not self.trolleyEntity then
        return false
    end

    self.trolleyRotation = GetEntityRotation(self.trolleyEntity)
    self.trolleyCoords = GetEntityCoords(self.trolleyEntity)

    self.bagEntity =  Utils:CreateProp("hei_p_m_bag_var22_arm_s",  {x = self.pedCoords.x, y = self.pedCoords.y, z = self.pedCoords.z - 5.0}, nil, true, true)
    self.emptyTrolley = Utils:CreateProp(trolleyData.empty,{x = self.pedCoords.x, y = self.pedCoords.y, z = self.pedCoords.z - 8.0}, nil, true, true)
    self.lootEntity = Utils:CreateProp(trolleyData.prop,{x = self.pedCoords.x, y = self.pedCoords.y, z = self.pedCoords.z - 10.0}, nil, true, true)

    SetEntityRotation(self.emptyTrolley, self.trolleyRotation.x, self.trolleyRotation.y, self.trolleyRotation.z)
    FreezeEntityPosition(self.emptyTrolley, true)

    FreezeEntityPosition(self.lootEntity, true)
    
    SetEntityNoCollisionEntity(self.lootEntity, self.ped)
    SetEntityVisible(self.lootEntity, false, false)
    AttachEntityToEntity(self.lootEntity, self.ped, self.boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)

    return true
end

function Animation.Trolley:Start()
    if not self:Prepare() then
        return false
    end

    self.state = "Start"

    local scene = NetworkCreateSynchronisedScene(self.trolleyCoords.x, self.trolleyCoords.y, self.trolleyCoords.z, self.trolleyRotation.x, self.trolleyRotation.y, self.trolleyRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, "bag_intro", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(scene)

    CreateThread(function()
        self:Loop()
    end)

    return self
end

function Animation.Trolley:Loop()
    self.state = "Loop"

    CreateThread(function()
        local scene = NetworkCreateSynchronisedScene(self.trolleyCoords.x, self.trolleyCoords.y, self.trolleyCoords.z, self.trolleyRotation.x, self.trolleyRotation.y, self.trolleyRotation.z, 2, false, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, "bag_grab", 4.0, -8.0, 1)
        NetworkAddEntityToSynchronisedScene(self.trolleyEntity, scene, self.dict, "cart_cash_dissapear", 4.0, -8.0, 1)
        NetworkStartSynchronisedScene(scene)
    end)
    
    self:LootsEvent()

    return self
end

function Animation.Trolley:LootsEvent()
    local init = GetGameTimer()
    local timeout = 37 * 1000

    while GetGameTimer() - init < timeout do
        Wait(0)

        DisableControlAction(0, 73, true)
        if HasAnimEventFired(self.ped, self.cash_appear) then
            if not IsEntityVisible(self.lootEntity) then
                SetEntityVisible(self.lootEntity, true, false)
            end
        end
        if HasAnimEventFired(self.ped, self.cash_destroyed) then
            if IsEntityVisible(self.lootEntity) then
                SetEntityVisible(self.lootEntity, false, false)
            end
        end
    end
    
    self.looted = true
    DeleteEntity(self.lootEntity)
end

function Animation.Trolley:Exit()
    self.state = "Exit"

    if not DoesEntityExist(self.trolleyEntity) then
        SetEntityCoords(self.emptyTrolley, self.trolleyCoords.x, self.trolleyCoords.y, self.trolleyCoords.z)
        PlaceObjectOnGroundProperly(self.emptyTrolley)
        SetEntityAsNoLongerNeeded(self.emptyTrolley)
    else
        DeleteEntity(self.emptyTrolley)
    end

    local scene = NetworkCreateSynchronisedScene(self.trolleyCoords.x, self.trolleyCoords.y, self.trolleyCoords.z, self.trolleyRotation.x, self.trolleyRotation.y, self.trolleyRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, "bag_exit", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(scene)
    
    Wait(1800)
    
    self:Finished()
end

function Animation.Trolley:Finished(restart)
    if restart then
        DeleteEntity(self.emptyTrolley)
    end

    RemoveAnimDict(self.dict)
    DeleteEntity(self.bagEntity)
    DeleteEntity(self.lootEntity)
    DeleteEntity(self.trolleyEntity)
end

function Animation.Drill:Prepare(quality)
    Utils:AssureAnim(self.dict, true)
    Utils:AssureFxAsset(self.ptfxAsset, true)

    self.quality = quality

    if  self.quality then
        RequestScriptAudioBank("DLC_HEIST3\\HEIST_FINALE_LASER_DRILL", false)
    else
        RequestScriptAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", false)
        RequestScriptAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", false)
    end

    self.looted = false

    self.ped = PlayerPedId()
    self.pedCoords = GetEntityCoords(self.ped)
    self.pedRotation = GetEntityRotation(self.ped)
    self.boneIndex = GetPedBoneIndex(self.ped, 28422)

    self.soundId = GetSoundId()

    self.offset = GetOffsetFromEntityInWorldCoords(self.ped, 0.2, 0.55, 0.25)

    self.bagEntity =  Utils:CreateProp("hei_p_m_bag_var22_arm_s",  {x = self.pedCoords.x, y = self.pedCoords.y, z = self.pedCoords.z - 5.0}, nil, true, true)
    self.drillEntity = Utils:CreateProp(self.quality and "ch_prop_laserdrill_01a" or "hei_prop_heist_drill", {x = self.pedCoords.x, y = self.pedCoords.y, z = self.pedCoords.z - 8.0}, nil, true, true)

    FreezeEntityPosition(self.bagEntity, true)
    FreezeEntityPosition(self.drillEntity, true)
    FreezeEntityPosition(self.holeEntity, true)

    SetEntityCollision(self.drillEntity, false, true)
    SetEntityVisible(self.drillEntity, false)

    AttachEntityToEntity(self.drillEntity, self.ped, self.boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)

    return true
end

function Animation.Drill:Start(quality)
    if not self:Prepare(quality) then
        return false
    end

    self.state = "Start"

    local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, "bag_intro", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(scene)

    Wait(2500)
    SetEntityVisible(self.drillEntity, true)
    Wait(2200)

    if self.quality then
        PlaySoundFromEntity(self.soundId, "laser_power_up", self.drillEntity, "dlc_ch_heist_finale_laser_drill_sounds", true, 20)
    end

    self:Loop()

    return self
end

function Animation.Drill:Loop()
    self.state = "Loop"

    local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, "drill_straight_idle", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, "bag_drill_straight_idle", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(scene)

    PlayEntityAnim(self.drillEntity, "drill_straight_idle_drill_bit", self.dict, 1000.0, true, false, false, 0.0, 262144)
    
    if HasSoundFinished(self.soundId) then
        PlaySoundFromEntity(
            self.soundId, 
            self.quality and "laser_drill" or "Drill", 
            self.drillEntity, 
            self.quality and "HEIST_FINALE_LASER_DRILL" or "DLC_HEIST_FLEECA_SOUNDSET", 
            true, 
            20
        )
    end

    CreateThread(function()
        local i = 0

        while self.state == "Loop" and i <= 250 do
            Wait(0)
            i = i + 1
        end

        if i >= 250 then
            self:Loop(quality)
        end
    end)
end

function Animation.Drill:Failed()
    self.state = "Failed"

    PlaySoundFrontend(self.soundId, self.quality and "laser_pin_break" or "Drill_Pin_Break", self.quality and "dlc_ch_heist_finale_laser_drill_sounds" or "DLC_HEIST_FLEECA_SOUNDSET", true)

    local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, "drill_straight_fail", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, "bag_drill_straight_fail", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(scene)

    Wait(1600)

    self:Exit()
end

function Animation.Drill:Exit()
    self.state = "Exit"

    local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, "bag_exit", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(scene)

    Wait(2400)
    SetEntityVisible(self.drillEntity, false)
    
    self:Finished()
end

function Animation.Drill:Finished()
    self.state = "Finished"

    RemoveAnimDict(self.dict)
    DeleteEntity(self.bagEntity)
    DeleteEntity(self.drillEntity)
    StopSound(self.soundId)
    ReleaseScriptAudioBank()
    RemovePtfxAsset(self.ptfxAsset)
end

function Scaleform.Drill:Prepare(quality)
    self.type = quality and "VAULT_LASER" or "VAULT_DRILL"
    self.stage = 1
    self.active = false
    self.promise = promise.new()

    self.durability = 1000

    self.speed = 0.5
    self.position = 0.0
    self.temperature = 0.0
end

function Scaleform.Drill:Start(quality)
    self:Prepare(quality)

    self:Process()

    return Citizen.Await(self.promise)
end

function Scaleform.Drill:ManageStage()
    if self.stages[self.stage] and self.position >= self.stages[self.stage].min and self.position <= self.stages[self.stage].max then
        if self.percing then
            self.temperature =self.temperature + (self.speed / 1000)
        else
            self.temperature = self.temperature - (self.speed / 10000)
        end

        if self.percing and self.temperature >= 0.5 then
            self.durability = self.durability - 0.3 * (self.temperature * 10)

            if self.durability <= 0 then
                self:Finished(false)
            end
        end
    elseif self.stages[self.stage] and self.position > self.stages[self.stage].max then
        self.stage = self.stage + 1
    elseif self.position == 1.0 then
        self:Finished(true)
    else 
        self.temperature = self.temperature - 0.0001
    end
end

function Scaleform.Drill:Process()
    self.scaleform = RequestScaleformMovie(self.type)

    while not HasScaleformMovieLoaded(self.scaleform) do
        Wait(0)
    end
    
    -- Scaleform.Instruction:Show(self.keys)
    BeginScaleformMovieMethod(self.scaleform, "REVEAL")
    CallScaleformMovieMethod(self.scaleform, "REVEAL")
    CallScaleformMovieMethodWithNumber(self.scaleform, "SET_NUM_DISCS", 6.0, -1.0, -1.0, -1.0, -1.0)
    CallScaleformMovieMethodWithNumber(self.scaleform, "SET_HOLE_DEPTH", 0.0, -1.0, -1.0, -1.0, -1.0)
    CallScaleformMovieMethodWithNumber(self.scaleform, "SET_POSITION", 1.0, 0.725, -1.0, -1.0, -1.0)
    EndScaleformMovieMethod()

    CreateThread(function()
        self.active = true

        while self.active do
            local isDisabled = false
            self:ManageStage()
            
            self.percing = false

            DrawScaleformMovieFullscreen(self.scaleform, 255, 255, 255, 255, 0)

            DisableAllControlActions(0)
            DisableAllControlActions(1)
            DisableAllControlActions(2)
            DisableAllControlActions(4)

            if IsDisabledControlPressed(0, keys.SPACE) then
                CallScaleformMovieMethod(self.scaleform, "REVEAL")
                CallScaleformMovieMethodWithNumber(self.scaleform, "SET_TEMPERATURE", self.temperature, -1.0, -1.0, -1.0, -1.0)
                EndScaleformMovieMethod()
            end

            if IsDisabledControlPressed(0, keys.A) then
                self.speed = self.speed - 0.01 >= 0.0 and self.speed - 0.01 or 0.0
                CallScaleformMovieMethod(self.scaleform, "REVEAL")
                CallScaleformMovieMethodWithNumber(self.scaleform, "SET_SPEED", self.speed * 0.79, -1.0, -1.0, -1.0, -1.0)
                EndScaleformMovieMethod()
            end
        
            if IsDisabledControlPressed(0, keys.D) then
                self.speed = self.speed + 0.01 <= 5.0 and self.speed + 0.01 or 5.0
                CallScaleformMovieMethod(self.scaleform, "REVEAL")
                CallScaleformMovieMethodWithNumber(self.scaleform, "SET_SPEED", self.speed * 0.79, -1.0, -1.0, -1.0, -1.0)
                EndScaleformMovieMethod()
            end
            
            if IsDisabledControlPressed(0, keys.A) then
                self.speed = self.speed - 0.01 >= 0.0 and self.speed - 0.01 or 0.0
                CallScaleformMovieMethod(self.scaleform, "REVEAL")
                CallScaleformMovieMethodWithNumber(self.scaleform, "SET_SPEED", self.speed * 0.79, -1.0, -1.0, -1.0, -1.0)
                EndScaleformMovieMethod()
            end
            
            if IsDisabledControlPressed(0, keys.W) then
                self.percing = true
                self.position = self.position + (self.speed / 10000) < 1.0 and self.position + (self.speed / 10000) or 1.0
                CallScaleformMovieMethod(self.scaleform, "REVEAL")
                CallScaleformMovieMethodWithNumber(self.scaleform, "SET_DRILL_POSITION", self.position, -1.0, -1.0, -1.0, -1.0)
                CallScaleformMovieMethodWithNumber(self.scaleform, "SET_TEMPERATURE", self.temperature, -1.0, -1.0, -1.0, -1.0)
                EndScaleformMovieMethod()
            end
            
            if IsDisabledControlPressed(0, keys.S) then
                self.position = self.position - (self.speed / 10000) > 0.0 and self.position - (self.speed / 10000) or 0.0
                CallScaleformMovieMethod(self.scaleform, "REVEAL")
                CallScaleformMovieMethodWithNumber(self.scaleform, "SET_DRILL_POSITION", self.position, -1.0, -1.0, -1.0, -1.0)
                EndScaleformMovieMethod()
            end

            if IsDisabledControlJustPressed(0, keys.ESC) then
                self:Finished(false)
            end
            
            Wait(0)
        end
    end)
    

end

function Scaleform.Drill:Finished(state)
    local succes = state and true or false

    self.active = false
    self.promise:resolve(succes)
    CallScaleformMovieMethod(self.scaleform, "REVEAL")
    CallScaleformMovieMethodWithNumber(self.scaleform, "SET_DRILL_POSITION", 0.0, -1.0, -1.0, -1.0, -1.0)
    CallScaleformMovieMethodWithNumber(self.scaleform, "SET_TEMPERATURE", 0.0, -1.0, -1.0, -1.0, -1.0)
    CallScaleformMovieMethodWithNumber(self.scaleform, "SET_SPEED", 0.0* 0.79, -1.0, -1.0, -1.0, -1.0)
    EndScaleformMovieMethod()
    SetScaleformMovieAsNoLongerNeeded(self.scaleform)
end

function Scaleform.Instruction:Label(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function Scaleform.Instruction:Show(data)
    self.scaleform = RequestScaleformMovie("instructional_buttons")
    
    while not HasScaleformMovieLoaded(self.scaleform) do
        Wait(0)
    end
    
    for k,v in ipairs(data) do
        PushScaleformMovieFunction(self.scaleform, "SET_DATA_SLOT")
        ScaleformMovieMethodAddParamInt(k + 20)
        ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, v.key, true))
        self:Label(v.label)
        EndScaleformMovieMethod()
    end
    
    DrawScaleformMovieFullscreen(self.scaleform, 255, 255, 255, 255, 0)
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == "plouffe_pacifique" then
        Animation.Trolley:Finished(true)
        Animation.Drill:Finished()
    end
end)