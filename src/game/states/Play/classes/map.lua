local oo = require 'libs.oo'
local Vector2 = require 'types.vector2'
local Color4 = require 'types.color4'
local Entity = require 'libs.entity'

local Map = oo.class()

function Map:init()
    self.width = 0

    self.maxBranches = 3
    self.maxDepth = 3

    self.upDistance = { 2, 4 }
    self.sideDistance = { 5, 15 }

    self.padSize = { 1, 3 }

    self.pads = {}
end

function Map:generate()
    self.pads = {}

    local startPad = Entity()
    startPad.position = Vector2(0, 0)
    startPad.size = Vector2(3, 1)
    startPad.color = Color4(1, 1, 1, 1)
    table.insert(self.pads, startPad)

    local function recurse(pads, depth)
        if depth > self.maxDepth then
            return
        end

        for i, pad in ipairs(pads) do
            local newPads = self:generateAdjacentPads(pad)
            table.insert(self.pads, pad)
            recurse(newPads, depth + 1)
        end
    end

    recurse(self.pads, 1)
end

function Map:generateAdjacentPads(pad)
    local pads = {}
    local nPads = math.random(1, self.maxBranches)

    for i = 1, nPads do
        local newPad = Entity()
        newPad.position = pad.position +
            Vector2(math.random(-self.sideDistance[2], self.sideDistance[2]),
                math.random(self.upDistance[1], self.upDistance[2]))
        newPad.size = Vector2(math.random(table.unpack(self.padSize), 1))
        newPad.color = Color4(1, 1, 1, 1)
        newPad.anchored = true
        newPad.collide = true

        table.insert(pads, newPad)
    end

    return pads
end

return Map
