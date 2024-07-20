local oo = require 'libs.oo'
local Vector2 = require 'types.vector2'
local Color4 = require 'types.color4'
local Entity = require 'libs.entity'

local Map = oo.class()

function Map:init()
    self.width = 0


    self.padSize = { 3, 5 }
    self.padXOffset = { 5, 10 }
    self.padYOffset = { 3, 5 }

    self.pads = {}
    self.nPads = 100
end

function Map:generate()
    self.pads = {}

    local prevPadPosition = Vector2(0, 0)
    for i = 1, self.nPads do
        local pad = Entity()

        local xOffset = math.random(self.padXOffset[1], self.padXOffset[2]) * (math.random(0, 1) == 0 and -1 or 1)

        if prevPadPosition.x + xOffset < -self.width / 2 or prevPadPosition.x + xOffset > self.width / 2 then
            xOffset = -xOffset
        end

        pad.position = Vector2(
            prevPadPosition.x + xOffset,
            prevPadPosition.y - math.random(self.padYOffset[1], self.padYOffset[2])
        )
        pad.size = Vector2(
            math.random(3, 5),
            1
        )

        pad.anchored = true
        pad.collide = true
        table.insert(self.pads, pad)

        prevPadPosition = pad.position
    end
end

return Map
