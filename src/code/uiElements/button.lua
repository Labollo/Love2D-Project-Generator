local Button = {}
Button.__index = Button

function Button:new(x, y, w, h, params)
    params = params or {}
    local this = {
        x = x,
        y = y,
        w = w,
        h = h,
        label = params.label or '',
        onclick = params.onclick or nil,
        cursorHover = cursors.hand,
        mesh = gradients:newMesh(gradients.list.button, w, h)
    }

    setmetatable(this, self)
    return this
end

function Button:update(dt)
    local mx, my = love.mouse.getPosition() -- Mouse coords
    local gmx, gmy = push:toGame(mx, my)    -- Game Mouse coords
    if gmx and gmy then
        self.hover = pointInRect(gmx, gmy, self.x, self.y, self.w, self.h)
    else
        self.hover = false -- Out of virtual dimensions
    end
end

function Button:draw()
    local labelColor = { 0, 0, 0, 1 }
    local outlineColor = { 0, 0, 0, 1 }
    local buttonFont = fonts.default.button
    local corners = 30

    love.graphics.setLineWidth(3)
    love.graphics.setFont(buttonFont)

    -- Background
    -- Stencil to keep the background from coming out of the edges
    love.graphics.stencil(function()
        love.graphics.rectangle('fill', self.x, self.y, self.w, self.h, corners)
    end, 'replace', 1)

    love.graphics.setStencilTest('greater', 0)
    love.graphics.draw(self.mesh, self.x, self.y)
    love.graphics.setStencilTest()

    -- Label
    love.graphics.setColor(labelColor)
    local labelY = self.y + self.h / 2 - buttonFont:getHeight() / 2
    love.graphics.printf(self.label, self.x, labelY, self.w, 'center')
    love.graphics.setColor(1, 1, 1, 1)

    -- Outline
    love.graphics.setColor(outlineColor)
    love.graphics.rectangle('line', self.x, self.y, self.w, self.h, corners)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setLineWidth(1)
end

function Button:mousepressed(x, y, btn)
    if btn ~= 1 then return end

    if pointInRect(x, y, self.x, self.y, self.w, self.h) then
        if self.onclick then
            self:onclick()
        end
    end
end

return Button
