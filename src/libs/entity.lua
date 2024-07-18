local oo = require 'libs.oo'
local Vector2 = require 'types.Vector2'

local Entity = oo.class()

function Entity:init(name)
    self.name = name or ""

    self.position = Vector2(0, 0)
    self.size = Vector2(0, 0)
    self.rotation = 0
end

function Entity:add(component)
    table.insert(self.components, component)
end

function Entity:update(dt)
    -- This function is to be overridden by classes that inherit from Entity.
end

function Entity:draw_setup(unitSize)
    -- This function translates and rotates the screen so that the entity can be drawn
    love.graphics.translate(self.position.x * unitSize, self.position.y * unitSize)
    love.graphics.rotate(-self.rotation)
end

function Entity:draw(dt, unitSize)
    -- This function draws a rectangle at the entity's position.
    love.graphics.push()

    self.draw_setup(unitSize)

    love.graphics.rectangle(
        'fill',
        -self.size.x * unitSize / 2,
        -self.size.y * unitSize / 2,
        self.size.x * unitSize,
        self.size.y * unitSize
    )

    love.graphics.pop()
end

return Entity
