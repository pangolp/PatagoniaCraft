local PatagoniaCraft = {}

local getSpecificPlayer = getSpecificPlayer
local pairs = pairs
local split = string.split
local getItemNameFromFullType = getItemNameFromFullType
local PerkFactory = PerkFactory
local getMoveableDisplayName = Translator.getMoveableDisplayName
local getSprite = getSprite
local getText = getText

PatagoniaCraft.neededMaterials = {}
PatagoniaCraft.neededTools = {}
PatagoniaCraft.toolsList = {}
PatagoniaCraft.playerSkills = {}
PatagoniaCraft.textSkillsRed = {}
PatagoniaCraft.textSkillsGreen = {}
PatagoniaCraft.playerCanPlaster = false
PatagoniaCraft.textTooltipHeader = ' <RGB:2,2,2> <LINE> <LINE>' .. getText('Tooltip_craft_Needs') .. ' : <LINE> '
PatagoniaCraft.textCanRotate = '<LINE> <RGB:1,1,1>' .. getText('Tooltip_craft_pressToRotate', Keyboard.getKeyName(getCore():getKey('Rotate building')))
PatagoniaCraft.textPlasterRed = '<RGB:1,0,0> <LINE> <LINE>' .. getText('Tooltip_PlasterRed_Description')
PatagoniaCraft.textPlasterGreen = '<RGB:1,1,1> <LINE> <LINE>' .. getText('Tooltip_PlasterGreen_Description')
PatagoniaCraft.textPlasterNever = '<RGB:1,0,0> <LINE> <LINE>' .. getText('Tooltip_PlasterNever_Description')

PatagoniaCraft.textWallDescription = getText('Tooltip_Wall_Description')
PatagoniaCraft.textPillarDescription = getText('Tooltip_Pillar_Description')
PatagoniaCraft.textDoorFrameDescription = getText('Tooltip_DoorFrame_Description')
PatagoniaCraft.textWindowFrameDescription = getText('Tooltip_WindowFrame_Description')
PatagoniaCraft.textFenceDescription = getText('Tooltip_Fence_Description')
PatagoniaCraft.textFencePostDescription = getText('Tooltip_FencePost_Description')
PatagoniaCraft.textDoorGenericDescription = getText('Tooltip_craft_woodenDoorDesc')
PatagoniaCraft.textDoorIndustrial = getText('Tooltip_DoorIndustrial_Description')
PatagoniaCraft.textDoorExterior = getText('Tooltip_DoorExterior_Description')
PatagoniaCraft.textStairsDescription = getText('Tooltip_craft_stairsDesc')
PatagoniaCraft.textFloorDescription = getText('Tooltip_Floor_Description')
PatagoniaCraft.textBarElementDescription = getText('Tooltip_BarElement_Description')
PatagoniaCraft.textBarCornerDescription = getText('Tooltip_BarCorner_Description')
PatagoniaCraft.textTrashCanDescription = getText('Tooltip_TrashCan_Description')
PatagoniaCraft.textLightPoleDescription = getText('Tooltip_LightPole_Description')
PatagoniaCraft.textSmallTableDescription = getText('Tooltip_SmallTable_Description')
PatagoniaCraft.textLargeTableDescription = getText('Tooltip_LargeTable_Description')
PatagoniaCraft.textCouchFrontDescription = getText('Tooltip_CouchFront_Description')
PatagoniaCraft.textCouchRearDescription = getText('Tooltip_CouchRear_Description')
PatagoniaCraft.textDresserDescription = getText('Tooltip_Dresser_Description')
PatagoniaCraft.textBedDescription = getText('Tooltip_Bed_Description')
PatagoniaCraft.textFlowerBedDescription = getText('Tooltip_FlowerBed_Description')

PatagoniaCraft.toolsList['Hammer'] = {'Base.Hammer', 'Base.HammerStone', 'Base.BallPeenHammer', 'Base.WoodenMallet', 'Base.ClubHammer'}
PatagoniaCraft.toolsList['Screwdriver'] = {'Base.Screwdriver'}
PatagoniaCraft.toolsList['HandShovel'] = {'farming.HandShovel'}
PatagoniaCraft.toolsList['Saw'] = {'Base.Saw'}
PatagoniaCraft.toolsList['Shovel'] = {'Base.Shovel', 'Base.Shovel2'}
PatagoniaCraft.toolsList['BlowTorch'] = {'Base.BlowTorch'}

PatagoniaCraft.skillLevel = {
  simpleObject = 1,
  waterwellObject = 7,
  simpleDecoration = 1,
  landscaping = 1,
  lighting = 4,
  simpleContainer = 3,
  complexContainer = 5,
  advancedContainer = 7,
  simpleFurniture = 3,
  basicContainer = 1,
  basicFurniture = 1,
  moderateFurniture = 2,
  counterFurniture = 3,
  complexFurniture = 4,
  logObject = 0,
  floorObject = 1,
  wallObject = 2,
  doorObject = 3,
  garageDoorObject = 6,
  stairsObject = 6,
  stoneArchitecture = 5,
  metalArchitecture = 5,
  architecture = 5,
  complexArchitecture = 5,
  nearlyimpossible = 5,
  barbecueObject = 4,
  fridgeObject = 3,
  lightingObject = 2,
  generatorObject = 3,
  windowsObject = 2
}

PatagoniaCraft.healthLevel = {
  stoneWall = 300,
  metalWall = 700,
  metalStairs = 400,
  woodContainer = 200,
  stoneContainer = 250,
  metalContainer = 350,
  wallDecoration = 50,
  woodenFence = 100,
  metalDoor = 700
}

local function predicateNotBroken(item)
  return not item:isBroken()
