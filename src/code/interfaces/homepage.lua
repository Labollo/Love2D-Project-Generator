local HomePage = {}

projectPath = SavedPaths:get("projectPath") or ""

function HomePage:new(params)
    local function newProject(projectPath, projectName)
        local template = settings.template
        local templatesRoot = settings.templatePath

        local errorY = UI.ERRORS_Y_HOMEPAGE
        if projectName == '' then
            errors:set('Non hai inserito il nome del progetto!', errorY)
            return
        end
        if projectPath == '' then
            errors:set('Non hai inserito il percorso di destinazione!', errorY)
            return
        end
        SavedPaths:set("projectPath", projectPath)

        if not template then
            errors:set('Non hai scelto un template!', errorY)
            return
        end

        local source = templatesRoot .. "\\" .. template.label
        local destination = projectPath .. '\\' .. projectName

        -- Se il progetto esiste già
        if folderExists(destination) then
            errors:set('"' .. projectName .. '" esiste già', errorY)
            return
        end

        -- Copia cartella principale del template
        local ok = copyFolder(source, destination)
        if not ok then
            errors:set('Il percorso ' .. projectPath .. ' non esiste', errorY)
            return
        end

        -- Cerca eventuale cartella libraries nel template
        local templateLibrariesPath
        local function findLibraries(dir)
            local p = io.popen('dir "' .. dir .. '" /s /b /ad') -- tutte le sottocartelle
            if p then
                for subdir in p:lines() do
                    local normalized = subdir:gsub("/", "\\")
                    if normalized:match("\\libraries$") then
                        print('aaaaaaaaaaaaaaaaaaaaaa')
                        templateLibrariesPath = subdir
                        break
                    end
                end
                p:close()
            end
        end

        if settings.libraries and #settings.libraries > 0 then
            findLibraries(source)

            -- Dove copiare le librerie nel progetto
            -- percorso relativo della cartella libraries del template
            local projectLibraries
            if templateLibrariesPath then
                local relPath = templateLibrariesPath:gsub("/", "\\"):sub(#source + 2) -- "src\libraries"
                projectLibraries = destination .. "\\" .. relPath
            else
                projectLibraries = destination .. "\\libraries"
            end

            -- crea la cartella nel progetto, se non esiste
            os.execute('mkdir "' .. projectLibraries .. '" > nul 2>&1')

            -- copia le librerie selezionate dall'utente nel progetto
            if settings.libraries then
                for _, lib in ipairs(settings.libraries) do
                    local srcLib = settings.librariesPath .. "\\" .. lib.label
                    local dstLib = projectLibraries .. "\\" .. lib.label
                    -- normalizza dstLib per sicurezza
                    dstLib = dstLib:gsub("/", "\\")
                    copyFolder(srcLib, dstLib)
                end
            end
        end

        -- Vai alla pagina conferma creazione progetto
        app:switchTo(ProjectMadePage, {
            projectPath = projectPath,
            projectName = projectName
        })
    end

    local homePageUI = UI:new()

    -- TemplateButton
    local tb = {}
    tb.w = UI.SUB_BUTTON_WIDTH
    tb.h = UI.BUTTONS_HEIGHT
    tb.x = UI.CONTENT_MARGIN_X
    tb.y = app.VIRTUAL_HEIGHT - tb.h - UI.CONTENT_MARGIN_Y
    tb.label = 'TEMPLATE'
    tb.onclick = function()
        app:switchTo(TemplatePage)
    end

    local templateButton = Button:new(tb.x, tb.y, tb.w, tb.h, {
        label = tb.label,
        onclick = tb.onclick
    })
    homePageUI:addElement(templateButton)

    -- LibrariesButton
    local lb = {}
    lb.w = UI.SUB_BUTTON_WIDTH
    lb.h = UI.BUTTONS_HEIGHT
    lb.x = app.VIRTUAL_WIDTH - lb.w - UI.CONTENT_MARGIN_X
    lb.y = app.VIRTUAL_HEIGHT - lb.h - UI.CONTENT_MARGIN_Y
    lb.label = 'LIBRERIE'
    lb.onclick = function()
        app:switchTo(LibrariesPage)
    end

    local librariesButton = Button:new(lb.x, lb.y, lb.w, lb.h, {
        label = lb.label,
        onclick = lb.onclick
    })
    homePageUI:addElement(librariesButton)

    -- PathTextbox
    local pt = {}
    pt.w = 1500
    pt.h = 80
    pt.x = (app.VIRTUAL_WIDTH - pt.w) / 2
    pt.y = UI.CONTENT_MARGIN_Y

    local pathTextbox = Textbox:new(pt.x, pt.y, pt.w, pt.h, {
        text = projectPath,
        update = function(textbox, dt)
            projectPath = textbox.text
        end
    })
    homePageUI:addElement(pathTextbox)

    -- ProjectNameTextbox
    local pnt = {}
    pnt.w = 500
    pnt.h = 80
    pnt.x = (app.VIRTUAL_WIDTH - pnt.w) / 2
    pnt.y = (app.VIRTUAL_HEIGHT - pnt.h) / 3

    local projectNameTextbox = Textbox:new(pnt.x, pnt.y, pnt.w, pnt.h, {})
    homePageUI:addElement(projectNameTextbox)

    -- ProjectPathLabel
    local ppl = {}
    local label = 'Percorso Progetto'
    ppl.x = pathTextbox.x + (pathTextbox.w - fonts.default.label:getWidth(label)) / 2
    ppl.y = pathTextbox.y - fonts.default.label:getHeight() - 10

    local projectPathLabel = Label:new(ppl.x, ppl.y, {
        label = label
    })
    homePageUI:addElement(projectPathLabel)

    -- ErrorLabel
    local errorLabel = Label:new(0, 0, {
        label = '',
        color = { 1, 0, 0, 1 },
        visible = false,
        update = function(l, dt)
            errors:update(dt)
            l.visible = errors.show
            if errors.show then
                l.x = errors.x
                l.y = errors.y
                l.label = errors.error
            end
        end
    })
    homePageUI:addElement(errorLabel)

    -- ProjectNameLabel
    local pnl = {}
    local label = 'Nome Progetto'
    pnl.x = projectNameTextbox.x + (projectNameTextbox.w - fonts.default.label:getWidth(label)) / 2
    pnl.y = projectNameTextbox.y - fonts.default.label:getHeight() - 10

    local projectNameLabel = Label:new(pnl.x, pnl.y, {
        label = label
    })
    homePageUI:addElement(projectNameLabel)

    local cpb = {} -- CreateProjectButton
    cpb.w = UI.MAIN_BUTTON_WIDTH
    cpb.h = UI.BUTTONS_HEIGHT
    cpb.x = (app.VIRTUAL_WIDTH - cpb.w) / 2
    cpb.y = app.VIRTUAL_HEIGHT - cpb.h - UI.CONTENT_MARGIN_Y
    cpb.label = 'CREA PROGETTO'
    cpb.onclick = function()
        newProject(pathTextbox.text, projectNameTextbox.text)
    end

    local createProjectButton = Button:new(cpb.x, cpb.y, cpb.w, cpb.h, {
        label = cpb.label,
        onclick = cpb.onclick
    })
    homePageUI:addElement(createProjectButton)

    return homePageUI, 'homepage'
end

return HomePage
