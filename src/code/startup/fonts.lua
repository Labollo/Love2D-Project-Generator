fonts = {}

function fonts:load()
    fonts.default = {}
    fonts.default.button = love.graphics.newFont(40)
    fonts.default.textbox = love.graphics.newFont(32)
    fonts.default.label = love.graphics.newFont(32)
    fonts.default.listOptions = love.graphics.newFont(40)
    fonts.default.projectMadeLabel = love.graphics.newFont(64)
end