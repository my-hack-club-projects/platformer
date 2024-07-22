local oo = require 'libs.oo'
local import = require 'libs.import'
local moonshine = require 'libs.moonshine'

local State = require 'libs.state'

local UDim2 = require 'types.udim2'
local Vector2 = require 'types.vector2'
local Color4 = require 'types.color4'

local UI, Text = import({ 'UI', 'Text' }, 'libs.ui')

local GameOver = oo.class(State)

function GameOver:init(...)
    State.init(self, ...)
    self.name = "GameOver"

    self.effect = moonshine(moonshine.effects.pixelate).chain(moonshine.effects.desaturate)
    self.effect.parameters = {
        pixelate = { size = 4 },
        desaturate = { tint = { 50, 50, 50 }, strength = 0.5 },
    }

    self.uis = {}

    self.uis.title = Text()
    self.uis.title.text = "Game over!"
    self.uis.title.font = self.game.fonts[48]
    self.uis.title.position = UDim2.new(0.5, 0, 0.3, 0)

    self.uis.retry = Text()
    self.uis.retry.text = "Try again"
    self.uis.retry.font = self.game.fonts[22]
    self.uis.retry.position = UDim2.new(0.5, 0, 0.5, 16)
end

function GameOver:enter()
    self.listeners = {
        self.uis.retry.mouseDown:connect(function()
            self.game:setState("PlayState")
        end),
        self.uis.retry.mouseEnter:connect(function()
            self.uis.retry.color = Color4.fromHex("#FF0000")
        end),
        self.uis.retry.mouseLeave:connect(function()
            self.uis.retry.color = Color4.fromHex("#FFFFFF")
        end),
    }

    self.game.sound:play("lose")

    self.music = self.game.sound:play("main_menu_music", 0.1)
    self.music:setLooping(true)
end

function GameOver:exit()
    for _, listener in pairs(self.listeners) do
        listener:disconnect()
    end

    self.music:stop()

    State.exit(self.prevState)
end

function GameOver:update(dt)
    if self.prevState then
        self.prevState:updateCamera(dt)
    end

    for _, ui in pairs(self.uis) do
        ui:update(dt)
    end
end

function GameOver:draw()
    if self.prevState then
        self.effect(function()
            self.prevState:draw()
        end)
    end

    for _, ui in pairs(self.uis) do
        ui:draw()
    end

    love.graphics.setColor(1, 1, 1, 1)
end

return GameOver
