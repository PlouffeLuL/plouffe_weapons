local Utils <const> = exports.plouffe_lib:Get("Utils")
local Callback <const> = exports.plouffe_lib:Get("Callback")
local Interface <const> = exports.plouffe_lib:Get("Interface")
local Lang <const> = exports.plouffe_lib:Get("Lang")

local PlayerPedId = PlayerPedId
local AttachEntityToEntity = AttachEntityToEntity
local GetPedBoneIndex = GetPedBoneIndex

local DeleteEntity = DeleteEntity
local GetEntityBoneIndexByName = GetEntityBoneIndexByName
local SetEntityCollision = SetEntityCollision

local GetPlayerServerId = GetPlayerServerId
local PlayerId = PlayerId

local GetCurrentPedWeapon = GetCurrentPedWeapon

local IsPedShooting = IsPedShooting
local IsPlayerFreeAiming = IsPlayerFreeAiming
local GetGameTimer = GetGameTimer
local DisablePlayerFiring = DisablePlayerFiring
local DisableControlAction = DisableControlAction
local SendNUIMessage = SendNUIMessage
local SetFollowVehicleCamViewMode = SetFollowVehicleCamViewMode

local IsPedBeingStunned = IsPedBeingStunned
local SetPedToRagdoll = SetPedToRagdoll
local IsEntityInWater = IsEntityInWater

local SetTimecycleModifierStrength = SetTimecycleModifierStrength
local SetTimecycleModifier = SetTimecycleModifier
local ShakeGameplayCam = ShakeGameplayCam

local StopGameplayCamShaking = StopGameplayCamShaking
local ClearTimecycleModifier = ClearTimecycleModifier

local Wait = Wait

