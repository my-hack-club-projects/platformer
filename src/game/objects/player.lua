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

    self.jumpForce = 10
    self.prevJump = false
    self.isGrounded = false
end

function Player:update(dt, entities)
    if self.anchored then return end

    local velocityIncrease = (love.keyboard.isDown('a') and -1 or 0) + (love.keyboard.isDown('d') and 1 or 0)
    local jump = love.keyboard.isDown('w') and not self.prevJump and self.isGrounded

    -- walk
    self.velocity.x = mathf.approach(self.velocity.x, velocityIncrease * self.speed, self.speed * dt * self.acceleration)

    -- jump
    if jump then
        self.velocity.y = -self.jumpForce
    end

    self.prevJump = jump

    self:move(dt)
    self:physics(dt, entities)
end

function Player:move(dt)
    if not self.isGrounded then
        self.velocity.y = self.velocity.y + self.gravity * dt
    elseif self.velocity.y > 0 then
        self.velocity.y = 0
    end

    self.position = self.position + self.velocity * dt
end

function Player:physics(dt, entities)
    local entity, penetration = Entity.physics(self, dt, entities)

    self.isGrounded = entity and penetration
        and (penetration.x > penetration.y)
        and self.position.y < entity.position.y
end

return Player
