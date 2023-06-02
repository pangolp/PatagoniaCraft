if not getPatagoniaCraftInstance then
  require('utils')
end

local PatagoniaCraft = getPatagoniaCraftInstance()
local getText = getText

PatagoniaCraft.cratesMenuBuilder = function(subMenu, player)
  local _sprite
  local _option
  local _tooltip
  local _name = ''
  local _icon = ''

  PatagoniaCraft.neededMaterials = {
    {
      Material = 'Base.Plank',
      Amount = 9
    },
    {
      Material = 'Base.Nails',
      Amount = 9
    },
    {
      Material = 'Base.BlowTorch',
      Amount = 2
    },
    {
      Material = 'Base.WeldingRods',
      Amount = 2
    },
    {
      Material = 'Base.MetalPipe',
      Amount = 6
    },
    {
      Material = 'Base.SmallSheetMetal',
      Amount = 6
    },
    {
      Material = 'Base.SheetMetal',
      Amount = 6
    },
    {
      Material = 'Base.ScrapMetal',
      Amount = 3
    }
  }

  PatagoniaCraft.neededTools = {
    'Hammer',
    'BlowTorch',
    'WeldingMask'
  }

  local needSkills = {
    Woodwork = 10,
    MetalWelding = 10
  }

  _sprite = {}
  _sprite.sprite = 'patagonia_01_0'
  _sprite.northSprite = 'patagonia_01_0'

  _name = getText('ContextMenu_CratePatagonia')
  _icon = 'smallcrate'

  _option = subMenu:addOption(_name, nil, PatagoniaCraft.onBuildWoodenContainer, _sprite, player, _name, _icon)

  _tooltip = PatagoniaCraft.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)

  _tooltip.description = getText('Tooltip_CratePatagonia') .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)
end

PatagoniaCraft.onBuildWoodenContainer = function(ignoreThisArgument, sprite, player, name, icon)
  local _container = ISWoodenContainer:new(sprite.sprite, sprite.northSprite)

  _container.canPassThrough = true
  _container.renderFloorHelper = false
  _container.canBeAlwaysPlaced = false
  _container.player = player
  _container.name = name
  _container.icon = icon

  if sprite.eastSprite then
    _container:setEastSprite(sprite.eastSprite)
  end

  if sprite.southSprite then
    _container:setSouthSprite(sprite.southSprite)
  end

  _container.modData['need:Base.Plank'] = 9
  _container.modData['need:Base.Nails'] = 9
  _container.modData['need:Base.BlowTorch'] = 2
  _container.modData['need:Base.WeldingRods'] = 2
  _container.modData['need:Base.MetalPipe'] = 6
  _container.modData['need:Base.SmallSheetMetal'] = 6
  _container.modData['need:Base.SheetMetal'] = 6
  _container.modData['need:Base.ScrapMetal'] = 3

  function _container:getHealth()
    self.javaObject:getContainer():setType(icon)
    return PatagoniaCraft.healthLevel.metalDoor
  end

  getCell():setDrag(_container, player)
end