local pickupList = {
    `PICKUP_AMMO_BULLET_MP`,
    `PICKUP_AMMO_FIREWORK`,
    `PICKUP_AMMO_FLAREGUN`,
    `PICKUP_AMMO_GRENADELAUNCHER`,
    `PICKUP_AMMO_GRENADELAUNCHER_MP`,
    `PICKUP_AMMO_HOMINGLAUNCHER`,
    `PICKUP_AMMO_MG`,
    `PICKUP_AMMO_MINIGUN`,
    `PICKUP_AMMO_MISSILE_MP`,
    `PICKUP_AMMO_PISTOL`,
    `PICKUP_AMMO_RIFLE`,
    `PICKUP_AMMO_RPG`,
    `PICKUP_AMMO_SHOTGUN`,
    `PICKUP_AMMO_SMG`,
    `PICKUP_AMMO_SNIPER`,
    `PICKUP_ARMOUR_STANDARD`,
    `PICKUP_CAMERA`,
    `PICKUP_CUSTOM_SCRIPT`,
    `PICKUP_GANG_ATTACK_MONEY`,
    `PICKUP_HEALTH_SNACK`,
    `PICKUP_HEALTH_STANDARD`,
    `PICKUP_MONEY_CASE`,
    `PICKUP_MONEY_DEP_BAG`,
    `PICKUP_MONEY_MED_BAG`,
    `PICKUP_MONEY_PAPER_BAG`,
    `PICKUP_MONEY_PURSE`,
    `PICKUP_MONEY_SECURITY_CASE`,
    `PICKUP_MONEY_VARIABLE`,
    `PICKUP_MONEY_WALLET`,
    `PICKUP_PARACHUTE`,
    `PICKUP_PORTABLE_CRATE_FIXED_INCAR`,
    `PICKUP_PORTABLE_CRATE_UNFIXED`,
    `PICKUP_PORTABLE_CRATE_UNFIXED_INCAR`,
    `PICKUP_PORTABLE_CRATE_UNFIXED_INCAR_SMALL`,
    `PICKUP_PORTABLE_CRATE_UNFIXED_LOW_GLOW`,
    `PICKUP_PORTABLE_DLC_VEHICLE_PACKAGE`,
    `PICKUP_PORTABLE_PACKAGE`,
    `PICKUP_SUBMARINE`,
    `PICKUP_VEHICLE_ARMOUR_STANDARD`,
    `PICKUP_VEHICLE_CUSTOM_SCRIPT`,
    `PICKUP_VEHICLE_CUSTOM_SCRIPT_LOW_GLOW`,
    `PICKUP_VEHICLE_HEALTH_STANDARD`,
    `PICKUP_VEHICLE_HEALTH_STANDARD_LOW_GLOW`,
    `PICKUP_VEHICLE_MONEY_VARIABLE`,
    `PICKUP_VEHICLE_WEAPON_APPISTOL`,
    `PICKUP_VEHICLE_WEAPON_ASSAULTSMG`,
    `PICKUP_VEHICLE_WEAPON_COMBATPISTOL`,
    `PICKUP_VEHICLE_WEAPON_GRENADE`,
    `PICKUP_VEHICLE_WEAPON_MICROSMG`,
    `PICKUP_VEHICLE_WEAPON_MOLOTOV`,
    `PICKUP_VEHICLE_WEAPON_PISTOL`,
    `PICKUP_VEHICLE_WEAPON_PISTOL50`,
    `PICKUP_VEHICLE_WEAPON_SAWNOFF`,
    `PICKUP_VEHICLE_WEAPON_SMG`,
    `PICKUP_VEHICLE_WEAPON_SMOKEGRENADE`,
    `PICKUP_VEHICLE_WEAPON_STICKYBOMB`,
    `PICKUP_WEAPON_ADVANCEDRIFLE`,
    `PICKUP_WEAPON_APPISTOL`,
    `PICKUP_WEAPON_ASSAULTRIFLE`,
    `PICKUP_WEAPON_ASSAULTSHOTGUN`,
    `PICKUP_WEAPON_ASSAULTSMG`,
    `PICKUP_WEAPON_AUTOSHOTGUN`,
    `PICKUP_WEAPON_BAT`,
    `PICKUP_WEAPON_BATTLEAXE`,
    `PICKUP_WEAPON_BOTTLE`,
    `PICKUP_WEAPON_BULLPUPRIFLE`,
    `PICKUP_WEAPON_BULLPUPSHOTGUN`,
    `PICKUP_WEAPON_CARBINERIFLE`,
    `PICKUP_WEAPON_COMBATMG`,
    `PICKUP_WEAPON_COMBATPDW`,
    `PICKUP_WEAPON_COMBATPISTOL`,
    `PICKUP_WEAPON_COMPACTLAUNCHER`,
    `PICKUP_WEAPON_COMPACTRIFLE`,
    `PICKUP_WEAPON_CROWBAR`,
    `PICKUP_WEAPON_DAGGER`,
    `PICKUP_WEAPON_DBSHOTGUN`,
    `PICKUP_WEAPON_FIREWORK`,
    `PICKUP_WEAPON_FLAREGUN`,
    `PICKUP_WEAPON_FLASHLIGHT`,
    `PICKUP_WEAPON_GRENADE`,
    `PICKUP_WEAPON_GRENADELAUNCHER`,
    `PICKUP_WEAPON_GUSENBERG`,
    `PICKUP_WEAPON_GOLFCLUB`,
    `PICKUP_WEAPON_HAMMER`,
    `PICKUP_WEAPON_HATCHET`,
    `PICKUP_WEAPON_HEAVYPISTOL`,
    `PICKUP_WEAPON_HEAVYSHOTGUN`,
    `PICKUP_WEAPON_HEAVYSNIPER`,
    `PICKUP_WEAPON_HOMINGLAUNCHER`,
    `PICKUP_WEAPON_KNIFE`,
    `PICKUP_WEAPON_KNUCKLE`,
    `PICKUP_WEAPON_MACHETE`,
    `PICKUP_WEAPON_MACHINEPISTOL`,
    `PICKUP_WEAPON_MARKSMANPISTOL`,
    `PICKUP_WEAPON_MARKSMANRIFLE`,
    `PICKUP_WEAPON_MG`,
    `PICKUP_WEAPON_MICROSMG`,
    `PICKUP_WEAPON_MINIGUN`,
    `PICKUP_WEAPON_MINISMG`,
    `PICKUP_WEAPON_MOLOTOV`,
    `PICKUP_WEAPON_MUSKET`,
    `PICKUP_WEAPON_NIGHTSTICK`,
    `PICKUP_WEAPON_PETROLCAN`,
    `PICKUP_WEAPON_PIPEBOMB`,
    `PICKUP_WEAPON_PISTOL`,
    `PICKUP_WEAPON_PISTOL50`,
    `PICKUP_WEAPON_POOLCUE`,
    `PICKUP_WEAPON_PROXMINE`,
    `PICKUP_WEAPON_PUMPSHOTGUN`,
    `PICKUP_WEAPON_RAILGUN`,
    `PICKUP_WEAPON_REVOLVER`,
    `PICKUP_WEAPON_RPG`,
    `PICKUP_WEAPON_SAWNOFFSHOTGUN`,
    `PICKUP_WEAPON_SMG`,
    `PICKUP_WEAPON_SMOKEGRENADE`,
    `PICKUP_WEAPON_SNIPERRIFLE`,
    `PICKUP_WEAPON_SNSPISTOL`,
    `PICKUP_WEAPON_SPECIALCARBINE`,
    `PICKUP_WEAPON_STICKYBOMB`,
    `PICKUP_WEAPON_STUNGUN`,
    `PICKUP_WEAPON_SWITCHBLADE`,
    `PICKUP_WEAPON_VINTAGEPISTOL`,
    `PICKUP_WEAPON_WRENCH`,
    `PICKUP_WEAPON_RAYCARBINE`
}

