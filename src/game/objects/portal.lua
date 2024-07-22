local oo = require 'libs.oo'
local Entity = require 'libs.entity'
local Signal = require 'libs.signal'

local Portal = oo.class(Entity)

function Portal:init(...)
    Entity.init(self, ...)

    self.touchWhitelist = { "Player" }
    self.playerTouched = Signal()
end

function Portal:update(dt, entities)
    self:physics(dt, entities)
end

function Portal:physics(dt, entities)
    local entity, _ = Entity.physics(self, dt, entities)

    if entity and entity.name == "Player" then
        self.playerTouched:dispatch()
    end
end

return Portal
