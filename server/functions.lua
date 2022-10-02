local Auth <const> = exports.plouffe_lib:Get("Auth")
local Callback <const> = exports.plouffe_lib:Get("Callback")
local Utils <const> = exports.plouffe_lib:Get("Utils")

local Parser = {meta_path = {components = {}, weapons = {}}, tempData = {}, tempModels = {}}

local ready = false

function Weap:GetData(key)
    local retval = {auth = key}

    for k,v in pairs(self) do
        if type(v) ~= "function" then
            retval[k] = v
        end
    end

    return retval
end

function Weap.ValidateConfig()
    local scanned = GetResourceKvpString("components_parsed")
    if not scanned then
        Utils:Debug("Server has never been scanned for addon components, this can cause server lag while scanning.")
        Parser:Start()
        Utils:Debug("^4You can use the command ^1plouffe_weapons:scanForComponents ^4to force scan if you add a new addon weapon.^0")
    elseif not LoadResourceFile('plouffe_weapons', "data/components.json") then
        Utils:Debug("^1Unable to load components.json file, recreating the file.^0")
        Parser:Start()
    elseif not LoadResourceFile('plouffe_weapons', "data/weapons.json") then
        Utils:Debug("^1Unable to load weapons.json file, recreating the file.^0")
        Parser:Start()
    end

    local weapons_data = json.decode(LoadResourceFile('plouffe_weapons', "data/weapons.json"))

    for k,v in pairs(Weap.onBack) do
        v.model = weapons_data[k].model
    end

    ready = true
end

Callback:RegisterServerCallback("plouffe_weapons:loadPlayer", function(playerId, cb)
    local registred, key = Auth:Register(playerId)

    if not registred then
        return DropPlayer(" "), cb()
    end

    while not ready do
        Wait(1000)
    end

    cb(Weap:GetData(key))
end)

CreateThread(Weap.ValidateConfig)

function Parser:Start()
    self.system = os.getenv('OS')
	self.command = self.system and self.system:match('Windows') and 'dir "' or 'ls "'
    self.suffix = self.command == 'dir "' and '/" /b' or '/"'

    assert(load(LoadResourceFile('plouffe_weapons', "data/backup.lua"), '@@plouffe_weapons/data/backup.lua'))()

    local resourceCount = GetNumResources()
    for i = 0, resourceCount do
        local resourceName = GetResourceByFindIndex(i)
        if resourceName then
            local dir_path = GetResourcePath(resourceName):gsub('//', '/')
            local dir = io.popen(("%s%s%s"):format(self.command, dir_path, self.suffix))
            if dir then
                for file in dir:lines() do
                    if file == "__resource.lua" or file == "fxmanifest.lua" then
                        local fx_path = ("%s/%s"):format(dir_path, file)
                        local file_handle = io.input(fx_path)
                        if not file_handle then
                            break
                        end
                        for line in file_handle:lines() do
                            if line:find("WEAPON_COMPONENTS_FILE") or line:find("WEAPONCOMPONENTSINFO_FILE") then
                                Utils:Debug({"Addon component found at resource", resourceName})
                                self:ScanFolder(dir_path, self:ParseLine(line), "components")
                            end

                            if line:find("WEAPONINFO_FILE") then
                                Utils:Debug({"Addon weapon found at resource", resourceName})
                                self:ScanFolder(dir_path, self:ParseLine(line), "weapons")
                            end
                        end
                        file_handle:close()
                    end
                end
                dir:close()
            end
        end
    end

    self:ScanComponents()
    self:ScanWeapons()
    self:SaveJson()
end

function Parser:ParseLine(line)
    local one,two = line:find("/")
    while one do
        line = line:sub(two+1,line:len())
        one,two = line:find("/")
    end

    local subs = {
        "WEAPON_COMPONENTS_FILE",
        "WEAPONCOMPONENTSINFO_FILE",
        "WEAPONINFO_FILE",
        "data_file",
        "%s+",
        "'",
        '%"',
        "*",
        "/"
    }
    for k,v in pairs(subs) do
        line = line:gsub(v, "")
    end

    return line
end