local gsrThread = false
local warnActive = false

local Weap = {tazerAmmo = 1, tazerModel = `weapon_stungun`}

Weap.TazerEffect = setmetatable({
    effectStrength = 0.0,
    shakeStrength = 0.0,
    timeEffect = 1000,
    active = false,
    threadActive = false,
}, {
    __call = function(self)
        if self.active then
            return
        end

        self.active = true

        self.effectStrength += 0.2
        self.shakeStrength += 0.2
        self.timeEffect += 1000

        if self.effectStrength > 0.8 then
            self.effectStrength = 0.8
        end

        if self.shakeStrength > 1.0 then
            self.shakeStrength = 1.0
        end

        if self.timeEffect > 6000 then
            self.timeEffect = 6000
        end

        SetTimecycleModifierStrength(self.effectStrength)
        SetTimecycleModifier("BarryFadeOut")

        repeat
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE',0.2)
            Wait(100)
            SetPedToRagdoll(Weap.cache.ped, self.timeEffect, self.timeEffect, 0, true, true, true)
        until IsPedBeingStunned(Weap.cache.ped,0) ~= true

        SetPedToRagdoll(Weap.cache.ped, self.timeEffect, self.timeEffect, 0, true, true, true)

        ShakeGameplayCam("FAMILY5_Weapons_TRIP_SHAKE", self.shakeStrength)

        self.active = false

        if self.threadActive then
            return
        end

        self.threadActive = true

        CreateThread(function()
            while self.shakeStrength > 0.0 or self.effectStrength > 0.0 do
                Wait(1000 * 15)

                if self.effectStrength > 0.0 then
                    self.effectStrength -= 0.1
                end

                if self.shakeStrength > 0.0 then
                    self.shakeStrength -= 0.1
                end

                SetTimecycleModifier("BarryFadeOut")
                SetTimecycleModifierStrength(self.effectStrength)
            end

            StopGameplayCamShaking()
            ClearTimecycleModifier()

            self.threadActive = false
        end)
    end
})

