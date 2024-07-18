local oo = require 'libs.oo'

local Game = oo.class()

function Game:init()
    self.states = {}
    self.current = nil
end

function Game:loadState(stateClass)
    local state = stateClass(self)

    self.states[state.name] = state
end

function Game:setState(name)
    assert(self.states[name], "State does not exist")

    if self.current then
        self.current:exit()
    end

    local prev = self.current

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

return Game
