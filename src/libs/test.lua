local oo = require 'oo' -- Assuming you save the updated library as oo.lua

-- Define a base class with an 'update' method
local BaseClass = oo.class()
function BaseClass:init()
    print("BaseClass init")
end

function BaseClass:update()
    print("BaseClass update: overwrite me!")
end

-- Define a subclass that overrides the 'update' method
local SubClass = oo.class(BaseClass)
function SubClass:init()
    print("SubClass init")
end

function SubClass:update()
    print("SubClass update: I have overwritten the base class method!")
end

-- Create instances and call methods
local base_instance = BaseClass.new()
base_instance:update() -- Output: BaseClass update: overwrite me!

local sub_instance = SubClass.new()
sub_instance:update() -- Output: SubClass update: I have overwritten the base class method!
