local Auth <const> = exports.plouffe_lib:Get("Auth")
local Callback <const> = exports.plouffe_lib:Get("Callback")

function Weap:GetData(key)
    local retval = {auth = key}

    for k,v in pairs(self) do
        if type(v) ~= "function" then
            retval[k] = v
        end
    end

    return retval
end

Callback:RegisterServerCallback("plouffe_weapons:loadPlayer", function(playerId, cb)
    local registred, key = Auth:Register(playerId)

    if not registred then
        return DropPlayer(" "), cb()
    end

    cb(Weap:GetData(key))
end)