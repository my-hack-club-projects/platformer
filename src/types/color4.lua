local oo = require 'libs.oo'
local mathf = require 'libs.mathf'
local Color3 = require 'types.color3'

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

function Color4:lerp(other, t)
    return Color4(
        mathf.lerp(self.r, other.r, t),
        mathf.lerp(self.g, other.g, t),
        mathf.lerp(self.b, other.b, t),
        mathf.lerp(self.a, other.a, t)
    )
end

function Color4:__add(other)
    return Color4(self.r + other.r, self.g + other.g, self.b + other.b, self.a + other.a)
end

function Color4:__sub(other)
    return Color4(self.r - other.r, self.g - other.g, self.b - other.b, self.a - other.a)
end

function Color4:__mul(other)
    if type(other) == "number" then
        return Color4(self.r * other, self.g * other, self.b * other, self.a * other)
    else
        return Color4(self.r * other.r, self.g * other.g, self.b * other.b, self.a * other.a)
    end
end

function Color4:__div(other)
    if type(other) == "number" then
        return Color4(self.r / other, self.g / other, self.b / other, self.a / other)
    else
        return Color4(self.r / other.r, self.g / other.g, self.b / other.b, self.a / other.a)
    end
end

function Color4:__eq(other)
    return self.r == other.r and self.g == other.g and self.b == other.b and self.a == other.a
end

function Color4:__tostring()
    return "<Color4 (" .. self.r .. ", " .. self.g .. ", " .. self.b .. ", " .. self.a .. ")>"
end

return Color4
