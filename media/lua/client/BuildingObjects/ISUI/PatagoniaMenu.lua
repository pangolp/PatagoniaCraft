if not getPatagoniaCraftInstance then
  require('utils')
end

local PatagoniaCraft = getPatagoniaCraftInstance()

PatagoniaCraft.OnFillWorldObjectContextMenu = function(player, context, worldobjects, test)

    if getCore():getGameMode() == 'LastStand' then return end

    if test and ISWorldObjectContextMenu.Test then return true end

    local _player = getSpecificPlayer(player)
    if _player:getVehicle() then return end

    PatagoniaCraft.buildSkillsList(_player)

    local _mainMenu = context:addOption(getText('ContextMenu_Patagonia'))
    local _containerMenu = ISContextMenu:getNew(context)
    context:addSubMenu(_mainMenu, _containerMenu)

    local _containerOption = _containerMenu:addOption(getText('ContextMenu_Container'))
    local _crateMenu = _containerMenu:getNew(_containerMenu)
    context:addSubMenu(_containerOption, _crateMenu)
    PatagoniaCraft.cratesMenuBuilder(_crateMenu, player)

    local _architectureOption = _containerMenu:addOption(getText('ContextMenu_Architecture'))
    local _wallMenu = _containerMenu:getNew(_containerMenu)
    context:addSubMenu(_architectureOption, _wallMenu)
    PatagoniaCraft.wallsMenuBuilder(_wallMenu, player)
end

Events.OnFillWorldObjectContextMenu.Add(PatagoniaCraft.OnFillWorldObjectContextMenu)
