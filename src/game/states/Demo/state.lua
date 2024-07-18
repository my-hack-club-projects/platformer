local oo = require 'libs.oo'
local State = require 'libs.state'
local DemoEntity = require 'game.states.Demo.demoentity'

local DemoState = oo.class(State)

function DemoState:init(game)
    State.init(self, game)

    self.name = "DemoState"
end

function DemoState:enter(prevState)
    -- create a demo entity
    self.demoEntity = self.entity.new(DemoEntity, "demo entity")
end

function DemoState:exit()
    State.exit(self)

    -- destroy the demo entity
    self.demoEntity:destroy()
end

return DemoState
