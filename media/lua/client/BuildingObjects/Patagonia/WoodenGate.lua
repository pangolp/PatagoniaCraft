if not getPatagoniaCraftInstance then
  require('utils')
end

local PatagoniaCraft = getPatagoniaCraftInstance()

PatagoniaCraft.woodenGateMenuBuilder = function(subMenu, player)
  local _sprite
  local _option
  local _tooltip
  local _name = ''

  PatagoniaCraft.neededMaterials = {
    {
      Material = 'Base.Plank',
      Amount = 8
    },
    {
      Material = 'Base.Nails',
      Amount = 8
    },
    {
      Material = 'Base.Doorknob',
      Amount = 2
    },
    {
      Material = 'Base.Hinge',
      Amount = 4
    },
    {
      Material = 'Base.Screws',
      Amount = 8
    },
    {
      Material = 'Base.SmallSheetMetal',
      Amount = 4
    }
  }

  PatagoniaCraft.neededTools = {'Hammer', 'Screwdriver', 'Saw'}

  local needSkills = {
    Woodwork = 10
  }

  _sprite = {}
  _sprite.sprite = "fixtures_doors_fences_01_"

  _name = getText("ContextMenu_Wooden_Gate_Patagonian")

  _option = subMenu:addOption(_name, worldobjects, PatagoniaCraft.onDoubleWoodenDoor, square, _sprite, 104, player)
  _tooltip = PatagoniaCraft.canBuildObject(needSkills, _option, player)
  _tooltip:setName(_name)
  _tooltip.description = _tooltip.description
  _tooltip:setTexture(_sprite.sprite .. "105")
end

PatagoniaCraft.onDoubleWoodenDoor = function(worldobjects, square, sprite, spriteIndex, player)
  local _door = ISDoubleDoor:new(sprite.sprite, spriteIndex)
  _door.modData["xp:Woodwork"] = 6
  _door.modData["need:Base.Plank"] = "12"
  _door.modData["need:Base.Nails"] = "12"
  _door.modData["need:Base.Hinge"] = "4"
  _door.modData["need:Base.Doorknob"] = "2"
  _door.isThumpable = false
  _door.player = player
  _door.completionSound = "BuildWoodenStructureLarge"
  getCell():setDrag(_door, player)
end