Weap.weaponsOnBack = {
    equiped = nil,
    current = {
        [1] = {offset = 0.12},
        [2] = {offset = 0.06},
        [3] = {offset = 0.00},
        [4] = {offset = -0.06},
        [5] = {offset = -0.12}
    },
    exists = {},
    weapons = {
        WEAPON_MK47FM = {
            model = "MK47FluffysMods",
        },

        WEAPON_G36 = {
            model = "markomods-g36",
            components = {
                COMPONENT_MARKOMODSG36_STOCK_01 = {
                    bone = "AAPStock",
                    model = "markomods-g36-stock1"
                },

                COMPONENT_MARKOMODSG36_BARREL_01 = {
                    bone = "AAPSupp",
                    model = "markomods-g36-barrel1"
                }
            }
        },

        WEAPON_AKM = {
            model = "akm",
            components = {
                COMPONENT_AKM_HANDGUARD_01 = {
                    bone = 'WAPGrip',
                    model = 'akmhandguard1'
                },
                COMPONENT_AKM_PISTOLGRIP_01 = {
                    bone = 'WAPGrip_2',
                    model = 'akmpistolgrip1'
                },
                COMPONENT_AKM_STOCK_01 = {
                    bone = 'WAPSock',
                    model = 'akmstock1'
                },
                COMPONENT_AKM_DUSTCOVER_01 = {
                    bone = 'WAPFlshLasr',
                    model = 'akmdustcover1'
                }
            }
        },

        WEAPON_MDR = {
            model = "w_ar_MDR"
        },

        WEAPON_GRENADELAUNCHER_SMOKE = {
            model = "w_lr_grenadelauncher"
        },

        WEAPON_LTL = {
            model = "w_sg_ltl"
        },

        WEAPON_SR25 = {
            model = "sr25"
        },

        WEAPON_50BEOWULF = {
            model = "ar15_beowulf",
            components = {
                COMPONENT_BEOWULF_BODY_01 = {
                    bone = 'WAPGun',
                    model = 'ar15body1'
                }
            }
        },

        WEAPON_SCARSC = {
            model = "scarsc"
        },

        WEAPON_PMXFM = {
            model = "pmx_fluffymods"
        },

        WEAPON_SCAR17FM = {
            model = "ScarFluffysMods",
            components = {
                COMPONENT_SCAR_BODY_01 = {
                    bone = 'WAPGun',
                    model = 'MainBody1'
                },
                COMPONENT_SCAR_BARREL_01 = {
                    bone = 'WAPSupp',
                    model = 'scar_barrel3'
                }
            }
        },

        WEAPON_M4A1FM = {
            model = "M4A1_FluffysMods",
            components = {
                COMPONENT_M4A1FM_BARREL_01 = {
                    bone = 'WAPSupp',
                    model = 'M4A1Barrel1_FluffysMods'
                }
            }
        },

        WEAPON_MPX = {
            model = "w_sb_mpx"
        },

        WEAPON_P90FM = {
            model = "P90FluffysMods",
            components = {
                COMPONENT_P90_BARREL_01 = {
                    bone = 'WAPSupp',
                    model = 'P90Barrel1FluffysMods'
                }
            }
        },

        WEAPON_DRACO = {
            model = "w_ar_draco"
        },

        WEAPON_SCORPIONEVO = {
            model = "w_sb_scorpionevo"
        },

        WEAPON_ASVAL = {
            model = "asval",
            components = {
                COMPONENT_ASVAL_STOCK_01 = {
                    bone = 'WAPGrip_2',
                    model = 'asval_stock_01'
                },
            },
        },

        WEAPON_AKS74U = {
            model = "aks74u",
            components = {
                COMPONENT_AKS74U_HANDGUARD_01 = {
                    bone = 'WAPBarrel',
                    model = 'aks74u_handguard_01'
                },
                COMPONENT_AKS74U_STOCK_01 = {
                    bone = 'WAPScop_2',
                    model = 'aks74u_stock_01'
                },
            },
        },

        WEAPON_MCXSPEAR = {
            model = "mcxspear",
            components = {
                COMPONENT_MCXSPEAR_BODY_01 = {
                    bone = 'WAPGrip_2',
                    model = 'mcxspear_body_01'
                },
                COMPONENT_MCXSPEAR_STOCK_01 = {
                    bone = 'WAPScop_2',
                    model = 'mcxspear_stock_01'
                }
            }
        },

        WEAPON_MP9A = {
            model = "w_sb_MP9a"
        }
    }
}

local function wake()
    local list = Callback:Sync("plouffe_weapons:loadPlayer")
    for k,v in pairs(list) do
        Weap[k] = v
    end
end

