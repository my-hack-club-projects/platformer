local oo = require 'libs.oo'
local mathf = require 'libs.mathf'
local Vector2 = require 'types.vector2'
local UDim2 = require 'types.udim2'

local StaminaCounter = oo.class()

function StaminaCounter:init(maxStamina)
    self.stamina = 0
    self.maxStamina = maxStamina or 0

    self.currentPercent = 0
    self.targetPercent = 0
    self.lerpSpeed = 10

    self.position = UDim2.new(0.5, 0, 1, -15)
    self.size = UDim2.new(0.4, 0, 0, 5)
    self.thickness = 2

    self.shakes = {}
    self.shakeMagnitude = 15
    self.shakeDuration = 0.6
end

function StaminaCounter:setStamina(stamina)
    self.stamina = stamina
    self.targetPercent = mathf.map(self.stamina, 0, self.maxStamina, 0, 1)
end

function StaminaCounter:shake()
    table.insert(self.shakes, {
        magnitude = self.shakeMagnitude,
        duration = self.shakeDuration,
        elapsed = 0
    })
end

function StaminaCounter:update(dt)
    self.currentPercent = mathf.lerp(self.currentPercent, self.targetPercent, self.lerpSpeed * dt)
end

function StaminaCounter:draw()
    local viewportSize = Vector2(love.graphics.getDimensions())

    local pos = self.position:toVector2(viewportSize)
    local size = self.size:toVector2(viewportSize)

    -- apply shake
    local highestMagnitude = 0
    for i = #self.shakes, 1, -1 do
        local shake = self.shakes[i]
        shake.elapsed = shake.elapsed + love.timer.getDelta()
        shake.magnitude = mathf.lerp(0, shake.magnitude, shake.duration)
        if shake.elapsed >= shake.duration then
            table.remove(self.shakes, i)
        else
            highestMagnitude = math.max(highestMagnitude, shake.magnitude)
        end
    end

    local shakeAmount = Vector2(math.random(-highestMagnitude, highestMagnitude),
        math.random(-highestMagnitude, highestMagnitude))
    love.graphics.push()
    love.graphics.translate(shakeAmount.x, shakeAmount.y)
    self:drawBar(pos, size)
    love.graphics.pop()
end

function StaminaCounter:drawBar(pos, size)
    -- draw outline / holder
    love.graphics.push()
    love.graphics.translate(pos.x, pos.y)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', -size.x / 2, -size.y / 2, size.x, size.y)
    -- draw white bar
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle('fill', -size.x / 2 + self.thickness / 2, -size.y / 2 + self.thickness / 2,
        size.x * self.currentPercent - self.thickness, size.y - self.thickness)
    love.graphics.pop()
end

return StaminaCounter
