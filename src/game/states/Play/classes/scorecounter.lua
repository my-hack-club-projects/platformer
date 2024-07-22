local oo = require 'libs.oo'
local import = require 'libs.import'
local UI, Text = import({ 'UI', 'Text' }, 'libs.ui')
local UDim2 = require 'types.udim2'

local ScoreCounter = oo.class(UI)

function ScoreCounter:init()
    UI.init(self)

    self.position = UDim2.new(0.5, 0, 0, 24)

    self.score = 0
    self.text = Text()

    self.text.text = 'Score: 0'
    self.text.font = love.graphics.newFont('assets/fonts/PressStart2P.ttf', 20)
    self.text.position = UDim2.new(0, 0, 0, 0)
    self.text.parent = self
end

function ScoreCounter:setScore(score)
    self.score = score
    self.text.text = 'Score: ' .. score
end

function ScoreCounter:draw()
    self.text:draw()
end

return ScoreCounter
