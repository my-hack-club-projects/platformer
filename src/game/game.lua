local oo = require 'libs.oo'
local signal = require 'libs.signal'

local Game = oo.class()

function Game:init()
    -- states
    self.states = {}
    self.current = nil
    self.initial = nil

    -- signals
    self.signals = {
        stateChange = signal.new(),

        preDraw = signal.new(),
        postDraw = signal.new(),
        preUpdate = signal.new(),
        postUpdate = signal.new(),
    }

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
    self.signals.preUpdate:dispatch(dt)

    if self.current then
        self.current:update(dt)
    end

    self.signals.postUpdate:dispatch(dt)
end

function Game:draw()
    self.signals.preDraw:dispatch()

    if self.current then
        self.current:draw()
    end

    self.signals.postDraw:dispatch()
end

function Game.__tostring()
    return "<GameObject>"
end

return Game