function Parser:ScanFolder(path, fileName, key)
    local dir = io.popen(("%s%s%s"):format(self.command, path, self.suffix))
    if dir then
        for file in dir:lines() do    
            if file == fileName then
                self.meta_path[key][#self.meta_path[key]+1] = ("%s/%s"):format(path, file)
                Utils:Debug({"Found", fileName, "in", ("%s/%s"):format(path, file)})
            end

            self:ScanFolder(("%s/%s"):format(path,file), fileName, key)
        end
        dir:close()
    end
end

function Parser:ScanComponents()
    for k,v in pairs(self.meta_path.components) do
        Utils:Debug({"Scanning", v})
        local file_handle = io.input(v)
        if not file_handle then
            break
        end

        local name, model, bone
        for line in file_handle:lines() do
            if line:find("<Name>") then
                if name then
                    model = nil
                    bone = nil
                end
                name = line:gsub("</Name>", "")
                name = name:gsub("<Name>", "")
                name = name:gsub("%\t", "")
            elseif line:find("<Model>") and not model then
                model = line:gsub("</Model>", "")
                model = model:gsub("<Model>", "")
                model = model:gsub("%\t", "")
            elseif line:find("<AttachBone>") and not bone then
                bone = line:gsub("</AttachBone>", "")
                bone = bone:gsub("<AttachBone>", "")
                bone = bone:gsub("%\t", "")
            elseif (bone and model and name) then
                self.tempData[name] = {name = name, model = model, bone = bone}
                model = nil
                bone = nil
            end
        end
        file_handle:close()
    end
end

function Parser:ScanWeapons()
    for k,v in pairs(self.meta_path.weapons) do
        Utils:Debug({"Scanning", v})
        local file_handle = io.input(v)
        if not file_handle then
            break
        end

        local name, model
        local let_search = false
        for line in file_handle:lines() do
            if line:find('<Item type="CWeaponInfo">') then
                let_search = true

                name = nil
                model = nil
            end

            if line:find('</Item>') and let_search then
                let_search = false
                if model and name then
                    self.tempModels[name] = {name = name, model = model}
                end
            end

            if let_search then
                if line:find("<Name>") and not name then
                    name = line:gsub("</Name>", "")
                    name = name:gsub("<Name>", "")
                    name = name:gsub("%\t", "")
                    name = name:gsub("%s+", "")
                elseif line:find("<Model>") and not model then
                    model = line:gsub("</Model>", "")
                    model = model:gsub("<Model>", "")
                    model = model:gsub("%\t", "")
                    model = model:gsub("%s+", "")
                end
            end
        end
        file_handle:close()
    end
end

function Parser:SaveJson()
    local temp_data = {}
    for k,v in pairs(backup_data) do
        temp_data[v.name:upper()] = {name = v.name, bone = v.bone, model = v.model, name_hash = joaat(v.name), model_hash = joaat(v.model)}
    end
    for k,v in pairs(self.tempData) do
        temp_data[v.name:upper()] = {name = v.name, bone = v.bone, model = v.model, name_hash = joaat(v.name), model_hash = joaat(v.model)}
    end

    SaveResourceFile(GetCurrentResourceName(), "data/components.json", json.encode(temp_data, {indent = true}), -1)
    Utils:Debug("Saved components.json")

    temp_data = {}
    for k,v in pairs(backup_weapons) do
        temp_data[v.name:upper()] = {name = v.name, model = v.model, name_hash = joaat(v.name), model_hash = joaat(v.model)}
    end
    for k,v in pairs(self.tempModels) do
        temp_data[v.name:upper()] = {name = v.name, model = v.model, name_hash = joaat(v.name), model_hash = joaat(v.model)}
    end

    SaveResourceFile(GetCurrentResourceName(), "data/weapons.json", json.encode(temp_data, {indent = true}), -1)
    Utils:Debug("Saved weapons.json")

    Utils:Debug("All data saved properly")
    Utils:Debug("Please restart your server")

    SetResourceKvp("components_parsed", "true")
end

RegisterCommand('plouffe_weapons:scanForComponents', function(source, args, raw)
    Parser:Start()
end, true)