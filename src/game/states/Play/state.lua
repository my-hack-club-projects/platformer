local oo = require 'libs.oo'
local mathf = require 'libs.mathf'
local moonshine = require 'libs.moonshine'
local Vector2 = require 'types.vector2'
local State = require 'libs.state'
local Camera = require 'libs.camera'
local Floor = require 'game.objects.floor'
local Player = require 'game.objects.player'
local Entity = require 'libs.entity'
local Map = require 'game.states.Play.classes.map'
local Walls = require 'game.objects.walls'
local Lava = require 'game.states.Play.classes.lava'
local StaminaCounter = require 'game.states.Play.classes.staminacounter'
local ScoreCounter = require 'game.states.Play.classes.scorecounter'

local function _addPads(currentPads)
    -- calculate how many pads to add and return the new number of pads
    -- formula: 2 * currentPads + 1. This means that the number of pads will be: 3, 7, 15, 31, 64, 127, 255, ...

    return 2 * currentPads + 1
end

local PlayState = oo.class(State)

function PlayState:init(game)
    State.init(self, game)

    self.name = "PlayState"

    self.width = 80
    self.maxDifficultyLevel = 7

    -- shaders
    self.effect = moonshine(moonshine.effects.crt)

    self.effect.parameters = {
        crt = { feather = 0.3, distortionFactor = { 1.1, 1.1 } },
    }

    self.screenShakeMagnitude = 0
    self.screenShake = {}

    self.game.signals.resize:connect(function(width, height)
        self.effect.resize(width, height)
    end)
end

function PlayState:enter(prevState, data)
    self.data = data or {
        score = 0,
        time = 0,
        level = 0,
        nPads = 1,
        padSize = { 4, 7 },
        padXOffset = { 5, 10 },
        padYOffset = { 2, 5 },
        lavaSpeed = 0.5,
    }

    self.data.level = self.data.level + 1

    self.data.nPads = 2 * self.data.nPads + 1
    self.data.padSize[1] = mathf.clerp(4, 1, self.data.level / self.maxDifficultyLevel)
    self.data.padXOffset[1] = mathf.clerp(5, 0, self.data.level / self.maxDifficultyLevel)
    self.data.padXOffset[2] = mathf.clerp(10, 5, self.data.level / self.maxDifficultyLevel)
    self.data.padYOffset[1] = mathf.clerp(2, 4, self.data.level / self.maxDifficultyLevel)
    self.data.padYOffset[2] = mathf.clerp(5, 6, self.data.level / self.maxDifficultyLevel)
    self.data.lavaSpeed = mathf.clerp(0.5, 6, self.data.level / self.maxDifficultyLevel)

    self.camera = Camera(self.game)
    self.camera:scaleTo(2, 2)

    self.map = Map(self.game)
    self.map.width = self.width / 3 * 2
    self.map.startNumber = self.data.score
    self.map.padSize = self.data.padSize
    self.map.padXOffset = self.data.padXOffset
    self.map.padYOffset = self.data.padYOffset
    self.map:generate(self.data.nPads)

    for _, pad in ipairs(self.map.pads) do
        pad.color = self.game.palette.colors.secondary
        self.entity.insert(pad)
    end

    for i, finish in pairs(self.map:addFinish()) do
        self.entity.insert(finish)

        if i == "portal" then
            self.portal = finish
        end
    end

    self.player = self.entity.new(Player, "Player")
    self.player.position = self.map.pads[1].position -
        Vector2(0, self.map.pads[1].size.y / 2 + self.player.size.y / 2) - Vector2(0, 3)
    self.player.gravity = self.game.Gravity
    self.player.color = self.game.palette.colors.secondary

    self.lava = self.entity.new(Lava, "Lava")
    self.lava.size = Vector2(self.width * 10, 0)
    self.lava.maxSize = math.abs(self.portal.position.y) - 5
    self.lava.color = self.game.palette.colors.tiertary
    self.lava.riseSpeed = self.data.lavaSpeed

    self.staminaCounter = StaminaCounter(self.player.maxStamina)

    self.scoreCounter = ScoreCounter()
    self.scoreCounter:setScore(self.data.score)

    love.graphics.setBackgroundColor(self.game.palette.colors.primary:unpack())

    -- handle signals
    self.listeners = {
        self.player.signals.jumped:connect(function()
            self.game.sound:play('jump')
        end),
        self.player.signals.landed:connect(function(velocity)
            self.game.sound:play('land', velocity / 25)

            table.insert(
                self.screenShake,
                {
                    duration = math.min(velocity / 25, 1.2),
                    magnitude = math.min(velocity / 50, 100)
                }
            )
        end),
        self.player.signals.dashed:connect(function()
            local source = self.game.sound:play('dash', 0.4)
            -- playback speed
            local originalLength = source:getDuration()
            source:setPitch(originalLength / self.player.dashDuration / 4)

            table.insert(
                self.screenShake,
                {
                    duration = self.player.dashDuration,
                    magnitude = 100
                }
            )
        end),
        self.player.signals.noStamina:connect(self.staminaCounter.shake, self.staminaCounter),

        self.player.touched:connect(function(entity)
            if entity.name ~= "Pad" and entity.name ~= "FinishPlatform" then
                return
            end

            local number = entity.number

            self.data.score = math.max(self.data.score, number)
            self.scoreCounter:setScore(self.data.score)
        end),

        self.portal.playerTouched:connect(function()
            State.exit(self)
            self.game:setState("PlayState", self.data)
        end),
        self.lava.playerTouched:connect(function()
            self.game:setState("GameOver", self.data)
        end),
    }

    self.fallingSound = self.game.sound:play('falling')
    self.fallingSound:setLooping(true)

    self.music = self.game.sound:play('music' .. math.random(1, 2), 0.25)
    self.music:setLooping(true)

    table.insert(self.screenShake, { duration = 1, magnitude = 10 })
