local oo = require 'libs.oo'
local mathf = require 'libs.mathf'
local Color3 = require 'libs.color3'

local Color4 = oo.class(Color3)

function Color4:init(r, g, b, a)
    Color3.init(self, r, g, b)

    self.a = mathf.clamp(a or 255, 0, 255)

    self.fromHex = nil
    self.fromHSV = nil
    self.fromPercentage = nil
end

function Color4.fromHex(hex)
    local splitToRGBA = {}

    if # hex < 8 then hex = hex .. string.rep("F", 8 - # hex) end --flesh out bad hexes

    for x = 1, # hex - 1, 2 do
        table.insert(splitToRGBA, tonumber(hex:sub(x, x + 1), 16))                --convert hexes to dec
        if splitToRGBA[# splitToRGBA] < 0 then splitToRGBA[# splitToRGBA] = 0 end --prevents negative values
    end

    return Color4(table.unpack(splitToRGBA))
end

function Color4.fromHSV(h, s, v, a)
    local color = Color3.fromHSV(h, s, v)
    return Color4(color.r, color.g, color.b, a)
end

function Color4.fromPercentage(r, g, b, a)
    return Color4(r * 255, g * 255, b * 255, a * 255)
end

function Color4:__tostring()
    return "<Color4 (" .. self.r .. ", " .. self.g .. ", " .. self.b .. ", " .. self.a .. ")>"
end

return Color4
