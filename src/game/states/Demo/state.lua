local oo = require 'libs.oo'
local State = require 'libs.state'
local Camera = require 'libs.camera'
local DemoEntity = require 'game.states.Demo.demoentity'

local DemoState = oo.class(State)

function DemoState:init(game)
    State.init(self, game)

    self.name = "DemoState"

    self.cameraMoveSpeed = 10
    self.cameraRotateSpeed = 1
    self.cameraScaleSpeed = 1
end

function DemoState:enter(prevState)
    self.camera = Camera(self.game)

    -- create a demo entity
    self.demoEntity = self.entity.new(DemoEntity, "demo entity")
end

function DemoState:exit()
    State.exit(self)

    -- destroy the demo entity
    self.demoEntity:destroy()
end

function DemoState:update(dt)
    State.update(self, dt)

    -- Do some test camera actions depending on the key pressed. WASD moves the camera, QE rotates the camera, and RF scales the camera.

    self.camera:moveBy(
        ((love.keyboard.isDown("a") and -1 or 0) + (love.keyboard.isDown("d") and 1 or 0)) * dt * self.cameraMoveSpeed,
        ((love.keyboard.isDown("w") and -1 or 0) + (love.keyboard.isDown("s") and 1 or 0)) * dt * self.cameraMoveSpeed)
    self.camera:rotateBy(((love.keyboard.isDown("q") and -1 or 0) + (love.keyboard.isDown("e") and 1 or 0)) * dt *
        self.cameraRotateSpeed)
    self.camera:scaleBy(
        ((love.keyboard.isDown("r") and -1 or 0) + (love.keyboard.isDown("f") and 1 or 0)) * dt * self.cameraScaleSpeed,
        ((love.keyboard.isDown("r") and -1 or 0) + (love.keyboard.isDown("f") and 1 or 0)) * dt * self.cameraScaleSpeed)

    self.demoEntity.rotation = self.demoEntity.rotation +
    ((love.keyboard.isDown("g") and -1 or 0) + (love.keyboard.isDown("h") and 1 or 0)) * dt * 1
end

return DemoState
