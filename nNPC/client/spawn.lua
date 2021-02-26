--------||Script made by Super.Cool.Ninja||--------
local isAnimEnabled = false --Change this to true if you want add anims.

local function findPedModel(hash)
    if type(hash) == "string" then hash = GetHashKey(hash) end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end
end

local function findAnimsDictPed(anim_dict)
    RequestAnimDict(anim_dict)
    while not HasAnimDictLoaded(anim_dict) do
        Wait(1000)
    end
end

local function ClearPedsModel()
    for i=1, #Config.Locations do
        local myPeds = Config.Locations[i]["myPedsLocation"]
        if DoesEntityExist(myPeds["entity"]) then
            DeletePed(myPeds["entity"])
            SetPedAsNoLongerNeeded(myPeds["entity"])
        end
    end
end

Citizen.CreateThread(function()
    for i=1, #Config.Locations do
        local myPeds = Config.Locations[i]["myPedsLocation"]
        if myPeds then
            myPeds["hash"] = myPeds["hash"]
            myPeds["anim_dict"] = myPeds["anim_dict"]
            myPeds["anim_action"] = myPeds["anim_action"]
            findPedModel(myPeds["hash"])
            findAnimsDictPed(myPeds["anim_dict"])
            if not DoesEntityExist(myPeds["entity"]) then
               --||Maybe with this new function the peds are not duplicated anymore?!||--
                myPeds["entity"] = CreatePed(4, myPeds["hash"], myPeds["x"], myPeds["y"], myPeds["z"] -1, myPeds["h"], 0, 0)
                if isAnimEnabled then -- This condition work for all peds
                    TaskPlayAnim(myPeds["entity"],myPeds["anim_dict"], myPeds["anim_action"],1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
                end
                SetEntityAsMissionEntity(myPeds["entity"])
                SetBlockingOfNonTemporaryEvents(myPeds["entity"], true)
                FreezeEntityPosition(myPeds["entity"], true)
                SetEntityInvincible(myPeds["entity"], true) 
            end
            SetModelAsNoLongerNeeded(myPeds["hash"])
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        ClearPedsModel()
    end
end)