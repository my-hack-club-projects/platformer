local oo = require 'libs.oo'
local mathf = require 'libs.mathf'
local Vector2 = require 'types.vector2'
local Color4 = require 'types.color4'
local Entity = require 'libs.entity'

local Map = oo.class()

function Map:init(game)
    self.game = game
    self.width = 0

    self.padSize = { 3, 5 }
    self.padXOffset = { 5, 10 }
    self.padYOffset = { 3, 5 }

    self.pads = {}
    self.nPads = 3 --100
end

function Map:generate()
    self.pads = {}

    local prevPadPosition = Vector2(0, 0)
    for i = 1, self.nPads do
        local pad = Entity()

        local xOffset = math.random(self.padXOffset[1], self.padXOffset[2]) * (math.random(0, 1) == 0 and -1 or 1)

        if prevPadPosition.x + xOffset < -self.width / 2 or prevPadPosition.x + xOffset > self.width / 2 then
            if math.abs(prevPadPosition.x) < math.abs(prevPadPosition.x + xOffset) then
                xOffset = -xOffset
            end
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

function Map:addFinish()
    local lastPad = self.pads[#self.pads]
    local distanceFromEdge = math.min(
        math.abs(lastPad.position.x - self.width / 2),
        math.abs(lastPad.position.x + self.width / 2)
    ) * mathf.sign(lastPad.position.x)

    local finishPlatformPosition = Vector2(lastPad.position.x + distanceFromEdge / 2, lastPad.position.y)
    local finishPlatformSize = Vector2(math.abs(distanceFromEdge), lastPad.size.y)

    local platform = Entity("FinishPlatform")
    platform.position = finishPlatformPosition
    platform.size = finishPlatformSize
    platform.anchored = true
    platform.collide = true

    return { platform }
end

return Map
