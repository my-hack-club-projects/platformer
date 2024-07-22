local oo = require 'libs.oo'
local Entity = require 'libs.entity'
local Signal = require 'libs.signal'

local Lava = oo.class(Entity)

function Lava:init(...)
    Entity.init(self, ...)

    self.collide = false
    self.anchored = true

    self.riseSpeed = 0.5
    self.maxSize = 0
    self.positionOffset = 0

    self.touchWhitelist = { "Player" }
    self.playerTouched = Signal()

    self.touched:connect(function(entity)
        if entity.name == "Player" then
            self.playerTouched:dispatch()
        end
    end)
end

function Lava:update(dt, entities)
    if self.size.y > self.maxSize then
        return
    end

    self.size.y = self.size.y + self.riseSpeed * dt
    self.position.y = -self.size.y / 2 + self.positionOffset

    self:physics(dt, entities)
end

return Lava
