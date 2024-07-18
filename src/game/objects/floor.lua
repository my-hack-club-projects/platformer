local oo = require 'libs.oo'
local Entity = require 'libs.entity'
local Color4 = require 'types.color4'

local Floor = oo.class(Entity)

function Floor:init()
    Entity.init(self)

    self.x = 0
    self.y = 0
    self.size.x = 1000
    self.size.y = 1
    self.color = Color4(0.5, 0.5, 0.5, 1)
end

return Floor
