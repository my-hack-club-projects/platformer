local oo = require 'libs.oo'
local Vector2 = require 'types.vector2'
local Color4 = require 'types.color4'

local Entity = oo.class()

function Entity:init(name)
    self.name = name or ""
    self.state = nil -- reverse pointer to the state that owns this entity

    self.position = Vector2(0, 0)
    self.size = Vector2(0, 0)
    self.rotation = 0

    self.color = Color4(1, 1, 1, 1)
end

function Entity:destroy()
    self.state.entity.remove(self)
end

function Entity:update(dt)
    -- This function is to be overridden by classes that inherit from Entity.
end

function Entity:draw_setup(unitSize)
    -- This function translates and rotates the screen so that the entity can be drawn
    love.graphics.translate(self.position.x * unitSize, self.position.y * unitSize)
    love.graphics.rotate(self.rotation)

    love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
end

function Entity:draw(unitSize)
    assert(unitSize, "Unit size not provided")

    -- This function draws a rectangle at the entity's position.
    love.graphics.push()

    self:draw_setup(unitSize)

    love.graphics.rectangle(
        'fill',
        -self.size.x * unitSize / 2,
        -self.size.y * unitSize / 2,
        self.size.x * unitSize,
        self.size.y * unitSize
    )

    love.graphics.pop()
end

function Entity:__tostring()
    return "<Entity '" .. self.name .. "' at " .. tostring(self.position) .. ">"
end

return Entity
