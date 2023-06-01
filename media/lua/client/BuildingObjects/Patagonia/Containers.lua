if not getPatagoniaCraftInstance then
  require('utils')
end

local PatagoniaCraft = getPatagoniaCraftInstance()

PatagoniaCraft.cratesMenuBuilder = function(subMenu, player)
  local _sprite
  local _option
  local _tooltip
  local _name = ''
  local _icon = ''

  PatagoniaCraft.neededMaterials = {
    {
      Material = 'Base.Plank',
      Amount = 2
    },
    {
      Material = 'Base.Nails',
      Amount = 2
    }
  }

  PatagoniaCraft.neededTools = {'Hammer'}

  local needSkills = {
    Woodwork = PatagoniaCraft.skillLevel.simpleContainer
  }

  _sprite = {}
  _sprite.sprite = 'patagonia_01_0'
  _sprite.northSprite = 'patagonia_01_0'

  _name = getText('contextMenu_crate_patagonia')
  _icon = 'smallcrate'

  _option = subMenu:addOption(_name, nil, PatagoniaCraft.onBuildWoodenContainer, _sprite, player, _name, _icon)

  _tooltip = PatagoniaCraft.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)

  _tooltip.description = getText('tooltip_crate_patagonian') .. _tooltip.description
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

  _container.modData['need:Base.Plank'] = 2
  _container.modData['need:Base.Nails'] = 2
  _container.modData['xp:Woodwork'] = 5

  function _container:getHealth()
    self.javaObject:getContainer():setType(icon)
    return PatagoniaCraft.healthLevel.metalDoor
  end

  getCell():setDrag(_container, player)
end
