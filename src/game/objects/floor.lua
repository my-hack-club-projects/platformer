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
    self.segments = {}
    for i = 1, math.ceil(width / self.segmentSize) do
        local entity = Entity()
        entity.position.x = (i - 1) * self.segmentSize - width / 2
        entity.position.y = 0
        entity.size.x = self.segmentSize
        entity.size.y = 1
        entity.color = Color4(math.random(), 0.5, 0.5, 1) -- color for debugging the segments
        entity.anchored = true
        entity.collide = false
        table.insert(self.segments, entity)
    end

    self.collider = Entity()
    self.collider.position.x = 0
    self.collider.position.y = 0
    self.collider.size.x = width
    self.collider.size.y = 1
    self.collider.anchored = true
    self.collider.collide = true
    self.collider.color = Color4(0, 0, 0, 0)

    table.insert(self.segments, self.collider)
end

function Floor:draw()
    for i, segment in ipairs(self.segments) do
        segment:draw(self.game.UnitSize)
    end
end

return Floor
