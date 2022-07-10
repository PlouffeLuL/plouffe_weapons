Auth = exports.plouffe_lib:Get("Auth")

Server = {}
Server.Shooters = {}

Weapons = {Utils = {}, ParachutePrice = 500}

Weapons.NoGsr = {
    WEAPON_STUNGUN = true,
    WEAPON_PAINTBALL = true,
    WEAPON_FIREEXTINGUISHER = true
}

Weapons.Zones = {
    parachuteLsTint = {
		name = "parachuteLsTint",
		coords = vector3(-928.66723632812, -2962.5361328125, 13.945072174072),
		maxDst = 1.5,
		protectEvents = true,
		isPed = true,
		isKey = true,
		isZone = true,
		nuiLabel = "Acheter un parachute "..tostring(Weapons.ParachutePrice).."$",
		keyMap = {
			checkCoordsBeforeTrigger = true,
			onRelease = true,
			releaseEvent = "on_parachute_tint",
			key = "E"
		},
		pedInfo = {
			coords = vector3(-928.66723632812, -2962.5361328125, 13.945072174072),
			heading = 60.34410858154297,
			model = 's_m_m_pilot_01', 
			scenario = 'WORLD_HUMAN_COP_IDLES',
			pedId = 0,
		}
	},

    parachuteLsTintDropZone = {
		name = "parachuteLsTintDropZone",
		coords = vector3(-1003.5895996094, -3510.6491699219, 14.143405914307),
		maxDst = 2.5,
		protectEvents = true,
		isPed = true,
		isKey = true,
		isZone = true,
		nuiLabel = "Acheter un parachute "..tostring(Weapons.ParachutePrice).."$",
		keyMap = {
			checkCoordsBeforeTrigger = true,
			onRelease = true,
			releaseEvent = "on_parachute_tint",
			key = "E"
		},
		pedInfo = {
			coords = vector3(-1003.5895996094, -3510.6491699219, 14.143405914307),
			heading = 58.51034164428711,
			model = 's_m_m_pilot_01', 
			scenario = 'WORLD_HUMAN_COP_IDLES',
			pedId = 0,
		}
	}
}

Weapons.ParachuteLanding = {
    {
		name = "parachute_landing_1",
		coords = vector3(-1052.6090087891, -3505.6870117188, 14.196441650391),
        score = 8,
        markerDst = 3.35,
		maxDst = 2.0,
        color = {red = 255, green = 255, blue = 255}
	},

    {
		name = "parachute_landing_2",
		coords = vector3(-1052.6090087891, -3505.6870117188, 14.196441650391),
		score = 7,
        markerDst = 10.9,
        maxDst = 5.63,
        color = {red = 0, green = 0, blue = 255}
	},

    {
		name = "parachute_landing_3",
		coords = vector3(-1052.6090087891, -3505.6870117188, 14.196441650391),
		score = 6,
        markerDst = 18.0,
        maxDst = 9.3,
        color = {red = 255, green = 255, blue = 255}
	},

    {
		name = "parachute_landing_4",
		coords = vector3(-1052.6090087891, -3505.6870117188, 14.196441650391),
		score = 5,
        markerDst = 25.5,
        maxDst = 12.9,
        color = {red = 255, green = 0, blue = 0}
	},

    {
		name = "parachute_landing_5",
		coords = vector3(-1052.6090087891, -3505.6870117188, 14.196441650391),
		score = 4,
        markerDst = 32.5,
        maxDst = 16.6,
        color = {red = 255, green = 255, blue = 255}
	},

    {
		name = "parachute_landing_6",
		coords = vector3(-1052.6090087891, -3505.6870117188, 14.196441650391),
		score = 3,
        markerDst = 40.0,
        maxDst = 20.2,
        color = {red = 255, green = 0, blue = 0}
	},

    {
		name = "parachute_landing_7",
		coords = vector3(-1052.6090087891, -3505.6870117188, 14.196441650391),
		score = 2,
        markerDst = 47.0,
        maxDst = 23.9,
        color = {red = 255, green = 255, blue = 255}
	},

    {
		name = "parachute_landing_8",
		coords = vector3(-1052.6090087891, -3505.6870117188, 14.196441650391),
		score = 1,
        markerDst = 54.5,
        maxDst = 27.5,
        color = {red = 255, green = 0, blue = 0}
	}
}

