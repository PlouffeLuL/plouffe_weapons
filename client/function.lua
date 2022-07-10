local Utils = exports.plouffe_lib:Get("Utils")

local PlayerPedId = PlayerPedId
local GetEntityCoords = GetEntityCoords
local AttachEntityToEntity = AttachEntityToEntity
local GetPedBoneIndex = GetPedBoneIndex

local DeleteEntity = DeleteEntity
local GetEntityBoneIndexByName = GetEntityBoneIndexByName
local SetEntityCollision = SetEntityCollision

local GetPlayerServerId = GetPlayerServerId
local PlayerId = PlayerId
local joaat = joaat

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

local GetPedParachuteState = GetPedParachuteState
local DrawMarker = DrawMarker
local GetPedParachuteLandingType = GetPedParachuteLandingType

local GiveWeaponToPed = GiveWeaponToPed
local SetPlayerParachuteTintIndex = SetPlayerParachuteTintIndex
local SetPlayerParachuteModelOverride = SetPlayerParachuteModelOverride
local SetPlayerParachuteSmokeTrailColor = SetPlayerParachuteSmokeTrailColor
local ForcePedToOpenParachute = ForcePedToOpenParachute

local SetTimecycleModifierStrength = SetTimecycleModifierStrength
local SetTimecycleModifier = SetTimecycleModifier
local ShakeGameplayCam = ShakeGameplayCam

local StopGameplayCamShaking = StopGameplayCamShaking
local ClearTimecycleModifier = ClearTimecycleModifier

local ExecuteCommand = ExecuteCommand

local Wait = Wait

function WeaponsFnc:Start()
    self:ExportsAllZones()
    self:RegisterAllEvents()
    self:Init()

    for k,v in pairs(Weapons.NoGsr) do
        Weapons.NoGsr[joaat(k)] = true
        Weapons.NoGsr[k] = nil
    end

    self.playerId = GetPlayerServerId(PlayerId())
end

function WeaponsFnc:ExportsAllZones()
    for k,v in pairs(Weapons.Zones) do
        exports.plouffe_lib:ValidateZoneData(v)
    end
end

function WeaponsFnc.ReloadTazer()
    if Weapons.Tazer.ammo < 1 then
        Weapons.Ped = PlayerPedId()
        local hasWeapon, weaponHash = GetCurrentPedWeapon(Weapons.Ped)

        if Weapons.Tazer.model == weaponHash then
            Utils:ProgressCircle({
                name = "weapon_controller_reload_tazer",
                duration = 5000,
                label = "Recharge du tazer en cours",
                useWhileDead = false,
                canCancel = false,
                controlDisables = {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = false,
                }
            }, function(cancel)
                if cancel then return end
                local hasWeapon, weaponHash = GetCurrentPedWeapon(Weapons.Ped)

                if Weapons.Tazer.model == weaponHash then
                    TriggerServerEvent('ooc_core:removeItem',"tazer_clip",1)
                    Weapons.Tazer.ammo = 1
                end
            end)
        end
    end
end
exports("ReloadTazer", WeaponsFnc.ReloadTazer)

function WeaponsFnc:RegisterAllEvents()
    AddEventHandler("on_parachute_tint", function(a)
        self:OpenParachuteTintMenu()
    end)

    AddEventHandler("plouffe_lib:hasWeapon", function(hasWeapon, weaponHash)
        self:IsArmed(hasWeapon, weaponHash)
    end)

    AddEventHandler("plouffe_lib:inVehicle", function(inVehicle, vehicleId)
        self.inVehicle = inVehicle
        self.vehicleId = vehicleId
    end)
end

