local oo = require 'libs.oo'

local Game = oo.class()

function Game:init()
    -- states
    self.states = {}
    self.current = nil
    self.initial = nil

    -- properties
    self.UnitSize = 32

    -- other
    self.shared = {} -- shared data between states
end

function Game:load()
    -- runs once on love.load after all states have been loaded

    assert(self.initial, "No initial state for Game")
    self:setState(self.initial)
end

function Game:loadState(stateClass)
    local state = stateClass.new(self)

    self.states[state.name] = state
end

function Game:setState(name)
    assert(self.states[name], "State does not exist")

    if self.current then
        self.current:exit()
    end

    local prev = self.current
    print("Setting state")

    self.current = self.states[name]
    self.current:enter(prev)
end

function Game:getState()
    return self.current
end

function Game:resetState()
    self.current:exit()
    self.current:enter()
end

function Game:update(dt)
    if not self.current then return end

    self.current:update(dt)
end

function Game:draw()
    if not self.current then return end

    self.current:draw()
end

function Game.__tostring()
    return "<GameObject>"
end

return Game
