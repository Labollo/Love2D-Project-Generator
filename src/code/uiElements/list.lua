local List = {}
List.__index = List

function List:new(x, y, w, h, params)
    params = params or {}
    local options = {}
    local optionHeight = params.optionHeight or h / 5

    -- params.options {"xx", "yy"}
    for _, o in ipairs(params.options or {}) do
        table.insert(options, {
            label = o,
            mesh = gradients:newMesh(gradients.list.option, w, optionHeight),
            selectedMesh = gradients:newMesh(gradients.list.selectedOption, w, optionHeight),
            selected = false
        })
    end

    local this = {
        x = x,
        y = y,
        w = w,
        h = h,
        mesh = gradients:newMesh(gradients.list.listBackground, w, h),
        options = options,
        optionHeight = optionHeight,
        hover = false,
        cursorHover = cursors.hand,
        multipleChoice = params.multipleChoice or false,
        required = params.required or false,
        optionOnclick = params.optionOnclick or nil
    }

    if this.required and this.options[1] then
        this.options[1].selected = true
    end

    setmetatable(this, self)
    return this
end

function List:update(dt)
    local mx, my = love.mouse.getPosition() -- Mouse coords
    local gmx, gmy = push:toGame(mx, my)    -- Game Mouse coords
    if gmx and gmy then
        self.hover = pointInRect(gmx, gmy, self.x, self.y, self.w, self.optionHeight * #self.options)
    else
        self.hover = false -- Out of virtual dimensions
    end
end

function List:draw()
    love.graphics.setLineWidth(3)
    love.graphics.setFont(fonts.default.listOptions)

    -- Background
    love.graphics.draw(self.mesh, self.x, self.y)

    -- Options
    local y = self.y
    for _, o in ipairs(self.options) do
        -- Option Background
        if o.selected then
            love.graphics.draw(o.selectedMesh, self.x, y)
        else
            love.graphics.draw(o.mesh, self.x, y)
        end

        -- Option Label
        love.graphics.setColor(0, 0, 0, 1)
        local labelY = y + (self.optionHeight - fonts.default.listOptions:getHeight()) / 2
        love.graphics.printf(o.label, self.x, labelY, self.w, 'center')

        -- Bottom line
        y = y + self.optionHeight
        love.graphics.setColor(1, 1, 1, 1)
    end

    y = self.y
    love.graphics.setColor(0, 0, 0, 1)
    for _, o in ipairs(self.options) do
        y = y + self.optionHeight
        love.graphics.line(self.x, y, self.x + self.w, y)
    end

    -- Outline
    love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    love.graphics.setColor(1, 1, 1, 1)
end

function List:setOptions(newOptions)
    self.options = {}

    for _, o in ipairs(newOptions) do
        table.insert(self.options, {
            label = o,
            mesh = gradients:newMesh(gradients.list.option, self.w, self.optionHeight),
            selectedMesh = gradients:newMesh(gradients.list.selectedOption, self.w, self.optionHeight),
            selected = false
        })
    end
    if self.required and self.options[1] then
        self.options[1].selected = true
    end
end

function List:getSelectedOptions()
    local options = {}
    for _, o in ipairs(self.options) do
        if o.selected then
            table.insert(options, o)
        end
    end
    if self.multipleChoice then
        return options
    end
    return options[1]
end

function List:getOptions()
    return self.options
end

function List:mousepressed(x, y, btn)
    if btn ~= 1 then return end

    local oy = self.y
    local changed = false

    for i, o in ipairs(self.options) do
        if pointInRect(x, y, self.x, oy, self.w, self.optionHeight) then
            changed = true
            if self.multipleChoice then
                if o.selected then
                    if self.required then
                        local hasOtherSelected = false
                        for j, other in ipairs(self.options) do
                            if j ~= i and other.selected then
                                hasOtherSelected = true
                                break
                            end
                        end
                    end
                    o.selected = false
                else
                    o.selected = true
                end
                break
            end

            -- Single choice
            if o.selected then
                if self.required then
                    break
                end
                o.selected = false
                break
            end

            o.selected = true
            for j, other in ipairs(self.options) do
                if j ~= i then
                    other.selected = false
                end
            end
            break
        end
        oy = oy + self.optionHeight
    end
    if self.optionOnclick and changed then
        self:optionOnclick(self)
    end
end

return List