function WeaponsFnc:IsArmed(hasWeapon, weaponHash)
    self.hasWeapon = hasWeapon
    self.weaponHash = weaponHash

    self.LastStressUpdate = 0
    self.StressUpdateIntervall = 1000 * 10

    self.lastShot = 0

    if not self.hasWeapon then
        return
    end

    CreateThread(function(threadId)
        local playerId = PlayerId()

        while self.hasWeapon do
            local sleepTimer = 0
            local shooting = IsPedShooting(Weapons.Ped)
            local tazerWeapon = Weapons.Tazer.model == weaponHash
            local isAiming = IsPlayerFreeAiming(playerId)
            local time = GetGameTimer()

            if tazerWeapon and Weapons.Tazer.ammo < 1 then
                DisablePlayerFiring(Weapons.Ped, true)
            end

            if IsPedArmed(self.ped, 4) then
                DisableControlAction(1, 140, true)
                DisableControlAction(1, 141, true)
                DisableControlAction(1, 142, true)
            end

            if shooting == 1 then
                if not Weapons.NoGsr[self.weaponHash] and not Player(self.playerId).state.gsr then
                    Player(self.playerId).state:set("gsr", true, true)
                end

                if tazerWeapon then
                    Weapons.Tazer.ammo = Weapons.Tazer.ammo - 1 > -1 and Weapons.Tazer.ammo - 1 or 0
                end

                self.lastShot = time

                if time - self.LastStressUpdate > self.StressUpdateIntervall then
                    self.LastStressUpdate = time
                    exports.plouffe_status:Add("Stress", 10)
                end
            end

            if not self.ui and isAiming then
                self.ui = true
                SendNUIMessage({display = "show"})
            elseif self.ui and not isAiming then
                self.ui = nil
                SendNUIMessage({display = "hide"})
            end

            if self.inVehicle and (isAiming or shooting) then
                SetFollowVehicleCamViewMode(4)
            end

            Wait(sleepTimer)
        end

        self.ui = nil

        SendNUIMessage({display = "hide"})
    end)
end

function WeaponsFnc:Init()
    CreateThread(function()
        while true do
            Weapons.Ped = PlayerPedId()

            local sleepTimer = 500
            local isStunned = IsPedBeingStunned(Weapons.Ped,0)

            if isStunned then
                self:Taze()
                SetPedToRagdoll(Weapons.Ped, Weapons.Tazer.tazerTimer, Weapons.Tazer.tazerTimer, 0, true, true, true)
            end

            self.inWater = IsEntityInWater(Weapons.Ped)

            if self.inWater and not self.notification and Player(self.playerId).state.gsr then
                self.notification = "water_gsr"
                exports.plouffe_lib:ShowNotif("blue", self.notification, "[E] Pour vous laver les mains")
            elseif self.notification and (not self.inWater or not Player(self.playerId).state.gsr) then
                exports.plouffe_lib:HideNotif(self.notification)
                self.notification = nil
            end

            Wait(sleepTimer)
        end
    end)

    RegisterCommand("+gsr_wash", self.WashFromWater)
    RegisterCommand("-gsr_wash", function() end)
    RegisterKeyMapping('+gsr_wash', 'Netoyer votre gsr dans l\'eau', 'keyboard', 'E')
end

-- Parachute

function WeaponsFnc:OpenParachuteTintMenu()
    local meta =  {}
    local data = exports.ooc_menu:Open(Weapons.Parachute.ParachuteTints)

    if not data then
        return
    end

    Wait(100)

    local data2 = exports.ooc_menu:Open(Weapons.Parachute.TrailTints)

    if not data then
        return
    end

    meta.tint = data.tint
    meta.r = data2.r
    meta.g = data2.g
    meta.b = data2.b
    meta.description = ([[Teinture du parachute: %s
    Couleur de la trainée: %s]]):format(data.label, data2.label)

    TriggerServerEvent("plouffe_weapons:updateparachutedata", meta, Weapons.Utils.MyAuthKey)
end

function WeaponsFnc:DrawParachuteMarker()
    local pedCoords = GetEntityCoords(Weapons.Ped)
    if #(pedCoords - vector3(-1052.6090087891, -3505.6870117188, 14.196441650391)) < 2690 then
        CreateThread(function()
            local score = 0

            while (GetPedParachuteState(Weapons.Ped) == 1 or GetPedParachuteState(Weapons.Ped) == 2) do
                local sleepTimer = 500
                pedCoords = GetEntityCoords(Weapons.Ped)

                if #(pedCoords - vector3(-1052.6090087891, -3505.6870117188, 14.196441650391)) <= 500 then
                    sleepTimer = 0

                    for k,v in pairs(Weapons.ParachuteLanding) do
                        DrawMarker(1, v.coords.x, v.coords.y, v.coords.z - 1, 90.0, 90.0, 90.0, 0, 0.0, 0.0, v.markerDst, v.markerDst, 8.0, v.color.red, v.color.green, v.color.blue, 185, false, true, 2, false, false, false, false)
                    end
                end
                Wait(0)
            end

            local landingType = GetPedParachuteLandingType(Weapons.Ped)

            pedCoords = GetEntityCoords(Weapons.Ped)

            for k,v in ipairs(Weapons.ParachuteLanding) do
                if #(pedCoords - v.coords) <= v.maxDst then
                    score = v.score
                    break
                end
            end

            if landingType == -1 or landingType == 3 then
                score = -8
            else
                score = score - landingType
            end

            Utils:Notify("inform", "Vous avez réussi un score de: "..tostring(score).." / 8", 10000)
        end)
    end
