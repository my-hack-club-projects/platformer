local oo = require 'libs.oo'
local Vector2 = require 'types.vector2'

local Camera = oo.class()

function Camera:init(game)
    assert(game, "Camera must be initialized with a game object")

    self.game = game

    self.position = Vector2(0, 0)
    self.scale = Vector2(1, 1)
    self.rotation = 0
end

function Camera:attach()
    love.graphics.push()
    love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    love.graphics.rotate(-self.rotation)
    love.graphics.scale(self.scale.x, self.scale.y)
    love.graphics.translate(-self.position.x * self.game.UnitSize, -self.position.y * self.game.UnitSize)
end

function Camera:detach()
    love.graphics.pop()
end

function Camera:moveBy(dx, dy)
    self.position.x = self.position.x + dx
    self.position.y = self.position.y + dy
end

function Camera:moveTo(x, y)
    self.position.x = x
    self.position.y = y
end

function Camera:scaleBy(sx, sy)
    self.scale.x = self.scale.x + sx
    self.scale.y = self.scale.y + sy
end

function Camera:scaleTo(sx, sy)
    self.scale.x = sx
    self.scale.y = sy
end

function Camera:rotateBy(dr)
    self.rotation = self.rotation + dr
end

function Camera:rotateTo(r)
    self.rotation = r
end

return Camera
