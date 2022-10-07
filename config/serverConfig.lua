Weap = {
    removeDrops = true,
    forceHeadshot = true,
    customCrosshair = true,
    tazerEffects = true,
    useWeaponsOnBack = true
}

Weap.noGsr = {
    WEAPON_STUNGUN = true,
    WEAPON_PAINTBALL = true,
    WEAPON_FIREEXTINGUISHER = true
}

Weap.onBack = {
    WEAPON_BAT = {
        rotation = vector3(0.0 , 90.0, 0.0),
    },
    WEAPON_BATTLEAXE = {
        rotation = vector3(0.0 , 90.0, 0.0),
    },
    WEAPON_CROWBAR = {
        rotation = vector3(0.0 , 90.0, 0.0),
    },
    WEAPON_GOLFCLUB = {
        rotation = vector3(0.0 , 270.0, 0.0),
    },
    WEAPON_HATCHET = {
        rotation = vector3(0.0 , 90.0, 0.0),
    },
    WEAPON_MACHETE = {
        rotation = vector3(0.0 , 270.0, 0.0),
    },
    WEAPON_NIGHTSTICK = {
        rotation = vector3(0.0 , 90.0, 0.0),
    },
    WEAPON_POOLCUE = {
        rotation = vector3(0.0 , 90.0, 0.0),
    },
    WEAPON_STONE_HATCHET = {
        rotation = vector3(0.0 , 90.0, 0.0),
    },
    WEAPON_WRENCH = {
        rotation = vector3(0.0 , 90.0, 0.0),
    },

    WEAPON_CERAMICPISTOL = {},
    WEAPON_COMBATPISTOL = {},
    WEAPON_DOUBLEACTION = {},
    WEAPON_HEAVYPISTOL = {},
    WEAPON_MARKSMANPISTOL = {},
    WEAPON_NAVYREVOLVER = {},
    WEAPON_GADGETPISTOL = {},
    WEAPON_PISTOL = {},
    WEAPON_PISTOL50 = {},
    WEAPON_PISTOL_MK2 = {},
    WEAPON_REVOLVER = {},
    WEAPON_REVOLVER_MK2 = {},
    WEAPON_SNSPISTOL = {},
    WEAPON_SNSPISTOL_MK2 = {},
    WEAPON_VINTAGEPISTOL = {},

    WEAPON_APPISTOL = {},
    WEAPON_MACHINEPISTOL = {},
    WEAPON_MICROSMG = {},
    WEAPON_MINISMG = {},

    WEAPON_ASSAULTSMG = {},
    WEAPON_COMBATPDW = {},
    WEAPON_COMPACTRIFLE = {},
    WEAPON_GUSENBERG = {},
    WEAPON_SMG = {},
    WEAPON_SMG_MK2 = {},

    WEAPON_PAINTBALL = {},
    WEAPON_M45A1 = {},
    WEAPON_ADVANCEDRIFLE = {},
    WEAPON_ASSAULTRIFLE = {},
    WEAPON_ASSAULTRIFLE_MK2 = {},
    WEAPON_BULLPUPRIFLE = {},
    WEAPON_BULLPUPRIFLE_MK2 = {},
    WEAPON_CARBINERIFLE = {},
    WEAPON_CARBINERIFLE_MK2 = {},
    WEAPON_HEAVYRIFLE = {},
    WEAPON_MILITARYRIFLE = {},
    WEAPON_SPECIALCARBINE = {},
    WEAPON_SPECIALCARBINE_MK2 = {},
    WEAPON_TACTICALRIFLE = {},

    WEAPON_COMBATMG = {},
    WEAPON_COMBATMG_MK2 = {},
    WEAPON_MG = {},

    WEAPON_ASSAULTSHOTGUN = {},
    WEAPON_BULLPUPSHOTGUN = {},
    WEAPON_COMBATSHOTGUN = {},
    WEAPON_DBSHOTGUN = {},
    WEAPON_HEAVYSHOTGUN = {},
    WEAPON_PUMPSHOTGUN = {},
    WEAPON_PUMPSHOTGUN_MK2 = {},
    WEAPON_SAWNOFFSHOTGUN = {},

    WEAPON_HEAVYSNIPER = {},
    WEAPON_HEAVYSNIPER_MK2 = {},
    WEAPON_MARKSMANRIFLE = {},
    WEAPON_MARKSMANRIFLE_MK2 = {},
    WEAPON_MUSKET = {},
    WEAPON_SNIPERRIFLE = {},
    WEAPON_PRECISIONRIFLE = {},

    WEAPON_EMPLAUNCHER = {},
    WEAPON_FIREEXTINGUISHER = {
        rotation = vector3(0.0 , 90.0, 0.0),
    },
    WEAPON_FIREWORK = {},
    WEAPON_HAZARDCAN = {
        rotation = vector3(0.0 , 90.0, 0.0),
    },
    WEAPON_PETROLCAN = {
        rotation = vector3(0.0 , 90.0, 0.0),
    },
    WEAPON_STUNGUN = {},
    WEAPON_GRENADELAUNCHER_SMOKE = {},

    -- Modulars / addons weapons
    WEAPON_GLOCK19X2 = {
        position = {
            bone = 24816,
            offset = vector3(-0.17, 0.03, -0.21),
            rotation = vector3(280.0, 178.0, 10.0)
        }
    },
    WEAPON_BROWNING = {},
    WEAPON_DP9 = {},
    WEAPON_GLOCK18C = {},
    WEAPON_DEAGLE = {},
    WEAPON_P320B = {},

    WEAPON_SR25 = {},
    WEAPON_SCARSC = {},
    WEAPON_PMXFM = {
        position = {
            groups = {"police"},
            bone = 24816,
            offset = vector3(0.18, 0.19, 0.0),
            rotation = vector3(9.0, 146.0, 3.0)
        }
    },
    WEAPON_MPX = {},
    WEAPON_DRACO = {},
    WEAPON_SCORPIONEVO = {},
    WEAPON_MP9A = {},

    WEAPON_MK47FM = {},
    WEAPON_MDR = {},

    WEAPON_G36 = {
        components = {
            'COMPONENT_MARKOMODSG36_STOCK_01',
            'COMPONENT_MARKOMODSG36_BARREL_01'
        }
    },

    WEAPON_AKM = {
        components = {
            'COMPONENT_AKM_HANDGUARD_01',
            'COMPONENT_AKM_PISTOLGRIP_01',
            'COMPONENT_AKM_STOCK_01',
            'COMPONENT_AKM_DUSTCOVER_01'
        }
    },

    WEAPON_50BEOWULF = {
        components = {
            'COMPONENT_BEOWULF_BODY_01'
        }
    },

    WEAPON_SCAR17FM = {
        components = {
            'COMPONENT_SCAR_BODY_01',
            'COMPONENT_SCAR_BARREL_01'
        }
    },

    WEAPON_M4A1FM = {
        components = {
            'COMPONENT_M4A1FM_BARREL_01'
        }
    },

    WEAPON_P90FM = {
        components = {
            'COMPONENT_P90_BARREL_01'
        }
    },

    WEAPON_ASVAL = {
        components = {
            'COMPONENT_ASVAL_STOCK_01'
        },
    },

    WEAPON_AKS74U = {
        components = {
            'COMPONENT_AKS74U_HANDGUARD_01',
            'COMPONENT_AKS74U_STOCK_01'
        },
    },

    WEAPON_MCXSPEAR = {
        components = {
            'COMPONENT_MCXSPEAR_BODY_01',
            'COMPONENT_MCXSPEAR_STOCK_01'
        }
    }
}