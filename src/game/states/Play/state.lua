local oo = require 'libs.oo'
local mathf = require 'libs.mathf'
local Vector2 = require 'types.vector2'
local State = require 'libs.state'
local Camera = require 'libs.camera'
local Floor = require 'game.objects.floor'
local Player = require 'game.objects.player'
local Entity = require 'libs.entity'
local Map = require 'game.states.Play.classes.map'
local Walls = require 'game.objects.walls'

local PlayState = oo.class(State)

function PlayState:init(game)
    State.init(self, game)

    self.name = "PlayState"

    self.width = 50
    self.height = 500
end

function PlayState:enter()
    self.camera = Camera(self.game)

    self.floor = Floor(self.game)
    self.floor:fillWidth(self.width)

    for _, segment in ipairs(self.floor.segments) do
        self.entity.insert(segment)
    end

    self.player = self.entity.new(Player)
    self.player.gravity = self.game.Gravity

    self.map = Map(self.game)
    self.map:generate()

    for _, pad in ipairs(self.map.pads) do
        self.entity.insert(pad)
    end

    self.walls = Walls(self.width, self.height)

    for _, wall in ipairs(self.walls.walls) do
        self.entity.insert(wall)
    end
end

function PlayState:updateCamera(dt)
    local cameraRealSize = self.camera:getRealSize()
    local cameraClamp = {
        left = -self.width / 2 + cameraRealSize.x / 2,
        right = self.width / 2 - cameraRealSize.x / 2,
        top = -math.huge,
        bottom = -cameraRealSize.y / 2
    }

    local cameraPosition = self.camera.position -- table reference, won't need to set it back
    local playerPosition = self.player.position
    local distance = (cameraPosition + Vector2(0, cameraRealSize.y / 2) - playerPosition).magnitude

    cameraPosition.x = mathf.approach(cameraPosition.x, playerPosition.x, distance * dt)
    cameraPosition.y = mathf.approach(cameraPosition.y, playerPosition.y, distance * dt)

    cameraPosition.x = mathf.clamp(cameraPosition.x, cameraClamp.left, cameraClamp.right)
    cameraPosition.y = mathf.clamp(cameraPosition.y, cameraClamp.top, cameraClamp.bottom)
end

function PlayState:update(dt)
    State.update(self, dt)

    self:updateCamera(dt)
end

function PlayState:draw()
    State.draw(self)
end

return PlayState
