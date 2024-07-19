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
    self.sprintSpeed = 15
    self.acceleration = 10
    self.midarAccelerationMultiplier = 0.2

    self.jumpForce = 20
    self.jumpMinStamina = 5
    self.jumpStaminaCost = 4
    self.prevJump = false
    self.jumpCounter = 0
    self.lastJumped = 0
    self.jumpDebounce = 0.2
    self.maxJumpsBeforeGround = 2
    self.isGrounded = false
    self.prevGrounded = false

    self.isSprinting = false
    self.prevSprinting = false
    self.isSprintKeyHeld = false
    self.prevSprintKeyHeld = false

    self.maxStamina = 100
    self.stamina = self.maxStamina
    self.staminaRegen = 10
    self.staminaDepletion = 2
    self.sprintMinStamina = 2

    self.isDashing = false
    self.startedDashing = 0
    self.dashMinStamina = 2
    self.dashSpeed = 40
    self.dashDuration = 0.2
end

function Player:update(dt, entities)
    if self.anchored then return end

    local velocityIncrease = (love.keyboard.isDown('a') and -1 or 0) + (love.keyboard.isDown('d') and 1 or 0)
    local jump = love.keyboard.isDown('w') and not self.prevJump and self.jumpCounter < self.maxJumpsBeforeGround and
        love.timer.getTime() - self.lastJumped >= self.jumpDebounce and
        self.stamina >= self.jumpMinStamina

    -- sprint
    if love.keyboard.isDown('lshift') then
        self.isSprintKeyHeld = true

        if not self.prevSprintKeyHeld then
            if self.isGrounded then
                self.isSprinting = self.stamina > self.sprintMinStamina
            else
                self.isDashing = self.stamina > self.dashMinStamina
                self.startedDashing = love.timer.getTime()
            end
        end
    else
        self.isSprinting = false
        self.isSprintKeyHeld = false
    end

    self.stamina = mathf.clamp(
        self.stamina +
        ((self.isSprinting and math.abs(velocityIncrease) > 0) and -self.staminaDepletion or self.staminaRegen) * dt,
        0,
        self.maxStamina)

    if self.stamina <= 0 then
        self.isSprinting = false
        self.stamina = 0
    end

    print("Stamina: " .. self.stamina)

    -- walk
    if self.isDashing then
        if love.timer.getTime() - self.startedDashing >= self.dashDuration then
            self.velocity = Vector2(self.isSprinting and self.sprintSpeed or self.speed, self.velocity.y)
            self.isDashing = false
        else
            local speed = self.dashSpeed
            self.velocity = Vector2(velocityIncrease * speed, self.velocity.y)
        end
    else
        local speed = self.isSprinting and self.sprintSpeed or self.speed
        self.velocity.x = mathf.approach(self.velocity.x, velocityIncrease * speed,
            speed * dt * (self.isGrounded and self.acceleration or self.acceleration * self.midarAccelerationMultiplier))
    end

    -- jump
    print(self.jumpCounter)
    if jump and not self.prevJump then
        self.jumpCounter = self.jumpCounter + 1
        self.lastJumped = love.timer.getTime()

        self.velocity.y = -self.jumpForce * self.stamina / self.maxStamina
        self.stamina = math.max(0, self.stamina - self.jumpStaminaCost)
    end

    if self.isGrounded and love.timer.getTime() - self.lastJumped >= self.jumpDebounce then
        self.jumpCounter = 0
    end

    self.prevJump = jump
    self.prevGrounded = self.isGrounded
    self.prevSprinting = self.isSprinting
    self.prevSprintKeyHeld = self.isSprintKeyHeld

    self:move(dt)
    self:physics(dt, entities)
end

function Player:move(dt)
    if not self.isGrounded then
        self:applyGravity(dt)
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
