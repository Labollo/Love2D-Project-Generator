local utf8 = require "utf8"

local Textbox = {}
Textbox.__index = Textbox

function Textbox:new(x, y, w, h, params)
    params = params or {}

    local text = params.text or ''
    local textLen = utf8.len(text) or 0

    local this = {
        x = x,
        y = y,
        w = w,
        h = h,
        hover = false,
        active = false,
        text = text,
        cursorHover = cursors.ibeam,
        alignText = params.alignText or 'center',
        cursor = {
            index = textLen + 1
        },
        update = params.update or nil,
        mesh = gradients:newMesh(gradients.list.textbox, w, h)
    }

    setmetatable(this, self)
    return this
end

function Textbox:update(dt)
    local mx, my = love.mouse.getPosition() -- Mouse coords
    local gmx, gmy = push:toGame(mx, my)    -- Game Mouse coords
    if gmx and gmy then
        self.hover = pointInRect(gmx, gmy, self.x, self.y, self.w, self.h)
    else
        self.hover = false -- Out of virtual dimensions
    end
end

function Textbox:draw()
    local corners = 20
    local textboxFont = fonts.default.textbox

    love.graphics.setLineWidth(3)
    love.graphics.setFont(textboxFont)

    -- Background
    -- Stencil to keep the background from coming out of the edges
    love.graphics.stencil(function()
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, corners)
    end, "replace", 1)

    love.graphics.setStencilTest('greater', 0)
    love.graphics.draw(self.mesh, self.x, self.y)
    love.graphics.setStencilTest()

    -- Text
    local textX = self.x
    local marginX = 15
    if self.alignText == 'left' then
        textX = textX + marginX
    elseif self.alignText == 'center' then
        textX = self.x + (self.w - textboxFont:getWidth(self.text)) / 2
    else -- Right
        textX = self.x + self.w - textboxFont:getWidth(self.text) - marginX
    end

    local textY = self.y + (self.h - textboxFont:getHeight()) / 2

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(self.text, textX, textY)
    love.graphics.setColor(1, 1, 1, 1)

    -- Text Cursor
    local blink = math.floor(love.timer.getTime() / 0.5) % 2 == 0
    if blink and self.active then
        local cursorHeight = self.h * 0.5
        local cursorY = self.y + (self.h - cursorHeight) / 2

        local cursorByte = utf8.offset(self.text, self.cursor.index)
        local textBefore = ""

        if cursorByte then
            textBefore = self.text:sub(1, cursorByte - 1)
        else
            textBefore = self.text
        end

        local cursorX = textX + textboxFont:getWidth(textBefore)

        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("fill", cursorX, cursorY, 2, cursorHeight)
        love.graphics.setColor(1, 1, 1, 1)
    end

    -- Outline
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle('line', self.x, self.y, self.w, self.h, corners)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setLineWidth(1)
end

function Textbox:mousepressed(x, y, btn)
    self.active = pointInRect(x, y, self.x, self.y, self.w, self.h)
end

function Textbox:keypressed(key)
    if not self.active then return end

    if key == 'backspace' then
        if self.cursor.index > 1 then
            local byteStart = utf8.offset(self.text, self.cursor.index - 1)
            local byteEnd   = utf8.offset(self.text, self.cursor.index)

            if byteStart then
                self.text =
                    self.text:sub(1, byteStart - 1) ..
                    self.text:sub(byteEnd or #self.text)

                self.cursor.index = self.cursor.index - 1
            end
        end
    elseif key == 'delete' then
        local len = utf8.len(self.text) or 0

        if self.cursor.index <= len then
            local byteStart = utf8.offset(self.text, self.cursor.index)
            local byteEnd   = utf8.offset(self.text, self.cursor.index + 1)

            if byteStart then
                self.text =
                    self.text:sub(1, byteStart - 1) ..
                    self.text:sub(byteEnd or #self.text)
            end
        end
    elseif key == 'v' and (love.keyboard.isDown('lctrl') or love.keyboard.isDown('rctrl')) then
        local text = love.system.getClipboardText()
        if text then
            local bytePos = utf8.offset(self.text, self.cursor.index)

            if bytePos then
                self.text =
                    self.text:sub(1, bytePos - 1) ..
                    text ..
                    self.text:sub(bytePos)
            else
                self.text = self.text .. text
            end

            self.cursor.index = self.cursor.index + (utf8.len(text) or 0)
        end
    elseif key == 'left' then
        self.cursor.index = math.max(self.cursor.index - 1, 1)
    elseif key == 'right' then
        local len = utf8.len(self.text) or 0
        self.cursor.index = math.min(self.cursor.index + 1, len + 1)
    end
end

function Textbox:textinput(t)
    if not self.active then return end

    local bytePos = utf8.offset(self.text, self.cursor.index)

    if bytePos then
        self.text =
            self.text:sub(1, bytePos - 1) ..
            t ..
            self.text:sub(bytePos)
    else
        self.text = self.text .. t
    end

    self.cursor.index = self.cursor.index + 1
end

return Textbox
