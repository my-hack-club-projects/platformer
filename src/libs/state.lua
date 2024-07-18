local oo = require 'libs.oo'

local State = oo.class()

function State:init(game)
    assert(game, "State must be initialized with a game object")

    self.name = "BaseState"
    self.game = game
    self.prevState = nil
    self.camera = nil

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
        end,

        remove = function(entity)
            for i, e in ipairs(self._entities) do
                if e == entity then
                    table.remove(self._entities, i)
                    return
                end
            end
        end,
    }

    self._entities = {} -- List of entities attached to this state
end

function State:enter()
    -- To be overwritten by a subclass
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
    if self.camera then
        self.camera:attach()
    end

    for i, entity in ipairs(self._entities) do
        entity:draw(self.game.UnitSize)
    end

    if self.camera then
        self.camera:detach()
    end
end

function State:__tostring()
    return "<StateObject " .. self.name .. ">"
end

return State
