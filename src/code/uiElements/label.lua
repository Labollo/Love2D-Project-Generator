local Label = {}
Label.__index = Label

function Label:new(x, y, params)
    params = params or {}
    local visible = params.visible
    if visible == nil then
        visible = true
    end
    local this = {
        x = x,
        y = y,
        label = params.label or '',
        visible = visible,
        update = params.update or nil,
        color = params.color or { 0, 0, 0, 1 },
        font = params.font or fonts.default.label
    }

    setmetatable(this, self)
    return this
end

function Label:draw()
    if not self.visible then return end

    local labelColor = { self.color[1], self.color[2], self.color[3], self.color[4] }

    love.graphics.setFont(self.font)
    love.graphics.setColor(labelColor)
    love.graphics.print(self.label, self.x, self.y)
    love.graphics.setColor(1, 1, 1, 1)
end

return Label
