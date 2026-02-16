local gradients = {
    list = {
        windowBackground = { 'FFA3C2EF', 'FF4C6793' },
        listBackground = { 'FFD5E8D4', 'FF97D077' },
        button = { 'FFFFEBA8', 'FFFFA500' },
        selectedOption = { 'FFFFEBA8', 'FFFFA500' },
        option = { 'FFDADADA', 'FF707070' },
        textbox = { 'FFD5E8D4', 'FF97D077' },
    },
    current = nil
}

gradients.meshes = {}

local function hexToRGB(hex)
    if #hex == 8 then
        hex = string.sub(hex, 3, #hex)
    end
    hex = hex:gsub("#", "")

    local r = tonumber(hex:sub(1, 2), 16) / 255
    local g = tonumber(hex:sub(3, 4), 16) / 255
    local b = tonumber(hex:sub(5, 6), 16) / 255

    return r, g, b
end

function gradients:newMesh(gradient, width, height)
    local topHex = gradient[1]
    local bottomHex = gradient[2]

    -- Used to not recreate meshes if they already exist
    local key = topHex .. "|" .. bottomHex .. "|" .. width .. "|" .. height

    if self.meshes[key] then
        return self.meshes[key]
    end

    local tr, tg, tb = hexToRGB(topHex)
    local br, bg, bb = hexToRGB(bottomHex)

    local mesh = love.graphics.newMesh({
        { 0,     0,      0, 0, tr, tg, tb, 1 },
        { width, 0,      0, 0, tr, tg, tb, 1 },
        { width, height, 0, 0, br, bg, bb, 1 },
        { 0,     height, 0, 0, br, bg, bb, 1 },
    }, "fan")

    self.meshes[key] = mesh
    return mesh
end

return gradients