function Weap.Start()
    Weap:FindFramework()

    if Weap.inventoryFramework == 'ox_inventory' then
        Weap.GetWeapons = function()
            local items = {}
            local data = {}

            for k,v in pairs(Weap.weaponsOnBack.weapons) do
                table.insert(items, k)
            end

            local weapons = exports.ox_inventory:Search("slots", items)

            for k,v in pairs(weapons) do
                if #v > 0 then
                    for i=1, #v do
                        data[i] = v[i]
                    end
                end
            end

            return data
        end

        AddEventHandler('ox_inventory:currentWeapon',function(data)
            if Weap.weaponsOnBack.equiped then
                Weap:AddWeaponOnBack(Weap.weaponsOnBack.equiped)
                Weap.weaponsOnBack.equiped = nil
            end

            if data then
                Weap:Clear(data.slot)
                Weap.weaponsOnBack.equiped = data
            end
        end)

        RegisterNetEvent('ox_inventory:updateInventory', function(changes)
            for slot,data in pairs(changes) do
                if (data == false and (Weap.weaponsOnBack.exists[slot] or (Weap.weaponsOnBack.equiped and Weap.weaponsOnBack.equiped.slot == slot))) or (Weap.weaponsOnBack.exists[slot] and data) then
                    Weap:Clear(slot)
                elseif data and Weap.weaponsOnBack.weapons[data.name] and not Weap.weaponsOnBack.exists[slot] then
                    if Weap.weaponsOnBack.equiped and Weap.weaponsOnBack.equiped.metadata.serial == data.metadata.serial then
                        Weap.weaponsOnBack.equiped = data
                    elseif not Weap.weaponsOnBack.equiped or (Weap.weaponsOnBack.equiped and Weap.weaponsOnBack.equiped.slot ~= slot) then
                        Weap:AddWeaponOnBack(data)
                    end
                end
            end
        end)
    elseif Weap.inventoryFramework == 'es_extended' then
        Weap.GetWeapons = function()
            local weapons = {}

            for k,v in pairs(Utils.GetPlayerData().Inventory) do
                if Weap.weaponsOnBack.weapons[v.name] then
                    weapons[#weapons+1] = {slot = v.slot or v.name, name = v.name}
                end
            end

            return weapons
        end
    elseif Weap.inventoryFramework == 'qb-core' then
        Weap.GetWeapons = function()
            local retval = promise.new()

            core.Functions.GetPlayerData(function(data)
                local weapons = {}
                for k,v in pairs(data.items) do
                    if Weap.weaponsOnBack.weapons[v.name] then
                        weapons[#weapons+1] = {slot = v.slot or v.name, name = v.name}
                    end
                end

                retval:resolve(weapons)
            end)

            return Citizen.Await(retval)
        end
    end

    Weap:RegisterEvents()

    RegisterCommand("+gsr_wash", function()Weap.WashGsr(true)end)
    RegisterCommand("-gsr_wash", function() end)
    RegisterKeyMapping('+gsr_wash', Lang.clean_gsr, 'keyboard', 'E')

    if Player(GetPlayerServerId(PlayerId())).state.gsr then
        CreateThread(Weap.GsrThread)
    end

    if Weap.removeDrops then
        Weap.RemoveWeaponDrops()
    end

    if Weap.forceHeadshot then
        SetPedConfigFlag(Weap.cache.ped, 438, true)
        SetPedSuffersCriticalHits(Weap.cache.ped, true)
    end

    if Weap.customCrosshair then
        CreateThread(Weap.InvalidProfileSetting)
    end

    if Weap.tazerEffects then
       AddEventHandler("entityDamaged", Weap.IsPedStunned)
    end
end

function Weap:RegisterEvents()
    AddEventHandler("plouffe_lib:hasWeapon", function(hasWeapon, weapon)
        self.hasWeapon = hasWeapon
        self.weapon = weapon

        self:IsArmed()
    end)

    AddEventHandler("plouffe_lib:inVehicle", function(inVehicle, vehicleId)
        self.inVehicle = inVehicle
        self.vehicleId = vehicleId
    end)

    exports.plouffe_lib:OnCache(function(cache)
        if not self.cache or self.cache.ped ~= cache.ped then
            self.cache = cache

            if self.forceHeadshot then
                SetPedConfigFlag(self.cache.ped, 438, true)
                SetPedSuffersCriticalHits(self.cache.ped, true)
            end

            self:RefreshWeapons()

            return
        end

        self.cache = cache
    end)

    AddEventHandler('onResourceStop', function(resourceName)
        if resourceName ~= 'plouffe_weapons' then
            return
        end

        self:Clear()
    end)
end

function Weap:FindFramework()
    self.inventoryFramework = GetConvar("plouffe_lib:inventoryFramework", "") ~= "" and GetConvar("plouffe_lib:inventoryFramework", "") or nil

    if self.inventoryFramework then
        if self.inventoryFramework == 'esx' then
            self.inventoryFramework = 'es_extended'
        elseif self.inventoryFramework == 'qbcore' then
            self.inventoryFramework = 'qb-core'
        elseif self.inventoryFramework == 'ox' then
            self.inventoryFramework = 'ox_inventory'
        end
        return
    end

    local inventorys = {
        GetResourceState('ox_inventory') ~= 'missing' and 'ox_inventory' or nil,
        GetResourceState('es_extended') ~= 'missing' and 'es_extended' or nil,
        GetResourceState('qb-core') ~= 'missing' and 'qb-core' or nil
    }

    local init = GetGameTimer()

    while GetGameTimer() - init < 1000 * 30 and not self.inventoryFramework do
        Wait(1000)
        for k,v in pairs(inventorys) do
            if GetResourceState(v) == "started" then
                self.inventoryFramework = v
                break
            end
        end
    end
end

function Weap:IsArmed()
    if not self.hasWeapon then
        return
    end

    CreateThread(function()
        local lastStressUpdate = 0
        local stressUpdateIntervall = 1000 * 10

        local aimCheck = false
        local aimingDelay = GetGameTimer()

        while self.hasWeapon do
            local hasWeapon, w_hash = GetCurrentPedWeapon(self.cache.ped)
            local isAiming = IsPlayerFreeAiming(self.cache.playerId)
            self.weapon = w_hash
            local isTazer = self.weapon == self.tazerModel
            local shooting = IsPedShooting(self.cache.ped)
            local time = GetGameTimer()

            if isTazer and self.tazerAmmo < 1 then
                DisablePlayerFiring(self.cache.Ped, true)
            end

            if shooting then
                if isTazer then
                    self.tazerAmmo -= 1
                end

                if time - lastStressUpdate > stressUpdateIntervall then
                    lastStressUpdate = time
                    pcall(function()
                        exports.plouffe_status:Add("Stress", 10)
                    end)
                end

                if not self.noGsr[self.weapon] and not Player(self.cache.serverId).state.gsr then
                    Player(self.cache.serverId).state:set("gsr", true, true)
                    CreateThread(self.GsrThread)
                end
            end

            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)

            if self.customCrosshair then
                if isAiming and not self.uiShown then
                    self.uiShown = true
                    SendNUIMessage({display = "show"})
                elseif self.uiShown and not isAiming then
                    self.uiShown = false
                    SendNUIMessage({display = "hide"})
                end

                if self.inVehicle and (isAiming or shooting) then
                    SetFollowVehicleCamViewMode(4)
                end

                if GetProfileSetting(226) == 1 then
                    self.InvalidProfileSetting()
                end

                HideHudComponentThisFrame(19)
                HideHudComponentThisFrame(14)
            end

            if self.antiAimBoost and not self.inVehicle then
                if not aimCheck and isAiming then
                    aimCheck = true
                    aimingDelay = time
                elseif aimCheck and not isAiming then
                    if time - aimingDelay < 250 then
                        SetPedToRagdoll(self.cache.ped, 500, 500, 2, 0, 0, 0)
                    end
                    aimCheck = false
                end
            end

            Wait(0)
        end

        SendNUIMessage({display = "hide"})
    end)
end

function Weap.ReloadTazer(ammo)
    ammo = tonumber(ammo) or 1

    if Weap.weapon ~= Weap.tazerModel or Weap.tazerAmmo > 0 then
        return
    end

    local finished = Interface.Progress.Circle({
        duration = 5000,
        useWhileDead = false,
        canCancel = true
    })

    if not finished or Weap.weapon ~= Weap.tazerModel then
        return
    end

    Weap.tazerAmmo += ammo

    TriggerServerEvent("plouffe_weapons:removeItem", Weap.tazerClip_item, 1)
end
exports("ReloadTazer", Weap.ReloadTazer)

function Weap.WashGsr(inWater)
    if (inWater and not IsEntityInWater(Weap.cache.ped)) then
        return
    elseif not Player(Weap.cache.serverId).state.gsr then
        return Interface.Notifications.Show({
            style = "error",
            header = "Gsr",
            message = Lang.no_gsr_to_wash
        })
    end

    local finished = Interface.Progress.Circle({
        duration = 30000,
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true
        },
        anim = {
            dict = 'amb@world_human_bum_wash@male@high@idle_a',
            clip = 'idle_a'
        }
    })

    if not finished then
        return
    end

    Player(Weap.cache.serverId).state:set("gsr", false, true)
