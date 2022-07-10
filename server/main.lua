RegisterNetEvent("plouffe_weapon_controller:sendConfig",function()
    local playerId = source
    local registred, key = Auth:Register(playerId)

    if registred then
        local cbArray = Weapons
        cbArray.Utils.MyAuthKey = key
    
        TriggerClientEvent("plouffe_weapon_controller:getConfig",playerId,cbArray)
    else
        TriggerClientEvent("plouffe_weapon_controller:getConfig",playerId,nil)
    end
end)

AddStateBagChangeHandler("gsr", nil, function(bagName, key, value, reserved, replicated)
    if bagName:find("player:") then
        CreateThread(function()
            local stringId = bagName:gsub("player:", "")
            local playerId = tonumber(stringId)
            local state_id = exports.ooc_core:getPlayerFromId(playerId).state_id

            if value and not Server.Shooters[state_id] then
                Server.Shooters[state_id] = true
            elseif not value and Server.Shooters[state_id] then
                Server.Shooters[state_id] = nil
            end
        end)
    end
end)

RegisterNetEvent("plouffe_weapons:used_purel",function(data,authkey)
    local playerId = source

    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_weapons:used_purel") then
            Player(playerId).state:set("gsr", false, true) 

            if data.metadata.durability and data.metadata.durability - 20 <= 0 then
                exports.ooc_core:removeItem(playerId, data.name, 1, data.metadata, data.slot)
            else
                exports.ooc_core:setDurability(playerId, data.slot, data.metadata.durability and data.metadata.durability - 20 or 80)
            end
        end
    end
end)


RegisterNetEvent("plouffe_weapons:updateparachutedata",function(data, authkey)
    local playerId = source

    if Auth:Validate(playerId, authkey) == true then
        if Auth:Events(playerId, "plouffe_weapons:updateparachutedata") == true then
            local money = exports.ooc_core:getItemCount(playerId, "money")

            if money >= Weapons.ParachutePrice and data.tint and data.r and data.g and data.b and data.description then
                exports.ooc_core:removeItem(playerId, "money", Weapons.ParachutePrice)
                exports.ooc_core:addItem(playerId, "parachute", 1, data)
            else
                TriggerClientEvent('plouffe_lib:notify', playerId, { type = 'error', text = "Vous n'avez pas asser d'argent", length = 5000})
            end
        end
    end
end)

RegisterNetEvent("plouffe_weapons:removePrachute",function(i,authkey)
    local playerId = source

    if Auth:Validate(playerId,authkey) == true then
        if Auth:Events(playerId,"plouffe_weapons:removePrachute") == true then    
            exports.ooc_core:removeItem(playerId,"parachute",1, i.metadata, i.slot)
        end
    end
end)

AddEventHandler("ooc_core:playerloaded", function(player)
    if Server.Shooters[player.state_id] then
        Player(player.playerId).state:set("gsr", true, true)
    end
end)