end

PatagoniaCraft.getMoveableDisplayName = function(sprite)
  local props = getSprite(sprite):getProperties()
  if props:Is('CustomName') then
    local name = props:Val('CustomName')
    if props:Is('GroupName') then
      name = props:Val('GroupName') .. ' ' .. name
    end
    return getMoveableDisplayName(name)
  end
end

PatagoniaCraft.buildSkillsList = function(player)
  local perks = PerkFactory.PerkList
  local perkID = nil
  local perkType = nil
  for i = 0, perks:size() - 1 do
    perkID = perks:get(i):getId()
    perkType = perks:get(i):getType()
    PatagoniaCraft.playerSkills[perkID] = player:getPerkLevel(perks:get(i))
    PatagoniaCraft.textSkillsRed[perkID] = ' <RGB:1,0,0>' .. PerkFactory.getPerkName(perkType) .. ' ' .. PatagoniaCraft.playerSkills[perkID] .. '/'
    PatagoniaCraft.textSkillsGreen[perkID] = ' <RGB:1,1,1>' .. PerkFactory.getPerkName(perkType) .. ' '
  end
end

PatagoniaCraft.tooltipCheckForMaterial = function(inv, material, amount, tooltip)
  local type = split(material, '\\.')[2]
  local invItemCount = 0
  local groundItem = ISBuildMenu.materialOnGround
  if amount > 0 then
    invItemCount = inv:getItemCountFromTypeRecurse(material)

    if material == "Base.Nails" then
      invItemCount = invItemCount + inv:getItemCountFromTypeRecurse("Base.NailsBox") * 100
      if groundItem["Base.NailsBox"] then
        invItemCount = invItemCount + groundItem["Base.NailsBox"] * 100
      end
    end

    for groundItemType, groundItemCount in pairs(groundItem) do
      if groundItemType == type then
        invItemCount = invItemCount + groundItemCount
      end
    end

    if invItemCount < amount then
      tooltip.description = tooltip.description .. ' <RGB:1,0,0>' .. getItemNameFromFullType(material) .. ' ' .. invItemCount .. '/' .. amount .. ' <LINE>'
      return false
    else
      tooltip.description = tooltip.description .. ' <RGB:1,1,1>' .. getItemNameFromFullType(material) .. ' ' .. invItemCount .. '/' .. amount .. ' <LINE>'
      return true
    end
  end
end

PatagoniaCraft.tooltipCheckForTool = function(inv, tool, tooltip)
  local tools = PatagoniaCraft.getAvailableTools(inv, tool)
  if tools then
    tooltip.description = tooltip.description .. ' <RGB:1,1,1>' .. tools:getName() .. ' <LINE>'
    return true
  else
    for _, type in pairs (PatagoniaCraft.toolsList[tool]) do
      tooltip.description = tooltip.description .. ' <RGB:1,0,0>' .. getItemNameFromFullType(type) .. ' <LINE>'
      return false
    end
  end
end

PatagoniaCraft.canBuildObject = function(skills, option, player)
  local _tooltip = ISToolTip:new()
  _tooltip:initialise()
  _tooltip:setVisible(false)
  option.toolTip = _tooltip

  local inv = getSpecificPlayer(player):getInventory()

  local _canBuildResult = true

  _tooltip.description = PatagoniaCraft.textTooltipHeader

  local _currentResult = true

  for _, _currentMaterial in pairs(PatagoniaCraft.neededMaterials) do
    if _currentMaterial['Material'] and _currentMaterial['Amount'] then
      _currentResult = PatagoniaCraft.tooltipCheckForMaterial(inv, _currentMaterial['Material'], _currentMaterial['Amount'], _tooltip)
    else
      _tooltip.description = _tooltip.description .. ' <RGB:1,0,0> Error in required material definition. <LINE>'
      _canBuildResult = false
    end

    if not _currentResult then
      _canBuildResult = false
    end
  end

  for _, _currentTool in pairs(PatagoniaCraft.neededTools) do
    _currentResult = PatagoniaCraft.tooltipCheckForTool(inv, _currentTool, _tooltip)

    if not _currentResult then
      _canBuildResult = false
    end
  end

  for skill, level in pairs (skills) do
    if (PatagoniaCraft.playerSkills[skill] < level) then
      _tooltip.description = _tooltip.description .. PatagoniaCraft.textSkillsRed[skill]
      _canBuildResult = false
    else
      _tooltip.description = _tooltip.description .. PatagoniaCraft.textSkillsGreen[skill]
    end
    _tooltip.description = _tooltip.description .. level .. ' <LINE>'
  end

  if not _canBuildResult and not ISBuildMenu.cheat then
    option.onSelect = nil
    option.notAvailable = true
  end
  return _tooltip
end

PatagoniaCraft.checkPermission = function(player)
  local level = player:getAccessLevel()
  local permission = SandboxVars.PatagoniaCraft.BuildingPermission
  return isClient() and not ISBuildMenu.cheat and PatagoniaCraft.AccessLevel[level] < permission
end

PatagoniaCraft.haveAToolToBuild = function(inv)
  local havaTools = nil
  havaTools = PatagoniaCraft.getAvailableTools(inv, 'Hammer')
  return havaTools or ISBuildMenu.cheat
end

PatagoniaCraft.getAvailableTools = function(inv, tool)
  local tools = nil
  local toolList = PatagoniaCraft.toolsList[tool]
  for _, type in pairs (toolList) do
    tools = inv:getFirstTypeEval(type, predicateNotBroken)
    if tools then
      return tools
    end
  end
end

function getPatagoniaCraftInstance()
  return PatagoniaCraft
end
