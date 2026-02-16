love = require "love"
require "src.code.startup.startGame"

app = {
    VIRTUAL_WIDTH = 1920,
    VIRTUAL_HEIGHT = 1080,
    WINDOW_WIDTH = 1280,
    WINDOW_HEIGHT = 720,
    background = nil,
    currentPage = nil,
    currentPageName = ''
}

function app:switchTo(page, params)
    params = params or {}
    self.currentPage, self.currentPageName = page:new(params)
end

cursors = {
    arrow = love.mouse.getSystemCursor('arrow'),
    hand = love.mouse.getSystemCursor('hand'),
    ibeam = love.mouse.getSystemCursor('ibeam')
}

function love.load()
    math.randomseed(os.time())

    startGame()

    app.background = gradients:newMesh(gradients.list.windowBackground, app.VIRTUAL_WIDTH, app.VIRTUAL_HEIGHT)

    app:switchTo(HomePage)
end

function love.update(dt)
    app.currentPage:update(dt)
end

function love.draw()
    love.graphics.draw(app.background)

    push:start()

    app.currentPage:draw()

    if app.currentPageName == 'homepage' or app.currentPageName == 'projectmadepage' then
        love.graphics.draw(sprites.logoSprite, UI.CONTENT_MARGIN_X, app.VIRTUAL_HEIGHT / 2, nil, 0.5, 0.5,
            0, sprites.logoSprite:getHeight() / 2)

        love.graphics.draw(sprites.logoSprite, app.VIRTUAL_WIDTH - sprites.logoSprite:getWidth() * 0.5 - UI.CONTENT_MARGIN_X,
            app.VIRTUAL_HEIGHT / 2, nil, 0.5, 0.5, 0, sprites.logoSprite:getHeight() / 2)
    end

    push:finish()
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then love.event.quit() end
    if key == 'f11' then push:switchFullscreen(app.WINDOW_WIDTH, app.WINDOW_HEIGHT) end

    app.currentPage:keypressed(key)
end

function love.mousepressed(x, y, btn)
    x, y = push:toGame(x, y)
    if not x or not y then return end

    local oldCurrentPage = app.currentPageName
    app.currentPage:mousepressed(x, y, btn)
    if oldCurrentPage ~= app.currentPageName then
        errors:reset()
    end
end

function love.mousemoved(x, y)
    x, y = push:toGame(x, y)
    if not x or not y then return end

    app.currentPage:mousemoved(x, y)
end

function love.textinput(t)
    app.currentPage:textinput(t)
end
