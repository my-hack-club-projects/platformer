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
    local velocityIncrease = (love.keyboard.isDown('a') and -1 or 0) + (love.keyboard.isDown('d') and 1 or 0)
    local jump = love.keyboard.isDown('w') and not self.prevJump and self.isGrounded

    -- walk
    self.velocity.x = mathf.approach(self.velocity.x, velocityIncrease * self.speed, self.speed * dt * self.acceleration)

    -- jump
    if jump then
        self.velocity.y = -self.jumpForce
    end

    self.prevJump = jump

    Entity.update(self, dt, entities)
end

function Player:physics(dt, entities)
    local isGrounded = false

    for i, entity in ipairs(entities) do
        if entity ~= self then
            if self:collides(entity) then
                local yPenetration = math.abs(self.position.y - entity.position.y) - (self.size.y + entity.size.y) / 2
                local direction = mathf.sign(entity.position.y - self.position.y)

                self.position.y = self.position.y + yPenetration * direction

                if direction > 0 then
                    isGrounded = true
                else
                    self.velocity.y = 0
                end

                break
            end
        end
    end

    if not isGrounded then
        self.velocity.y = self.velocity.y + self.gravity * dt
    elseif self.velocity.y > 0 then
        self.velocity.y = 0
    end

    self.position = self.position + self.velocity * dt

    self.isGrounded = isGrounded
end

return Player
