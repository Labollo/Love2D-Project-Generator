function pointInRect(x, y, rx, ry, rw, rh)
    return x >= rx and x <= rx + rw and
        y >= ry and y <= ry + rh
end

function getTemplatesFolders(path)
    local folders = {}
    local p = io.popen('dir "' .. path .. '" /b /ad') -- Only directories
    if not p then return end

    for folder in p:lines() do
        -- Check for main.lua and conf.lua files
        local mainPath = path .. "\\" .. folder .. "\\main.lua"
        local confPath = path .. "\\" .. folder .. "\\conf.lua"
        local f = io.open(mainPath, "r")
        local f1 = io.open(confPath, "r")

        if f and f1 then
            f:close()
            table.insert(folders, folder)
        end
    end
    p:close()
    return folders
end

function getLibrariesFolders(path)
    local folders = {}
    local p = io.popen('dir "' .. path .. '" /b /ad') -- Only directories
    if not p then return end

    for folder in p:lines() do
        table.insert(folders, folder)
    end
    p:close()
    return folders
end

function copyFolder(src, dst)
    -- Check destination parent folder
    local parent = dst:match("^(.*)\\") -- Extract the parent folder
    if not folderExists(parent) then
        return false
    end

    local cmd = string.format('robocopy "%s" "%s" /E /NFL /NDL /NJH /NJS /nc /ns /np > nul 2>&1', src, dst)
    os.execute(cmd)

    return true
end

-- Check if a folder exists
function folderExists(path)
    local cmd = string.format('dir "%s" /b /ad > nul 2>&1', path)
    local result = os.execute(cmd)
    return result == 0
end
