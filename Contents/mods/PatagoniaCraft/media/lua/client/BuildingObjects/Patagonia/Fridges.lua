if not getPatagoniaCraftInstance then
  require('utils')
end

local PatagoniaCraft = getPatagoniaCraftInstance()

PatagoniaCraft.fridgeMenuBuilder = function(subMenu, player)
  local _sprite
  local _option
  local _tooltip
  local _name = ''
  local _icon = ''

  PatagoniaCraft.neededMaterials = {
    { Material = 'Base.SheetMetal', Amount = 7 },
    { Material = 'Base.Screws', Amount = 20 },
    { Material = 'Radio.ElectricWire', Amount = 5 },
    { Material = 'Base.ElectronicsScrap', Amount = 25 },
    { Material = 'Base.BlowTorch', Amount = 5 },
    { Material = 'Base.WeldingRods', Amount = 5 }
  }

  PatagoniaCraft.neededTools = { 'Hammer', 'BlowTorch', 'WeldingMask' }

  local needSkills = {
    Woodwork = 10,
    MetalWelding = 2
  }

  _sprite = {}
  _sprite.sprite = 'appliances_refrigeration_01_4'
  _sprite.northSprite = 'appliances_refrigeration_01_5'
  _sprite.eastSprite = 'appliances_refrigeration_01_6'
  _sprite.southSprite = 'appliances_refrigeration_01_7'

  _name = getText('ContextMenu_BlueFridge')
  _icon = 'fridge'

  _option = subMenu:addOption(_name, nil, PatagoniaCraft.onBuildFridge, _sprite, player, _name, _icon)

  _tooltip = PatagoniaCraft.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)

  _tooltip.description = getText('Tooltip_BlueFridge') .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)
end

PatagoniaCraft.onBuildFridge = function(ignoreThisArgument, sprite, player, name, icon)
  local _fridge = ISFridge:new(player, name, sprite.sprite, sprite.northSprite)

  _fridge.player = player
  _fridge.name = name
  _fridge.icon = icon

  if sprite.eastSprite then
    _fridge:setEastSprite(sprite.eastSprite)
  end

  if sprite.southSprite then
    _fridge:setSouthSprite(sprite.southSprite)
  end

  _fridge.modData['need:Base.SheetMetal'] = 7
  _fridge.modData['need:Base.Screws'] = 20
  _fridge.modData['need:Radio.ElectricWire'] = 5
  _fridge.modData['need:Base.ElectronicsScrap'] = 25
  _fridge.modData['need:Base.BlowTorch'] = 5
  _fridge.modData['need:Base.WeldingRods'] = 5

  function _fridge:getHealth()
    self.javaObject:getContainer():setType(icon)
    return PatagoniaCraft.healthLevel.metalDoor
  end

  getCell():setDrag(_fridge, player)
end