end

function WeaponsFnc.UseParachute(i)
    local pId = PlayerId()
    GiveWeaponToPed(Weapons.Ped, joaat("GADGET_PARACHUTE"), 1, false, true)
	SetPlayerParachuteTintIndex(pId, i.metadata.tint)
	SetPlayerParachuteModelOverride(pId, 0x73268708)
	SetPlayerParachuteSmokeTrailColor(pId, i.metadata.r,i.metadata.g,i.metadata.b)
	Wait(1000)
	ForcePedToOpenParachute(Weapons.Ped)
    Wait(1000)
    CreateThread(function()
        while (GetPedParachuteState(Weapons.Ped) == 1 or GetPedParachuteState(Weapons.Ped) == 2) do
            Wait(500)
        end
        local landingType = GetPedParachuteLandingType(Weapons.Ped)
        if landingType == -1 or landingType == 3 then
            Utils:Notify("error", "Vous avez brisé votre parachute", 5000)
            TriggerServerEvent("plouffe_weapons:removePrachute", i, Weapons.Utils.MyAuthKey)
        end
    end)
    WeaponsFnc:DrawParachuteMarker()
end
exports("useparachute", WeaponsFnc.UseParachute)

-- Tazer
function WeaponsFnc:Taze()
	if Weapons.Tazer.isTazed == true then
		return
    end

    Weapons.Tazer.isTazed = true

	Weapons.Tazer.tazerTimer = Weapons.Tazer.tazerTimer + Weapons.Tazer.timerAddition

	if Weapons.Tazer.tazerTimer > Weapons.Tazer.maxTazerTimer then
		Weapons.Tazer.tazerTimer = Weapons.Tazer.maxTazerTimer
	end

	self:TazerEffect()

	CreateThread(function()
		while IsPedBeingStunned(Weapons.Ped,0) == 1 do
			Wait(0)
		end

		Weapons.Tazer.isTazed = false
	end)
end

function WeaponsFnc:TazerEffect()
	Weapons.Tazer.tazedAmount = Weapons.Tazer.tazedAmount + 1

	Weapons.Tazer.modifierStrength = Weapons.Tazer.modifierStrength + 0.2

	if Weapons.Tazer.modifierStrength > 0.7 then
		Weapons.Tazer.modifierStrength = 0.7
	end

	if Weapons.Tazer.shakerStr < 1.0 then
		Weapons.Tazer.shakerStr = Weapons.Tazer.shakerStr + 0.2
	end

	CreateThread(function()
		SetTimecycleModifierStrength(Weapons.Tazer.modifierStrength)
		SetTimecycleModifier(Weapons.Tazer.modifier)

		repeat
			ShakeGameplayCam('SMALL_EXPLOSION_SHAKE',0.2)
			Wait(100)
		until IsPedBeingStunned(Weapons.Ped,0) ~= 1

		ShakeGameplayCam("FAMILY5_Weapons_TRIP_SHAKE", Weapons.Tazer.shakerStr)
	end)

	-- WeaponsFnc:RequestAnimSet(Weapons.Tazer.walk)

    -- while not HasAnimSetLoaded(Weapons.Tazer.walk) do
	-- 	WeaponsFnc:RequestAnimSet(Weapons.Tazer.walk)
    --     Wait(0)
	-- end

	-- SetPedMovementClipset(Weapons.Ped, Weapons.Tazer.walk, 0)

	WeaponsFnc:TazerCoolDown()
end

