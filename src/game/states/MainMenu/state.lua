local oo = require 'libs.oo'
local import = require 'libs.import'

local State = require 'libs.state'

local UDim2 = require 'types.udim2'
local Color4 = require 'types.color4'

local UI, Text = import({ 'UI', 'Text' }, 'libs.ui')

local MainMenu = oo.class(State)

function MainMenu:init(game)
    State.init(self, game)

    self.name = "MainMenu"

    self.uis = {}

    self.uis.title = Text()
    self.uis.title.text = "Game name"
    self.uis.title.font = self.game.fonts[24]
    self.uis.title.position = UDim2.new(0.5, 0, 0.1, 24)

    self.uis.play = Text()
    self.uis.play.text = "Play"
    self.uis.play.font = self.game.fonts[16]
    self.uis.play.position = UDim2.new(0.5, 0, 0.5, 16)
end

function MainMenu:enter()
    self.listeners = {
        self.uis.play.mouseDown:connect(function()
            self.game:setState("PlayState")
        end),

        self.uis.play.mouseEnter:connect(function()
            self.uis.play.color = Color4.fromHex("#FF0000")
        end),
        self.uis.play.mouseLeave:connect(function()
            self.uis.play.color = Color4.fromHex("#FFFFFF")
        end),
    }
end

function MainMenu:exit()
    for _, listener in pairs(self.listeners) do
        listener:disconnect()
    end
end

function MainMenu:update(dt)
    for _, ui in pairs(self.uis) do
        ui:update()
    end
end

function MainMenu:draw()
    for _, ui in pairs(self.uis) do
        ui:draw()
    end
end

return MainMenu
