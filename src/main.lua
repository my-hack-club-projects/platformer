-- main.lua is responsible for initializing all states and the game loop.

package.path = package.path .. ";game/states/?.lua"
math.randomseed(os.time())

function love.load()
    local config = require 'config'
    local GameClass = require 'game.game'

    Game = GameClass()
    Game.initial = "MainMenu"

    -- load config
    Game:loadConfig(config)

    -- scan game/states directory for all states
    local states = love.filesystem.getDirectoryItems("game/states") -- these are folders with a 'state.lua' file inside them
    for i, state in ipairs(states) do
        local statePath = "game.states." .. state .. ".state"
        local State = require(statePath)

        Game:loadState(State)
    end

    Game:load()
end

function love.update(dt)
    Game:update(dt)
end

function love.draw()
    Game:draw()
end
