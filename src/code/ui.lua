local UI = {}
UI.__index = UI

UI.MAIN_BUTTON_WIDTH = 450
UI.BUTTONS_HEIGHT = 120
UI.SUB_BUTTON_WIDTH = 350
UI.SEARCH_BUTTON_WIDTH = 230
UI.SEARCH_BUTTON_HEIGHT = 70
UI.CONTENT_MARGIN_X = 120
UI.CONTENT_MARGIN_Y = 80
UI.ERRORS_Y_HOMEPAGE = UI.CONTENT_MARGIN_Y * 2.5
UI.ERRORS_Y_OTHER_PAGES = UI.ERRORS_Y_HOMEPAGE * 0.93

function UI:new()
    local this = {
        elements = {}
    }
    setmetatable(this, self)
    return this
end

function UI:addElement(element)
    table.insert(self.elements, element)
end

function UI:update(dt)
    local cursorHover = cursors.arrow
    for _, e in ipairs(self.elements) do
        if e.update then
            e:update(dt)
        end

        -- Already exists a hover
        if e.hover and e.cursorHover then
            cursorHover = e.cursorHover
        end
    end

    -- Change cursor to hover or arrw as fallback
    love.mouse.setCursor(cursorHover)
end

function UI:draw()
    for _, e in ipairs(self.elements) do
        if e.draw then
            e:draw()
        end
    end
end

function UI:mousepressed(x, y, btn)
    for _, e in ipairs(self.elements) do
        if e.mousepressed then
            e:mousepressed(x, y, btn)
        end
    end
end

function UI:mousemoved(x, y)
    for _, e in ipairs(self.elements) do
        if e.mousemoved then
            e:mousemoved(x, y)
        end
    end
end

function UI:textinput(t)
    for _, e in ipairs(self.elements) do
        if e.textinput then
            e:textinput(t)
        end
    end
end

function UI:keypressed(key)
    for _, e in ipairs(self.elements) do
        if e.keypressed then
            e:keypressed(key)
        end
    end
end

return UI
