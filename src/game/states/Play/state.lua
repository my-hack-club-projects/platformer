local oo = require 'libs.oo'
local State = require 'libs.state'
local Camera = require 'libs.camera'
local Floor = require 'game.objects.floor'
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
end

function PlayState:draw()
    State.draw(self)

    self.camera:attach()
    self.floor:draw()
    self.camera:detach()
end

return PlayState
