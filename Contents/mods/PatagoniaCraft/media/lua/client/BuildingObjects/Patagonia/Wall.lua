if not getPatagoniaCraftInstance then
  require('utils')
end

local PatagoniaCraft = getPatagoniaCraftInstance()

PatagoniaCraft.wallsMenuBuilder = function(subMenu, player)
  local _sprite
  local _option
  local _tooltip
  local _name = ''

  PatagoniaCraft.neededMaterials = {
    {
      Material = 'Base.ConcretePowder',
      Amount = 1
    },
    {
      Material = 'Base.Gravelbag',
      Amount = 1
    },
    {
      Material = 'Base.MetalBar',
      Amount = 4
    },
    {
      Material = 'Base.Wire',
      Amount = 2
    },
    {
      Material = 'Base.Stone',
      Amount = 5
    },
    {
      Material = 'Base.BucketWaterFull',
      Amount = 1
    }
  }

  PatagoniaCraft.neededTools = {'Hammer', 'HandShovel'}

  local needSkills = {
    Woodwork = 10
  }

  _sprite = {}
  _sprite.sprite = 'patagonia_01_3'
  _sprite.northSprite = 'patagonia_01_4'
  _sprite.corner = ''

  _name = getText('ContextMenu_Wall_Patagonian')

  _option = subMenu:addOption(_name, nil, PatagoniaCraft.onBuildWoodenWall, _sprite, player, _name)

  _tooltip = PatagoniaCraft.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = getText('Tooltip_WallPatagonian') .. _tooltip.description
  _tooltip:setTexture(_sprite.sprite)
end

PatagoniaCraft.onBuildWoodenWall = function(ignoreThisArgument, sprite, player, name)
  local _wall = ISWoodenWall:new(sprite.sprite, sprite.northSprite, sprite.corner)
  _wall.isThumpable = false
  _wall.canBarricade = false
  _wall.player = player
  _wall.name = name

  _wall.modData['need:Base.ConcretePowder'] = 1
  _wall.modData['need:Base.Gravelbag'] = 1
  _wall.modData['need:Base.MetalBar'] = 4
  _wall.modData['need:Base.Wire'] = 2
  _wall.modData['need:Base.Stone'] = 5
  _wall.modData['need:Base.BucketWaterFull'] = 1
  _wall.modData['wallType'] = 'wall'

  getCell():setDrag(_wall, player)
end
