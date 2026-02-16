local function initWindow()
    push:setupScreen(app.VIRTUAL_WIDTH, app.VIRTUAL_HEIGHT, app.WINDOW_WIDTH, app.WINDOW_HEIGHT, {
        resizable = true,
        fullscreen = false
    })
end

function startGame()
    require "src.code.startup.requireFiles"
    requireLibraries()

    initWindow()

    requireAssets()

    sprites:load()
    fonts:load()

    requireAll()
end
