local ProjectMadePage = {}

function ProjectMadePage:new(params)
    projectPath, projectName = params.projectPath or '', params.projectName or ''
    local projectMadePageUI = UI:new()

    -- BackButton
    local backb = {}
    backb.w = UI.SUB_BUTTON_WIDTH
    backb.h = UI.BUTTONS_HEIGHT
    backb.x = UI.CONTENT_MARGIN_X
    backb.y = app.VIRTUAL_HEIGHT - backb.h - UI.CONTENT_MARGIN_Y
    backb.label = 'INDIETRO'
    backb.onclick = function()
        app:switchTo(HomePage)
    end

    local backButton = Button:new(backb.x, backb.y, backb.w, backb.h, {
        label = backb.label,
        onclick = backb.onclick
    })
    projectMadePageUI:addElement(backButton)

    -- OpenFolderButton
    local ofb = {}
    ofb.w = UI.MAIN_BUTTON_WIDTH
    ofb.h = UI.BUTTONS_HEIGHT
    ofb.x = (app.VIRTUAL_WIDTH - ofb.w) / 2
    ofb.y = app.VIRTUAL_HEIGHT - ofb.h - UI.CONTENT_MARGIN_Y
    ofb.label = 'APRI CARTELLA'
    ofb.onclick = function()
        os.execute('start "" "' .. projectPath .. '\\' .. projectName .. '"')
        app:switchTo(HomePage)
    end

    local openFolderButton = Button:new(ofb.x, ofb.y, ofb.w, ofb.h, {
        label = ofb.label,
        onclick = ofb.onclick
    })
    projectMadePageUI:addElement(openFolderButton)

    -- ProjectMadeLabel
    local pml = {}
    local label = 'Il progetto "' .. projectName .. '" è stato creato!'
    pml.x = (app.VIRTUAL_WIDTH - fonts.default.projectMadeLabel:getWidth(label)) / 2
    pml.y = UI.CONTENT_MARGIN_Y

    local projectPathLabel = Label:new(pml.x, pml.y, {
        label = label,
        font = fonts.default.projectMadeLabel
    })
    projectMadePageUI:addElement(projectPathLabel)

    return projectMadePageUI, 'projectmadepage'
end

return ProjectMadePage
