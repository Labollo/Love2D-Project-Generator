function requireLibraries()
    push = require "src.libraries.push"
    SavedPaths = require "src.code.startup.savedPaths"
end

function requireAssets()
    require "src.code.startup.sprites"
    require "src.code.startup.fonts"
end

function requireAll()
    gradients = require "src.code.uiElements.gradients"
    Button = require "src.code.uiElements.button"
    Textbox = require "src.code.uiElements.textbox"
    Label = require "src.code.uiElements.label"
    List = require "src.code.uiElements.list"
    UI = require "src.code.ui"
    errors = require "src.code.errors"

    require "src.code.startup.utils"
    require "src.code.settings"
    HomePage = require "src.code.interfaces.homepage"
    TemplatePage = require "src.code.interfaces.templatepage"
    LibrariesPage = require "src.code.interfaces.librariespage"
    ProjectMadePage = require "src.code.interfaces.projectmadepage"
end