end
exports("WashGsr", Weap.WashGsr)

function Weap.GsrTest()
    if Weap.inVehicle then
        return
    end

    local target, distance = Utils:GetClosestPlayer()
    local target_id = GetPlayerServerId(target)

    if target ~= -1 and distance <= 2.0 then
        local finished = Interface.Progress.Circle({
            duration = 5000,
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = true,
                car = true,
                combat = true
            },
            anim = {
                dict = 'amb@world_human_bum_wash@male@high@idle_a',
                clip = 'idle_a'
            }
        })

        if not finished then
            return
        end

        if Player(target_id).state.gsr then
            return Interface.Notifications.Show({
                style = "succes",
                header = "Gsr",
                message = Lang.gsr_positive
            })
        end

        Interface.Notifications.Show({
            style = "error",
            header = "Gsr",
            
            message = Lang.gsr_negative
        })
    else
        Interface.Notifications.Show({
            style = "info",
            header = "Gsr",
            message = Lang.no_player_near
        })
    end

end
exports("GsrTest", Weap.GsrTest)

function Weap.GsrThread()
    if gsrThread then
        return
    end

    gsrThread = true

    local notif = false

    while Player(Weap.cache.serverId).state.gsr do
        Wait(1000)
        local inWater = IsEntityInWater(Weap.cache.ped)

        if inWater and not notif then
            notif = true
            Interface.TextUi.Show({
                id = "gsr_press",
                message = Lang.press_to_wash_gsr
            })
        elseif notif and not inWater then
            Interface.TextUi.Hide("gsr_press")
            notif = false
        end
    end

    if notif then
        Interface.TextUi.Hide("gsr_press")
    end

    gsrThread = false
