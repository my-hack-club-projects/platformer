local oo = require 'libs.oo'
local moonshine = require 'libs.moonshine'
local import = require 'libs.import'

local State = require 'libs.state'

local UDim2 = require 'types.udim2'
local Vector2 = require 'types.vector2'
local Color4 = require 'types.color4'

local UI, Text = import({ 'UI', 'Text' }, 'libs.ui')

local Map, Entity = require 'game.states.Play.classes.map', require 'libs.entity'
local Camera = require 'libs.camera'

local MainMenu = oo.class(State)

function MainMenu:init(game)
    State.init(self, game)

    self.name = "MainMenu"
    self.effect = moonshine(moonshine.effects.pixelate).chain(moonshine.effects.desaturate)
    self.effect.parameters = {
        pixelate = { size = 4 },
        desaturate = { tint = { 50, 50, 50 }, strength = 0.5 },
    }

    self.uis = {}

    self.uis.title = Text()
    self.uis.title.text = "Game name"
    self.uis.title.font = self.game.fonts[48]
    self.uis.title.position = UDim2.new(0.5, 0, 0.3, 24)

    self.uis.play = Text()
    self.uis.play.text = "Play"
    self.uis.play.font = self.game.fonts[16]
    self.uis.play.position = UDim2.new(0.5, 0, 0.5, 16)

    self.padAnimationSpeed = 2

    self.camera = Camera(self.game)
    self.camera:scaleTo(2, 2)

    self.map = Map()
    self.map.width = 30
    self.map:generate(5)

    for _, pad in ipairs(self.map.pads) do
        pad.color = self.game.palette.colors.secondary
        pad.direction = math.random() * 2 - 1
    end

    self.player = Entity()
    self.player.position = self.map.pads[1].position - Vector2.new(0, 1)
    self.player.size = Vector2.new(1, 1)
    self.player.color = self.game.palette.colors.tiertary

    self.camera.position = self.player.position - Vector2.new(0, 5)

    love.graphics.setBackgroundColor(self.game.palette.colors.primary:unpack())

    self:setPlayerPosition()
end

function MainMenu:setPlayerPosition()
    self.player.position = self.map.pads[1].position - Vector2.new(0, 1)
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

    self.music = self.game.sound:play("main_menu_music", 0.1)
    self.music:setLooping(true)
end

function MainMenu:exit()
    for _, listener in pairs(self.listeners) do
        listener:disconnect()
    end

    self.music:stop()
end

function MainMenu:update(dt)
    for _, pad in ipairs(self.map.pads) do
        pad.position = pad.position + Vector2.new(pad.direction * self.padAnimationSpeed * dt, 0)
        if pad.position.x < -10 or pad.position.x > self.map.width + 10 then
            pad.direction = -pad.direction
        end
    end

    self:setPlayerPosition()

    for _, ui in pairs(self.uis) do
        ui:update()
    end
end

function MainMenu:draw()
    self.effect(function()
        self.camera:attach()
        for _, pad in ipairs(self.map.pads) do
            pad:draw(self.game.UnitSize)
        end
        self.player:draw(self.game.UnitSize)
        self.camera:detach()
    end)

    for _, ui in pairs(self.uis) do
        ui:draw()
    end

    love.graphics.setColor(1, 1, 1, 1)
end

return MainMenu
