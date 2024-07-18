local oo = require 'libs.oo'

local State = oo.class()

function State:init(prevState)
    self.prevState = prevState

    self.entity = {
        new = function(entityClass, ...)
            local entity = entityClass(...)

            table.insert(self.entities, entity)
            return entity
        end,

        find = function(name)
            for i, entity in ipairs(self.entities) do
                if entity.name == name then
                    return entity
                end
            end
        end
    }
    self.entities = {} -- List of entities attached to this state

    self.enter = function()
    end
end

function State:exit()
    for i, entity in ipairs(self.entities) do
        entity:destroy()
    end

    self.entities = {}
end

function State:update(dt)
    for i, entity in ipairs(self.entities) do
        entity:update(dt)
    end
end

function State:draw()
    for i, entity in ipairs(self.entities) do
        entity:draw()
    end
end

return State
