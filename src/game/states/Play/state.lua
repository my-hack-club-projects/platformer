local oo = require 'libs.oo'
local Vector2 = require 'types.vector2'
local State = require 'libs.state'
local Camera = require 'libs.camera'
local Floor = require 'game.objects.floor'
local Player = require 'game.objects.player'
local Entity = require 'libs.entity'

local PlayState = oo.class(State)

function PlayState:init(game)
    State.init(self, game)

    self.name = "PlayState"

    self.width = 100
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

    self.test = self.entity.new(Entity, "Test")
    self.test.position = Vector2(0, -3)
    self.test.size = Vector2(10, 1)
    self.test.anchored = true
end

function PlayState:update(dt)
    State.update(self, dt)

    self.camera.position.y = -self.camera:getRealSize().y / 2
end

function PlayState:draw()
    State.draw(self)
end

return PlayState
