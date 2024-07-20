local oo = require 'libs.oo'
local Entity = require 'libs.entity'

local Walls = oo.class()

function Walls:init(width, height)
    self.width = width
    self.height = height

    self.walls = {
        Entity(),
        Entity()
    }

    for i, wall in ipairs(self.walls) do
        wall.size.x = 1
        wall.size.y = height
        wall.position.x = (i == 1 and -1 or 1) * (width / 2)
        wall.position.y = -height / 2
        wall.anchored = true
        wall.collide = true
    end
end

return Walls
