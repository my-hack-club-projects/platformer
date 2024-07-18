local oo = require 'libs.oo'
local Entity = require 'libs.entity'

local DemoEntity = oo.class(Entity)

function DemoEntity:init(name)
    Entity.init(self, name)

    self.size.x = 10
    self.size.y = 10
end

function DemoEntity:update(dt)
    Entity.update(self, dt)

    -- self.position.x = self.position.x + 1 * dt
end

return DemoEntity