end

function PlayState:exit()
    -- Note: clearing entities will be handled in the GameOver state
    -- why? We want to keep rendering the last frame

    for _, listener in ipairs(self.listeners) do
        listener:disconnect()
    end

    self.fallingSound:stop()
    self.music:stop()
end

function PlayState:updateCamera(dt)
    local cameraRealSize = self.camera:getRealSize()
    local cameraClamp = {
        left = -self.width / 2 + cameraRealSize.x / 2,
        right = self.width / 2 - cameraRealSize.x / 2,
        top = -math.huge,
        bottom = -cameraRealSize.y / 2
    }

    local cameraPosition = self.camera.position -- table reference, won't need to set it back
    local playerPosition = self.player.position

    local speedX = math.abs(cameraPosition.x - playerPosition.x) ^ 3
    local speedY = math.abs(cameraPosition.y - playerPosition.y) ^ 2

    cameraPosition.x = mathf.approach(cameraPosition.x, playerPosition.x, speedX * dt)
    cameraPosition.y = mathf.approach(cameraPosition.y, playerPosition.y, speedY * dt)

    cameraPosition.x = mathf.clamp(cameraPosition.x, cameraClamp.left, cameraClamp.right)
    cameraPosition.y = mathf.clamp(cameraPosition.y, cameraClamp.top, cameraClamp.bottom)
end

function PlayState:update(dt)
    State.update(self, dt)

    self.staminaCounter:setStamina(self.player.stamina)
    self.staminaCounter:update(dt)

    self:updateCamera(dt)

    if self.player.velocity.y > 0 then
        self.fallingSound:setVolume(mathf.clamp(math.abs(self.player.velocity.y) / 25, 0, 1))
    else
        self.fallingSound:setVolume(0)
    end

    self.data.time = self.data.time + dt
end

function PlayState:draw()
    -- camera shake
    local magnitude = 0
    for i, shake in ipairs(self.screenShake) do
        shake.duration = shake.duration - love.timer.getDelta()

        shake.magnitude = mathf.lerp(0, shake.magnitude, shake.duration)

        if shake.duration <= 0 then
            shake.remove = true
        end

        magnitude = math.max(magnitude, shake.magnitude)
    end

    for i = #self.screenShake, 1, -1 do
        if self.screenShake[i].remove then
            table.remove(self.screenShake, i)
        end
    end

    local shake = Vector2(math.random(-magnitude, magnitude),
        math.random(-magnitude, magnitude))

    love.graphics.translate(shake.x, shake.y)

    -- draw the effect and then the scene
    self.effect(function()
        State.draw(self)
    end)

    self.staminaCounter:draw()
    self.scoreCounter:draw()
end

return PlayState
