local oo = require 'libs.oo'
local State = require 'libs.state'
local Camera = require 'libs.camera'
local Floor = require 'game.objects.floor'

local PlayState = oo.class(State)

function PlayState:init(game)
    State.init(self, game)
    self.name = "PlayState"
end

function PlayState:enter()
    self.camera = Camera(self.game)

    self.entity.new(Floor)
end

function PlayState:draw()
    State.draw(self)

    -- self.camera:attach()
    -- self.floor:draw(self.game.UnitSize)
    -- self.camera:detach()
end

return PlayState
