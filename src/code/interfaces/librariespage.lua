local LibrariesPage = {}

function LibrariesPage:new(params)
    local librariesPageUI = UI:new()

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
    librariesPageUI:addElement(backButton)

    -- LibrariesPathTextbox
    local lpt = {}
    lpt.w = 1500
    lpt.h = 80
    lpt.x = (app.VIRTUAL_WIDTH - lpt.w) / 2
    lpt.y = UI.CONTENT_MARGIN_Y

    local librariesPathTextbox = Textbox:new(lpt.x, lpt.y, lpt.w, lpt.h, {
        alignText = 'center',
        text = SavedPaths:get("librariesPath") or ""
    })
    librariesPageUI:addElement(librariesPathTextbox)

    -- LibrariesPathLabel
    local lpl = {}
    local label = 'Percorso Librerie'
    lpl.x = librariesPathTextbox.x + (librariesPathTextbox.w - fonts.default.label:getWidth(label)) / 2
    lpl.y = librariesPathTextbox.y - fonts.default.label:getHeight() - 10

    local projectPathLabel = Label:new(lpl.x, lpl.y, {
        label = label
    })
    librariesPageUI:addElement(projectPathLabel)

    -- LibrariesList
    local ll = {}
    ll.w = 650
    ll.h = 600
    ll.x = (app.VIRTUAL_WIDTH - ll.w) / 2
    ll.y = UI.CONTENT_MARGIN_Y * 2 + lpt.h

    local librariesList = List:new(ll.x, ll.y, ll.w, ll.h, {
        options = {},
        optionHeight = 70,
        multipleChoice = true,
        optionOnclick = function(list)
            settings.libraries = list:getSelectedOptions()
        end
    })
    if librariesPathTextbox.text ~= "" then
        local ok, folders = pcall(getLibrariesFolders, librariesPathTextbox.text)
        if ok then
            librariesList:setOptions(folders)
            settings.libraries = librariesList:getSelectedOptions()
            settings.librariesPath = librariesPathTextbox.text
        end
    end
    librariesPageUI:addElement(librariesList)

    -- SearchButton
    local searchb = {}
    searchb.w = UI.SEARCH_BUTTON_WIDTH
    searchb.h = UI.SEARCH_BUTTON_HEIGHT
    searchb.x = librariesPathTextbox.x + librariesPathTextbox.w - searchb.w
    searchb.y = librariesPathTextbox.y + librariesPathTextbox.h + UI.CONTENT_MARGIN_Y / 2
    searchb.label = 'CERCA'
    searchb.onclick = function()
        local path = librariesPathTextbox.text
        if path == '' then
            errors:set('Non hai inserito il percorso delle librerie!', UI.ERRORS_Y_OTHER_PAGES)
            return
        end
        SavedPaths:set("librariesPath", path)

        local ok, folders = pcall(getLibrariesFolders, path)
        if ok and #folders > 0 then
            librariesList:setOptions(folders)
            settings.libraries = librariesList:getSelectedOptions()
            settings.librariesPath = librariesPathTextbox.text
        else
            errors:set('Il percorso inserito non è valido!', UI.ERRORS_Y_OTHER_PAGES)
        end
    end

    local searchButton = Button:new(searchb.x, searchb.y, searchb.w, searchb.h, {
        label = searchb.label,
        onclick = searchb.onclick
    })
    librariesPageUI:addElement(searchButton)

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
    librariesPageUI:addElement(errorLabel)

    return librariesPageUI, 'librariespage'
end

return LibrariesPage
