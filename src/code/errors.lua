local errors = {
    show = false,
    error = '',
    duration = 3
}

function errors:set(text, y)
    if text == self.error and self.show then return end -- Error is already visible
    self.show = true
    self.timer = self.duration
    self.error = text
    self.x = (app.VIRTUAL_WIDTH - fonts.default.label:getWidth(text)) / 2
    self.y = y
end

function errors:reset()
    self.show = false
    self.timer = self.duration
    self.error = ''
end

function errors:update(dt)
    if not self.show then return end
    self.timer = self.timer - dt
    if self.timer <= 0 then
        self.show = false
        self.timer = nil
    end
end

return errors