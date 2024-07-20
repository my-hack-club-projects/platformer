local oo = require 'libs.oo'
local Vector2 = require 'types.vector2'
local Color4 = require 'types.color4'

local function _find(t, v)
    for i, _v in ipairs(t) do
        if _v == v then
            return i
        end
    end
end

local Entity = oo.class()

function Entity:init(name)
    self.name = name or ""
    self.state = nil -- reverse pointer to the state that owns this entity

    self.position = Vector2(0, 0)
    self.size = Vector2(0, 0)
    self.rotation = 0

    self.color = Color4(1, 1, 1, 1)

    self.anchored = false
    self.collide = true

    self.gravity = 0
    self.mass = 1
    self.velocity = Vector2(0, 0)
end

function Entity:destroy()
    self.state.entity.remove(self)
end

function Entity:update(dt, entities)
    if not self.anchored then
        self:move(dt)
        self:applyGravity(dt)
        self:physics(dt, entities)
    end
end

function Entity:move(dt)
    self.position = self.position + self.velocity * dt
end

function Entity:applyGravity(dt)
    self.velocity.y = self.velocity.y + self.gravity * self.mass * dt
end

function Entity:physics(dt, entities, ignoreList)
    if not ignoreList then
        ignoreList = {}
    end

    for i, entity in ipairs(entities) do
        if entity ~= self and entity.collide and not _find(ignoreList, entity) then
            if self:collides(entity) then
                local penetration = Vector2(
                    (self.size.x + entity.size.x) / 2 - math.abs(self.position.x - entity.position.x),
                    (self.size.y + entity.size.y) / 2 - math.abs(self.position.y - entity.position.y)
                )

                if self.collide then
                    if penetration.x < penetration.y then
                        if self.position.x < entity.position.x then
                            self.position.x = self.position.x - penetration.x
                        else
                            self.position.x = self.position.x + penetration.x
                        end
                    else
                        if self.position.y < entity.position.y then
                            self.position.y = self.position.y - penetration.y
                        else
                            self.position.y = self.position.y + penetration.y
                            self.velocity.y = 0
                        end
                    end
                end

                return entity, penetration
            end
        end
    end

    return nil
end

function Entity:collides(entity)
    -- aabb
    return self.position.x - self.size.x / 2 < entity.position.x + entity.size.x / 2 and
        self.position.x + self.size.x / 2 > entity.position.x - entity.size.x / 2 and
        self.position.y - self.size.y / 2 < entity.position.y + entity.size.y / 2 and
        self.position.y + self.size.y / 2 > entity.position.y - entity.size.y / 2
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
