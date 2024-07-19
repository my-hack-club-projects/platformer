local oo = require 'libs.oo'
local mathf = require 'libs.mathf'
local Color4 = require 'types.color4'
local Vector2 = require 'types.vector2'
local Entity = require 'libs.entity'

local Player = oo.class(Entity)

function Player:init(game)
    Entity.init(self, game)

    self.position = Vector2(0, -1)
    self.size.x = 1
    self.size.y = 1
    self.color = Color4(1, 1, 1, 1)

    self.speed = 5 -- units per second
    self.acceleration = 10

    self.velocity = Vector2(0, 0)
end

function Player:update(dt)
    local velocityIncrease = (love.keyboard.isDown('a') and -1 or 0) + (love.keyboard.isDown('d') and 1 or 0)

    self.velocity.x = mathf.approach(self.velocity.x, velocityIncrease * self.speed, self.speed * dt * self.acceleration)

    self.position = self.position + self.velocity * dt
end

return Player
