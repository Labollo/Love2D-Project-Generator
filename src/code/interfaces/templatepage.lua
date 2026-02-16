local TemplatePage = {}

function TemplatePage:new(params)
    local templatePageUI = UI:new()

    -- BackButton
    local backb = {}
    backb.w = UI.SUB_BUTTON_WIDTH
    backb.h = UI.BUTTONS_HEIGHT
    backb.x = (app.VIRTUAL_WIDTH - backb.w) / 2
    backb.y = app.VIRTUAL_HEIGHT - backb.h - UI.CONTENT_MARGIN_Y
    backb.label = 'INDIETRO'
    backb.onclick = function()
        app:switchTo(HomePage)
    end

    local backButton = Button:new(backb.x, backb.y, backb.w, backb.h, {
        label = backb.label,
        onclick = backb.onclick
    })
    templatePageUI:addElement(backButton)

    -- TemplatesPathTextbox
    local tpt = {}
    tpt.w = 1500
    tpt.h = 80
    tpt.x = (app.VIRTUAL_WIDTH - tpt.w) / 2
    tpt.y = UI.CONTENT_MARGIN_Y

    local templatesPathTextbox = Textbox:new(tpt.x, tpt.y, tpt.w, tpt.h, {
        alignText = 'center',
        text = SavedPaths:get("templatesPath") or ""
    })
    templatePageUI:addElement(templatesPathTextbox)

    -- ProjectPathLabel
    local ppl = {}
    local label = 'Percorso Template'
    ppl.x = templatesPathTextbox.x + (templatesPathTextbox.w - fonts.default.label:getWidth(label)) / 2
    ppl.y = templatesPathTextbox.y - fonts.default.label:getHeight() - 10

    local projectPathLabel = Label:new(ppl.x, ppl.y, {
        label = label
    })
    templatePageUI:addElement(projectPathLabel)

    -- TemplatesList
    local tl = {}
    tl.w = 650
    tl.h = 560
    tl.x = (app.VIRTUAL_WIDTH - tl.w) / 2
    tl.y = UI.CONTENT_MARGIN_Y * 2 + tpt.h

    local templatesList = List:new(tl.x, tl.y, tl.w, tl.h, {
        options = {},
        optionHeight = 100,
        multipleChoice = false,
        required = true,
        optionOnclick = function(list)
            settings.template = list:getSelectedOptions()
        end,
    })
    if templatesPathTextbox.text ~= "" then
        local ok, folders = pcall(getTemplatesFolders, templatesPathTextbox.text)
        if ok then
            templatesList:setOptions(folders)
            settings.template = templatesList:getSelectedOptions()
            settings.templatePath = templatesPathTextbox.text
        end
    end
    templatePageUI:addElement(templatesList)

    -- SearchButton
    local searchb = {}
    searchb.w = UI.SEARCH_BUTTON_WIDTH
    searchb.h = UI.SEARCH_BUTTON_HEIGHT
    searchb.x = templatesPathTextbox.x + templatesPathTextbox.w - searchb.w
    searchb.y = templatesPathTextbox.y + templatesPathTextbox.h + UI.CONTENT_MARGIN_Y / 2
    searchb.label = 'CERCA'
    searchb.onclick = function()
        local path = templatesPathTextbox.text
        if path == '' then
            errors:set('Non hai inserito il percorso dei template!', UI.ERRORS_Y_OTHER_PAGES)
            return
        end
        SavedPaths:set("templatesPath", path)

        local ok, folders = pcall(getTemplatesFolders, path)
        if ok and #folders > 0 then
            templatesList:setOptions(folders)
            settings.template = templatesList:getSelectedOptions()
            settings.templatePath = templatesPathTextbox.text
        else
            errors:set('Il percorso inserito non è valido!', UI.ERRORS_Y_OTHER_PAGES)
        end
    end

    local searchButton = Button:new(searchb.x, searchb.y, searchb.w, searchb.h, {
        label = searchb.label,
        onclick = searchb.onclick
    })
    templatePageUI:addElement(searchButton)

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
    templatePageUI:addElement(errorLabel)

    return templatePageUI, 'templatepage'
end

return TemplatePage
