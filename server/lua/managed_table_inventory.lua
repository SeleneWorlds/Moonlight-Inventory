local Inventory = require("moonlight-inventory.server.lua.inventory")

local ManagedTableInventory = Inventory:new()

function ManagedTableInventory:addSlot(slotId)
    table.insert(self.slots, slotId)
end

function ManagedTableInventory:getItem(slotId)
    return self.data:Lookup("items", slotId)
end

function ManagedTableInventory:setItem(slotId, item)
    self.data:Set("items", slotId, item)
    self:slotUpdated(slotId)
end

function ManagedTableInventory:getSlots()
    return self.slots
end

function ManagedTableInventory:copyItem(item)
    return item:DeepCopy()
end

function ManagedTableInventory:new(o)
    o = Inventory:new(o or {})
    o.data = o.data or tablex.managed()
    o.data.items = tablex.managed()
    o.slots = o.slots or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

return ManagedTableInventory