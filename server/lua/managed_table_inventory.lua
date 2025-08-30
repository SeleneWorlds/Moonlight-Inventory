local Inventory = require("moonlight-inventory.server.lua.inventory")

local ManagedTableInventory = Inventory:new()

function ManagedTableInventory:addSlot(slotId)
    local slots = self.data:RawLookup("slots")
    table.insert(slots, slotId)
    self.data.slots = slots
end

function ManagedTableInventory:getItem(slotId)
    return self.data:Lookup("items", slotId)
end

function ManagedTableInventory:setItem(slotId, item)
    self.data:Set("items", slotId, item)
    self:slotUpdated(slotId)
end

function ManagedTableInventory:getSlots()
    return self.data:RawLookup("slots")
end

function ManagedTableInventory:copyItem(item)
    return item:DeepCopy()
end

function ManagedTableInventory:new(o)
    o = Inventory:new(o or {})
    o.data = o.data or tablex.managed()
    if not o.data:HasKey("slots") then
        o.data.slots = {}
    end
    o.data.items = tablex.managed()
    setmetatable(o, self)
    self.__index = self
    return o
end

return ManagedTableInventory