Weapons.Parachute = {
    SelectMenu = {
        {
            id = 1,
            header = "Parachute",
            txt = "Faire teindre votre parachute",
            params = {
                event = "",
                args = {
                    index = "ParachuteTints"
                }
            }
        },

        {
            id = 2,
            header = "Couleur de trainée",
            txt = "Équipper une trainée de couleur",
            params = {
                event = "",
                args = {
                    index = "TrailTints"
                }
            }
        }
    },

    ParachuteTints = {
        {
            id = 1,
            header = "Aucune",
            txt = "Couleur de base",
            params = {
                event = "",
                args = {
                    tint = -1,
                    label = "Aucune"
                }
            }
        },

        {
            id = 2,
            header = "Arc-En-Ciel",
            txt = "Prouver votre orientation",
            params = {
                event = "",
                args = {
                    tint = 0,
                    label = "Arc-En-Ciel",
                }
            }
        },

        {
            id = 3,
            header = "Rouge",
            txt = "...Rouge",
            params = {
                event = "",
                args = {
                    tint = 1,
                    label = "Rouge",
                }
            }
        },
        
        {
            id = 4,
            header = "SeasideStripes",
            txt = "Blanc, bleu et jaune",
            params = {
                event = "",
                args = {
                    tint = 2,
                    label = "SeasideStripes",
                }
            }
        },

        {
            id = 5,
            header = "WidowMaker",
            txt = "Brun, rouge et blanc",
            params = {
                event = "",
                args = {
                    tint = 3,
                    label = "WidowMaker",
                }
            }
        },

        {
            id = 6,
            header = "Patriot",
            txt = "Rouge, blanc et bleu",
            params = {
                event = "",
                args = {
                    tint = 4,
                    label = "Patriot",
                }
            }
        },

        {
            id = 7,
            header = "Bleu",
            txt = "...Bleu",
            params = {
                event = "",
                args = {
                    tint = 5,
                    label = "Bleu",
                }
            }
        },
        
        {
            id = 8,
            header = "Noir",
            txt = "...Noir",
            params = {
                event = "",
                args = {
                    tint = 6,
                    label = "Noir",
                }
            }
        },

        {
            id = 9,
            header = "Hornet",
            txt = "Noir et Jaune",
            params = {
                event = "",
                args = {
                    tint = 7,
                    label = "Hornet",
                }
            }
        },

        {
            id = 10,
            header = "AirForce",
            txt = "Vert, bleu et rouge",
            params = {
                event = "",
                args = {
                    tint = 8,
                    label = "AirForce",
                }
            }
        },

        {
            id = 11,
            header = "Desert",
            txt = "Blanc et gris",
            params = {
                event = "",
                args = {
                    tint = 9,
                    label = "Desert",
                }
            }
        },

        {
            id = 12,
            header = "Shadow",
            txt = "Gris foncé et gris pale",
            params = {
                event = "",
                args = {
                    tint = 10,
                    label = "Shadow",
                }
            }
        },

        {
            id = 13,
            header = "HighAltitude",
            txt = "Rouge et blanc",
            params = {
                event = "",
                args = {
                    tint = 11,
                    label = "HighAltitude",
                }
            }
        },

        {
            id = 14,
            header = "Airbone",
            txt = "Bleu, orange et blanc",
            params = {
                event = "",
                args = {
                    tint = 12,
                    label = "Airbone",
                }
            }
        },

        {
            id = 15,
            header = "Sunrise",
            txt = "Jaune, orange, rouge et bleu",
            params = {
                event = "",
                args = {
                    tint = 13,
                    label = "Sunrise",
                }
            }
        },

        {
            id = 16,
            header = "Annuler",
            txt = "Fermer le menu",
            params = {
                event = "",
                args = {
                }
            }
        }
    },

    TrailTints = {
        {
            id = 1,
            header = "Rouge",
            txt = "Utiliser la couleur rouge",
            params = {
                event = "",
                args = {
                    r = 255,
                    g = 0,
                    b = 0,
                    label = "Rouge"
                }
            }
        },

        {
            id = 2,
            header = "Vert",
            txt = "Utiliser la couleur vert",
            params = {
                event = "",
                args = {
                    r = 0,
                    g = 255,
                    b = 0,
                    label = "Vert"
                }
            }
        },

        {
            id = 3,
            header = "Bleu",
            txt = "Utiliser la couleur bleu",
            params = {
                event = "",
                args = {
                    r = 0,
                    g = 0,
                    b = 255,
                    label = "Bleu"
                }
            }
        },

        {
            id = 4,
            header = "Rose",
            txt = "Utiliser la couleur rose",
            params = {
                event = "",
                args = {
                    r = 249,
                    g = 18,
                    b = 218,
                    label = "Rose"
                }
            }
        },

        {
            id = 5,
            header = "Mauve",
            txt = "Utiliser la couleur mauve",
            params = {
                event = "",
                args = {
                    r = 161,
                    g = 16,
                    b = 198,
                    label = "Mauve"
                }
            }
        },

        {
            id = 6,
            header = "Turquoise",
            txt = "Utiliser la couleur turquoise",
            params = {
                event = "",
                args = {
                    r = 15,
                    g = 196,
                    b = 209,
                    label = "Turquoise"
                }
            }
        },

        {
            id = 7,
            header = "Jaune",
            txt = "Utiliser la couleur jaune",
            params = {
                event = "",
                args = {
                    r = 203,
                    g = 226,
                    b = 49,
                    label = "Jaune"
                }
            }
        },

        {
            id = 8,
            header = "Orange",
            txt = "Utiliser la couleur orange",
            params = {
                event = "",
                args = {
                    r = 230,
                    g = 151,
                    b = 47,
                    label = "Orange"
                }
            }
        },

        {
            id = 9,
            header = "Noir",
            txt = "Utiliser la couleur noir",
            params = {
                event = "",
                args = {
                    r = 0,
                    g = 0,
                    b = 0,
                    label = "Noir"
                }
            }
        },

        {
            id = 10,
            header = "Blanc",
            txt = "Utiliser la couleur blanc",
            params = {
                event = "",
                args = {
                    r = 255,
                    g = 255,
                    b = 255,
                    label = "Blanc"
                }
            }
        },

        {
            id = 11,
            header = "Annuler",
            txt = "Fermer le menu",
            params = {
                event = "",
                args = {
                }
            }
        }
    }
}

Weapons.Tazer = {
    tazeThreadActive = false,
    tazedAmount = 0,
    timerAddition = 1000 * 1,
    maxTazerTimer = 1000 * 6,
    modifierStrength = 0.0,
    shakerStr = 0.0,
    walk = "MOVE_M@DRUNK@SLIGHTLYDRUNK",
    modifier = "BarryFadeOut",
    screenCoolDown = 1000 * 15,
    tazerTimer = 1000 * 2,
    isTazed = false,
    model = GetHashKey("WEAPON_STUNGUN"),
    ammo = 1
}
