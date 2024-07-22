local oo = require 'libs.oo'
local mathf = require 'libs.mathf'
local Vector2 = require 'types.vector2'
local UDim2 = require 'types.udim2'

local UI = oo.class()

function UI:init()
    self.position = UDim2.new(0, 0, 0, 0)
    self.size = UDim2.new(0, 0, 0, 0)

    self.parent = nil
end

function UI:getDimensions()
    if self.parent then
        return self.size:toVector2(self.parent:getDimensions())
    else
        return Vector2(love.graphics.getDimensions())
    end
end

function UI:getPosition()
    if self.parent then
        local parentPosition = self.parent:getPosition()

        local combined = UDim2(
            self.position.x.scale,
            self.position.x.offset + parentPosition.x,
            self.position.y.scale,
            self.position.y.offset + parentPosition.y
        )

        return combined:toVector2(self.parent:getDimensions())
    else
        return self.position:toVector2(Vector2(love.graphics.getDimensions()))
    end
end

function UI:attach()
    love.graphics.push()

    local viewportSize = self:getDimensions()
    local pos = self:getPosition()

    love.graphics.translate(pos.x, pos.y)
end

function UI:detach()
    love.graphics.pop()
end

local Text = oo.class(UI)

function Text:init()
    UI.init(self)

    self.text = ""
    self.font = love.graphics.newFont(12)
end

function Text:attach()
    local textSize = Vector2(self.font:getWidth(self.text), self.font:getHeight())

    love.graphics.push()
    love.graphics.translate(-textSize.x / 2, -textSize.y / 2)
end

function Text:detach()
    love.graphics.pop()
end

function Text:draw()
    UI.attach(self)
    self:attach()

    love.graphics.setFont(self.font)
    love.graphics.print(self.text, 0, 0)

    self:detach()
    UI.detach(self)
end

return {
    UI = UI,
    Text = Text,
}
