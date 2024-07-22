local oo = require 'libs.oo'

local UDim = oo.class()

function UDim:init(scale, offset)
    self.scale = scale or 0
    self.offset = offset or 0
end

function UDim:toPixels(parentSize)
    return self.scale * parentSize + self.offset
end

return UDim