end

function Weap.RemoveWeaponDrops()
    for k,v in pairs(pickupList) do
	    ToggleUsePickupsForPlayer(Weap.cache.playerId, v, false)
    end
end

function Weap.InvalidProfileSetting()
    if warnActive or GetProfileSetting(226) ~= 1 then
        return
    end

    warnActive = true

    Interface.Notifications.Show({
        style = "info",
        header = "Weapons",
        persistentId = "weapon_ke_1",
        message = Lang.ke_message_1
    })
    Wait(100)
    Interface.Notifications.Show({
        style = "info",
        header = "Weapons",
        persistentId = "weapon_ke_2",
        message = Lang.ke_message_2
    })
    Wait(100)
    Interface.Notifications.Show({
        style = "info",
        header = "Weapons",
        persistentId = "weapon_ke_3",
        message = Lang.ke_message_3
    })
    Wait(100)
    Interface.Notifications.Show({
        style = "info",
        header = "Weapons",
        persistentId = "weapon_ke_4",
        message = Lang.ke_message_4
    })

    while GetProfileSetting(226) == 1 do
        Wait(0)
        FreezeEntityPosition(PlayerPedId(), true)
        DisableControlAction(0, 24, true)
        DisableControlAction(0, 257, true)
        DisableControlAction(0, 25, true)
        DisableControlAction(0, 263, true)
        DisableControlAction(0, 45, true)
        DisableControlAction(0, 22, true)
        DisableControlAction(0, 44, true)
        DisableControlAction(0, 37, true)
        DisableControlAction(0, 23, true)
        DisableControlAction(0, 288,  true)
        DisableControlAction(0, 170, true)
        DisableControlAction(0, 167, true)
        DisableControlAction(0, 0, true)
        DisableControlAction(0, 26, true)
        DisableControlAction(0, 73, true)
        DisableControlAction(0, 59, true)
        DisableControlAction(0, 71, true)
        DisableControlAction(0, 72, true)
        DisableControlAction(2, 36, true)
        DisableControlAction(2, 21, true)
        DisableControlAction(0, 21, true)
        DisableControlAction(0, 47, true)
        DisableControlAction(0, 264, true)
        DisableControlAction(0, 257, true)
        DisableControlAction(0, 140, true)
        DisableControlAction(0, 141, true)
        DisableControlAction(0, 142, true)
        DisableControlAction(0, 143, true)
        DisableControlAction(0, 75, true)
        DisableControlAction(27, 75, true)
    end

    FreezeEntityPosition(PlayerPedId(), false)

    warnActive = false

    Interface.Notifications.Remove("weapon_ke_1")
    Interface.Notifications.Remove("weapon_ke_2")
    Interface.Notifications.Remove("weapon_ke_3")
    Interface.Notifications.Remove("weapon_ke_4")
