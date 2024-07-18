local oo = require 'libs.oo'

local State = oo.class()

function State:init(prevState)
    self.prevState = prevState

    self.entity = {
        new = function(entityClass, ...)
            local entity = entityClass(...)

            table.insert(self._entities, entity)
            entity.state = self

            return entity
        end,

        find = function(name)
            for i, entity in ipairs(self._entities) do
                if entity.name == name then
                    return entity
                end
            end
        end
    }
    self._entities = {} -- List of entities attached to this state

    self.enter = function()
    end
end

function State:exit()
    for i, entity in ipairs(self.entities) do
        entity:destroy()
    end

    self._entities = {}
end

function State:update(dt)
    for i, entity in ipairs(self._entities) do
        entity:update(dt)
    end
end

function State:draw()
    for i, entity in ipairs(self._entities) do
        entity:draw()
    end
end

return State
