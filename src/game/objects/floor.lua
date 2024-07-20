local oo = require 'libs.oo'
local Entity = require 'libs.entity'
local Color4 = require 'types.color4'

local Floor = oo.class()

function Floor:init(game)
    self.game = game
    self.segments = {}
    self.collider = nil

    self.segmentSize = 1
end

function Floor:fillWidth(width)
    self.collider = Entity()
    self.collider.position.x = 0
    self.collider.position.y = 0
    self.collider.size.x = width
    self.collider.size.y = 1
    self.collider.anchored = true
    self.collider.collide = true
    self.collider.color = Color4(1, 1, 1, 1)

    table.insert(self.segments, self.collider)
end

function Floor:draw()
    for i, segment in ipairs(self.segments) do
        segment:draw(self.game.UnitSize)
    end
end

return Floor