end

function Weap.IsPedStunned(victim, culprit, weapon, baseDamage)
    if victim ~= Weap.cache.ped or weapon ~= Weap.tazerModel then
        return
    end

    Weap.TazerEffect()
end

function Weap:Clear(slot)
    if slot and self.weaponsOnBack.exists[slot] then
        local data = self.weaponsOnBack.current[self.weaponsOnBack.exists[slot]]
        data.entitys()
        self.weaponsOnBack.current[self.weaponsOnBack.exists[slot]] = {offset = data.offset}
        self.weaponsOnBack.exists[slot] = nil
    elseif not slot then
        for k,v in pairs(self.weaponsOnBack.current) do
            if v.entitys then
                v.entitys()
                self.weaponsOnBack.exists[v.slot] = nil
                self.weaponsOnBack.current[k] = {offset = v.offset}
            end
        end
    end
end

function Weap:CreateWeapon(data)
    local entitys = setmetatable({}, {
        __call = function(self)
            for k,v in pairs(self) do
                DeleteEntity(v)
            end
        end
    })

    local weaponEntity = Utils:CreateProp(data.model, {x = self.cache.pedCoords.x, y = self.cache.pedCoords.y, z = self.cache.pedCoords.z - 5.0}, 0.0, true, true)
    SetEntityCollision(weaponEntity, false, false)
    entitys[#entitys+1] = weaponEntity

    if data.components then
        for component, data in pairs(data.components) do
            local bone = GetEntityBoneIndexByName(weaponEntity, data.bone)
            local componentEntity = Utils:CreateProp(data.model,{x = self.cache.pedCoords.x, y = self.cache.pedCoords.y, z = self.cache.pedCoords.z - 5.0}, 0.0, true, true)
            SetEntityCollision(componentEntity, false, false)
            AttachEntityToEntity(componentEntity, weaponEntity, bone, 0.0 , 0.0 , 0.00, 0.0 , 0.0 , 0.0, true, true, false, false, 1, true)
            entitys[#entitys+1] = componentEntity
        end
    end

    return weaponEntity, entitys
end

function Weap:AddWeaponOnBack(data)
    local data = type(data) == "table" and data or {name = data, slot = data}

    if not self.weaponsOnBack.weapons[data.name] then
        return
    end

    local slot

    for i=1,5 do
        if not self.weaponsOnBack.current[i].slot then
            slot = i
            break
        end
    end

    if not slot then
        return
    end

    local weaponEntity, entitys = self:CreateWeapon(self.weaponsOnBack.weapons[data.name])

    self.weaponsOnBack.current[slot] = {offset =  self.weaponsOnBack.current[slot].offset, slot = data.slot, entitys = entitys}

    self.weaponsOnBack.exists[data.slot] = slot

    AttachEntityToEntity(weaponEntity, self.cache.ped, GetPedBoneIndex(self.cache.ped, 24816), 0.2 , -0.16 , self.weaponsOnBack.current[slot].offset, 0.0 , 0.0 , 0.0, true, true, true, false, 1, true)
end

function Weap:RefreshWeapons()
    self:Clear()

    for k,v in pairs(self.GetWeapons()) do
        self:AddWeaponOnBack(v)
    end
end

CreateThread(wake)
exports.plouffe_lib:OnFrameworkLoaded(Weap.Start)