function WeaponsFnc:TazerCoolDown()
	if Weapons.Tazer.tazeThreadActive == true then
		return
	end

	Weapons.Tazer.tazeThreadActive = true

	CreateThread(function()
		while Weapons.Tazer.modifierStrength > 0.0 and Weapons.Tazer.shakerStr > 0.0 do
			Wait(Weapons.Tazer.screenCoolDown)

			if Weapons.Tazer.modifierStrength > 0.0 then
				Weapons.Tazer.modifierStrength = Weapons.Tazer.modifierStrength - 0.1
			end

			if Weapons.Tazer.shakerStr > 0.0 then
				Weapons.Tazer.shakerStr = Weapons.Tazer.shakerStr - 0.1
			end

			-- WeaponsFnc:RequestAnimSet(Weapons.Tazer.walk)

			-- while not HasAnimSetLoaded(Weapons.Tazer.walk) do
			-- 	WeaponsFnc:RequestAnimSet(Weapons.Tazer.walk)
			-- 	Wait(0)
			-- end

			-- SetPedMovementClipset(Weapons.Ped, Weapons.Tazer.walk, 0)

			SetTimecycleModifier(Weapons.Tazer.modifier)
			SetTimecycleModifierStrength(Weapons.Tazer.modifierStrength)
		end

		Weapons.Tazer.tazerTimer = 2000
		Weapons.Tazer.modifierStrength = 0.0
		Weapons.Tazer.shakerStr = 0.0
		-- ResetPedMovementClipset(Weapons.Ped,0.0)
		StopGameplayCamShaking()
		ClearTimecycleModifier()
		Weapons.Tazer.tazeThreadActive = false
	end)
end

-- Gsr
function WeaponsFnc:WashFromWater()
    if not WeaponsFnc.inWater then
        return
    end

    Utils:PlayAnim(0,"amb@world_human_bum_wash@male@high@idle_a","idle_a",49,nil,nil,nil,true,true)

    Utils:ProgressCircle({
        name = "weapon_controller_self_clean_in_water",
        duration = 30000,
        label = "Nettoyage de résidus de tir..",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = false,
        }
    }, function(cancel)
        if not cancel then
            if WeaponsFnc.inWater == 1 then
                Player(WeaponsFnc.playerId).state:set("gsr", false, true)
            else
                Utils:Notify("Vous devez rester dans l'eau")
            end
        end

        Utils:StopAnim()
    end)
end

function WeaponsFnc.WasHandsFromPurel(data)
    Utils:PlayAnim(0,"amb@world_human_bum_wash@male@high@idle_a","idle_a",49,nil,nil,nil,true,true)

    Utils:ProgressCircle({
        name = "weapon_controller_self_clean_in_water",
        duration = 1000,
        label = "Nettoyage de résidus de tir..",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = false,
        }
    }, function(cancel)
        if not cancel then
            TriggerServerEvent("plouffe_weapons:used_purel", data, Weapons.Utils.MyAuthKey)
        end

        Utils:StopAnim()
    end)
end
exports("WasHandsFromPurel", WeaponsFnc.WasHandsFromPurel)

function DoGsrTest()
    local target, distance = Utils:GetClosestPlayer()
    local target_id = GetPlayerServerId(target)
    ExecuteCommand("e tablet")
    if target ~= -1 and distance <= 2.0 then
        Utils:ProgressCircle({
            name = "gsr_test",
            duration = 3000,
            label = "Test gsr en cour.",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = false,
            }
        }, function(status)
            if not status then
                if Player(target_id).state.gsr then
                    Utils:Notify('inform', "L'individue a retourner POSITIF au test GSR [l'individue a des résidus de poudre noir sur les mains]", 10000, { ['background-color'] = '#EE0000', ['color'] = '#ffffff' })
                else
                    Utils:Notify('inform', "L'individue a retourner NEGATIF au test GSR [l'individue n'a pas de résidu de poudre noir sur les mains]", 10000, { ['background-color'] = '#20EE00', ['color'] = '#ffffff' })
                end
            end
            ExecuteCommand("e c")
        end)
    else
        Utils:Notify('inform', "Aucun joueur a proximité", 10000, { ['background-color'] = '#EE0000', ['color'] = '#ffffff' })
    end
end
exports("DoGsrTest", DoGsrTest)

