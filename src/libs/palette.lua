local oo = require 'libs.oo'
local Color4 = require 'types.color4'

local Palette = oo.class()

local palettes = {
    {
        primary = "153448",
        secondary = "3C5B6F",
        tiertary = "948979",
        accent = "DFD0B8",
    },

    {
        primary = "365E32",
        secondary = "81A263",
        tiertary = "E7D37F",
        accent = "FD9B63",
    },

    {
        primary = "402E7A",
        secondary = "4C3BCF",
        tiertary = "4B70F5",
        accent = "3DC2EC",
    },

    {
        primary = "36BA98",
        secondary = "E9C46A",
        tiertary = "F4A261",
        accent = "E76F51",
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
