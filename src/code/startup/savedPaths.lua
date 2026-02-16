local json = require "src.libraries.dkjson"

local SavedPaths = {}
SavedPaths.__index = SavedPaths
SavedPaths.filePath = "saved_paths.json"
SavedPaths.paths = {}

function SavedPaths:load()
    local file = io.open(self.filePath, "r")
    if not file then return end
    local content = file:read("*a")
    file:close()
    local obj, _, err = json.decode(content)
    if err then
        print("Error while loading saved paths:", err)
        return
    end
    self.paths = obj or {}
end

function SavedPaths:save()
    local file = io.open(self.filePath, "w")
    if not file then
        print("Error while saving saved paths")
        return
    end
    local content = json.encode(self.paths, { indent = true })
    ---@diagnostic disable-next-line: param-type-mismatch
    file:write(content)
    file:close()
end

function SavedPaths:get(key)
    return self.paths[key]
end

function SavedPaths:set(key, value)
    self.paths[key] = value
    self:save()
end

SavedPaths:load()

return SavedPaths
