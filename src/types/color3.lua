local oo = require 'libs.oo'
local mathf = require 'libs.mathf'

local Color3 = oo.class()

function Color3:init(r, g, b)
    self.r = mathf.clamp(r or 0, 0, 255)
    self.g = mathf.clamp(g or 0, 0, 255)
    self.b = mathf.clamp(b or 0, 0, 255)

    self.fromHex = nil
    self.fromHSV = nil
    self.fromPercentage = nil
end

function Color3.fromHex(hex)
    local splitToRGB = {}

    if # hex < 6 then hex = hex .. string.rep("F", 6 - # hex) end --flesh out bad hexes

    for x = 1, # hex - 1, 2 do
        table.insert(splitToRGB, tonumber(hex:sub(x, x + 1), 16))             --convert hexes to dec
        if splitToRGB[# splitToRGB] < 0 then splitToRGB[# splitToRGB] = 0 end --prevents negative values
    end

    return Color3(table.unpack(splitToRGB))
end

function Color3.fromHSV(h, s, v)
    h, s, v = h / 360, s / 100, v / 100

    if s <= 0 then return v, v, v end
    h = h * 6
    local c = v * s
    local x = (1 - math.abs((h % 2) - 1)) * c
    local m, r, g, b = (v - c), 0, 0, 0
    if h < 1 then
        r, g, b = c, x, 0
    elseif h < 2 then
        r, g, b = x, c, 0
    elseif h < 3 then
        r, g, b = 0, c, x
    elseif h < 4 then
        r, g, b = 0, x, c
    elseif h < 5 then
        r, g, b = x, 0, c
    else
        r, g, b = c, 0, x
    end

    return Color3((r + m) * 255, (g + m) * 255, (b + m) * 255)
end

function Color3.fromPercentage(r, g, b)
    return Color3(r * 255, g * 255, b * 255)
end

function Color3:__tostring()
    return "<Color3 (" .. self.r .. ", " .. self.g .. ", " .. self.b .. ")>"
end

return Color3
