Weapons = {}
WeaponsFnc = {}

TriggerServerEvent("plouffe_weapon_controller:sendConfig")

RegisterNetEvent("plouffe_weapon_controller:getConfig",function(list)
    if list == nil then
		CreateThread(function()
			while true do
				Wait(0)
                Weapons = nil
                WeaponsFnc = nil
			end
		end)
	else
		Weapons = list
		WeaponsFnc:Start()
	end
end)