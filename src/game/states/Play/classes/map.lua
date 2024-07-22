local oo = require 'libs.oo'
local mathf = require 'libs.mathf'
local Vector2 = require 'types.vector2'
local Color4 = require 'types.color4'
local Entity = require 'libs.entity'
local Portal = require 'game.objects.portal'

local Map = oo.class()

function Map:init(game)
    self.game = game
    self.width = 0

    self.padSize = { 3, 5 }
    self.padXOffset = { 5, 10 }
    self.padYOffset = { 3, 5 }

    self.pads = {}
    self.nPads = 0

    self.portalColor = Color4.fromHex("#9130b8")
end

function Map:generate(nPads)
    self.nPads = nPads
    self.pads = {}

    local prevPadPosition = Vector2(0, 0)
    for i = 1, self.nPads do
        local pad = Entity("Pad")
        pad.number = i

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
    local prevPad = self.pads[#self.pads - 1]

    local direction = mathf.sign(lastPad.position.x - prevPad.position.x)

    local distanceFromEdge = math.abs(
        (lastPad.position.x + lastPad.size.x / 2 * direction) - self.width / 2 * direction
    ) * direction

    local finishPlatformPosition = Vector2(lastPad.position.x + distanceFromEdge / 2, lastPad.position.y)
    local finishPlatformSize = Vector2(math.abs(distanceFromEdge), lastPad.size.y)

    local platform = Entity("FinishPlatform")
    platform.position = finishPlatformPosition
    platform.size = finishPlatformSize
    platform.anchored = true
    platform.collide = true
    platform.color = lastPad.color
    platform.number = lastPad.number

    local portal = Portal("FinishPortal")
    portal.size = Vector2(1, 3)
    portal.position = finishPlatformPosition
        + finishPlatformSize / 2 * direction
        - Vector2(0, portal.size.y / 2)
        - Vector2(portal.size.y / 2, 0) * direction

    portal.anchored = true
    portal.collide = false
    portal.color = self.portalColor

    return {
        platform = platform,
        portal = portal
    }
end

return Map
