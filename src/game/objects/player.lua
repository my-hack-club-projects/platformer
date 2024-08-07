local oo = require 'libs.oo'
local mathf = require 'libs.mathf'
local Color4 = require 'types.color4'
local Vector2 = require 'types.vector2'
local Entity = require 'libs.entity'
local Signal = require 'libs.signal'

local Player = oo.class(Entity)

function Player:init(game)
    Entity.init(self, game)

    self.position = Vector2(0, -1)
    self.size.x = 1
    self.size.y = 1
    self.color = Color4(1, 1, 1, 1)

    self.colliderSizeOffset = Vector2(0.1, 0.1)

    self.collider = Entity()
    self.collider.position = self.position -- Reference
    self.collider.size = self.size + self.colliderSizeOffset
    self.collider.anchored = true
    self.collider.collide = false
    self.collider.color = Color4(1, 0, 0, 0.5)

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

    self.maxStamina = 25
    self.stamina = self.maxStamina
    self.staminaRegen = 8
    self.staminaDepletion = 2 -- unused, was for sprinting
    self.sprintMinStamina = 2

    self.isDashing = false
    self.canDash = false
    self.startedDashing = 0
    self.dashDirection = 0
    self.dashMinStamina = 5
    self.dashStaminaCost = 5
    self.dashSpeed = 40
    self.dashDuration = 0.2

    self.trailEnabled = false
    self.trailPositions = {}
    self.trailMaxSize = 20
    self.trailCreateInterval = 0.01
    self.lastTrailCreated = 0

    self.signals = {
        landed = Signal(),
        jumped = Signal(),
        dashed = Signal(),
        noStamina = Signal(),
    }
end

function Player:update(dt, entities)
    if self.anchored then return end

    local velocityIncrease = (love.keyboard.isDown('a') and -1 or 0) + (love.keyboard.isDown('d') and 1 or 0)
    local jump = love.keyboard.isDown('w') and not self.prevJump and self.jumpCounter < self.maxJumpsBeforeGround and
        love.timer.getTime() - self.lastJumped >= self.jumpDebounce

    if jump and self.stamina < self.jumpMinStamina then
        jump = false
        self.signals.noStamina:dispatch()
    end

    -- sprint
    if love.keyboard.isDown('lshift') then
        self.isSprintKeyHeld = true

        if not self.prevSprintKeyHeld then
            if self.isGrounded then
                self.isSprinting = self.stamina > self.sprintMinStamina
            else
                local wantsToDash = self.canDash and math.abs(velocityIncrease) > 0

                if wantsToDash and self.stamina < self.dashMinStamina then
                    wantsToDash = false
                    self.signals.noStamina:dispatch()
                end

                self.isDashing = wantsToDash

                self.canDash = false

                if self.isDashing then
                    self.dashDirection = velocityIncrease
                    self.startedDashing = love.timer.getTime()

                    self.stamina = mathf.clamp(self.stamina - self.dashStaminaCost, 0, self.maxStamina)
                    self.signals.dashed:dispatch()
                end
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

    -- walk
    if self.isDashing then
        if love.timer.getTime() - self.startedDashing >= self.dashDuration then
            self.velocity = Vector2(velocityIncrease * self.speed,
                self.velocity.y)
            self.isDashing = false
        else
            local speed = self.dashSpeed
            self.velocity = Vector2(self.dashDirection * speed, self.velocity.y)
        end
    else
        -- local speed = self.isSprinting and self.sprintSpeed or self.speed
        local speed = self.speed
        self.velocity.x = mathf.approach(self.velocity.x, velocityIncrease * speed,
            speed * dt * (self.isGrounded and self.acceleration or self.acceleration * self.midarAccelerationMultiplier))
    end

    -- jump
    if jump and not self.prevJump then
        self.signals.jumped:dispatch()

        self.jumpCounter = self.jumpCounter + 1
        self.lastJumped = love.timer.getTime()

        self.velocity.y = -self.jumpForce * self.stamina / self.maxStamina
        self.stamina = math.max(0, self.stamina - self.jumpStaminaCost)

        self.canDash = true
    end

    if self.isGrounded and love.timer.getTime() - self.lastJumped >= self.jumpDebounce then
        self.jumpCounter = 0
    end

    if self.isGrounded and not self.prevGrounded then
        self.signals.landed:dispatch(self.velocity.y)
    end

    -- trail
    self.trailEnabled = self.isDashing

    if self.trailEnabled and love.timer.getTime() - self.lastTrailCreated >= self.trailCreateInterval then
        table.insert(self.trailPositions, { position = self.position, created = love.timer.getTime() })
        if #self.trailPositions > self.trailMaxSize then
            table.remove(self.trailPositions, 1)
        end
        self.lastTrailCreated = love.timer.getTime()
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
    Entity.physics(self, dt, entities, { self.collider }) -- make the player collide

    self.collider.position = self.position

    local entity, penetration = Entity.physics(self.collider, dt, entities, { self }) -- collider to check if grounded

    self.isGrounded = entity and penetration
        and (penetration.x > penetration.y)
        and self.position.y < entity.position.y
end

function Player:draw(unitSize)
    for i, data in ipairs(self.trailPositions) do
        local pos = data.position
        local created = data.created
        local maxTime = self.trailMaxSize * self.trailCreateInterval
        local time = love.timer.getTime() - created
        local alpha = 1 - time / maxTime

        local r, g, b, _ = self.color:unpack()
        love.graphics.setColor(r, g, b, alpha)

        local realX, realY = pos.x * unitSize, pos.y * unitSize
        local realSize = self.size * unitSize

        love.graphics.rectangle('fill', realX - realSize.x / 2, realY - realSize.y / 2, realSize.x, realSize.y)
    end

    Entity.draw(self, unitSize)
end

return Player