-- Weapons on back
local backWeapons = {
    WEAPON_MK47FM = {
        model = "MK47FluffysMods",
    },

    WEAPON_G36 = {
        model = "markomods-g36",
        componentsDefault = {
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
        componentsDefault = {
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
        componentsDefault = {
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
        componentsDefault = {
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
        componentsDefault = {
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
        componentsDefault = {
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
        componentsDefault = {
            COMPONENT_ASVAL_STOCK_01 = {
                bone = 'WAPGrip_2',
                model = 'asval_stock_01'
            },
        },
    },

    WEAPON_AKS74U = {
        model = "aks74u",
        componentsDefault = {
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
        componentsDefault = {
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

local currentlyAttached = {}

local offsets = setmetatable({
    {offset = 0.12},
    {offset = 0.06},
    {offset = 0.00},
    {offset = -0.06},
    {offset = -0.12},
}, {
    __call = function(self, slot, data)
        for k,v in ipairs(self) do
            if not v.slot and slot and data then
                v.slot = slot

                return v.offset
            elseif v.slot and v.slot == slot and not data then
                v.slot = nil

                if currentlyAttached[slot] then
                    currentlyAttached[slot]()
                    currentlyAttached[slot] = nil
                end
            end
        end
    end
})

local equiped = nil

function WeaponsFnc:CreateWeapon(data)
    local entitys = setmetatable({}, {
        __call = function(self)
            for k,v in pairs(self) do
                DeleteEntity(k)
            end
        end
    })

    local weaponEntity = Utils:CreateProp(data.model,{x = self.pedCoords.x, y = self.pedCoords.y, z = self.pedCoords.z - 5.0}, 0.0, true, true)
    SetEntityCollision(weaponEntity, false, false)
    entitys[weaponEntity] = true

    if data.componentsDefault then
        for component, data in pairs(data.componentsDefault) do
            local bone = GetEntityBoneIndexByName(weaponEntity, data.bone)
            local componentEntity = Utils:CreateProp(data.model,{x = self.pedCoords.x, y = self.pedCoords.y, z = self.pedCoords.z - 5.0}, 0.0, true, true)
            SetEntityCollision(componentEntity, false, false)
            AttachEntityToEntity(componentEntity, weaponEntity, bone, 0.0 , 0.0 , 0.00, 0.0 , 0.0 , 0.0, true, true, false, false, 1, true)
            entitys[componentEntity] = true
        end
    end

    return weaponEntity, entitys
end

function WeaponsFnc:CreateSlotWeapon(data)
    self.ped = PlayerPedId()
    self.pedCoords = GetEntityCoords(ped)

    local weaponEntity, entitys = self:CreateWeapon(backWeapons[data.name])
    currentlyAttached[data.slot] = entitys

    local offset = offsets(data.slot, currentlyAttached[data.slot])

    if not offset then
        currentlyAttached[data.slot]()
        currentlyAttached[data.slot] = nil
        return
    end

    AttachEntityToEntity(weaponEntity, self.ped, GetPedBoneIndex(self.ped, 24816), 0.2 , -0.16 , offset, 0.0 , 0.0 , 0.0, true, true, true, false, 1, true)
end

function WeaponsFnc:SetWeapons()
    local items = {}

    for k,v in pairs(currentlyAttached) do
        v()
    end

    currentlyAttached = {}

    for k,v in pairs(offsets) do
        v.slot = nil
    end

    for k,v in pairs(backWeapons) do
        table.insert(items, k)
    end

    local currentWeapons = exports.ox_inventory:Search("slots", items)

    self.ped = PlayerPedId()
    self.pedCoords = GetEntityCoords(self.ped)

    for weapon,data in pairs(backWeapons) do
        for k,v in pairs(currentWeapons[weapon]) do

            local weaponEntity, entitys = self:CreateWeapon(data)
            currentlyAttached[v.slot] = entitys

            local offset = offsets(v.slot, currentlyAttached[v.slot])

            if not offset then
                currentlyAttached[v.slot]()
                currentlyAttached[v.slot] = nil
                return
            end

            AttachEntityToEntity(weaponEntity, self.ped, GetPedBoneIndex(self.ped, 24816), 0.2 , -0.16 , offset, 0.0 , 0.0 , 0.0, true, true, true, false, 1, true)
        end
    end
end

AddEventHandler('plouffe_lib:cache',function(data)
    if data.ped ~= WeaponsFnc.ped then
        WeaponsFnc.ped = data.ped
        WeaponsFnc:SetWeapons()
    end
end)

AddEventHandler('ox_inventory:currentWeapon',function(data)
    if data and not backWeapons[data.name] then
        return
    end

    if data then
        offsets(data.slot)
        equiped = data
        return
    end

    if not equiped then
        return
    end

    WeaponsFnc:CreateSlotWeapon(equiped)
    equiped = nil
end)

RegisterNetEvent('ox_inventory:updateInventory', function(changes)
    for slot,data in pairs(changes) do
        if currentlyAttached[slot] and not data then
            offsets(slot,false)
        elseif data and currentlyAttached[data.slot] then
            offsets(slot,false)
        end

        if data and backWeapons[data.name] and (not equiped or equiped and equiped.slot ~= slot) then
            WeaponsFnc:CreateSlotWeapon(data)
        end
    end
end)

AddEventHandler("ooc_core:playerloaded", function(playerData)
    Wait(5000)
    WeaponsFnc:SetWeapons()
end)