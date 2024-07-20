local oo = require 'libs.oo'
local Color4 = require 'types.color4'

local Palette = oo.class()

local palettes = {
    { -- Cyan and pink
        primary = "252A34",
        secondary = "08D9D6",
        tiertary = "FF2E63",
    },
    { -- Red and orange
        primary = "2D4059",
        secondary = "F07B3F",
        tiertary = "EA5455",
    },
    { -- Cyan and orange
        primary = "303841",
        secondary = "00ADB5",
        tiertary = "FF5722",
    },
}

function Palette:init()
    self.colors_hex = palettes[love.math.random(1, #palettes)]
    self.colors = {}

    for k, v in pairs(self.colors_hex) do
        self.colors[k] = Color4.fromHex(v)
    end
end

return Palette
