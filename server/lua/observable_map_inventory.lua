local Inventory = require("moonlight-inventory.server.lua.inventory")

local ObservableMapInventory = Inventory:new()

function ObservableMapInventory:addSlot(slotId)
    table.insert(self.slots, slotId)
end

function ObservableMapInventory:getItem(slotId)
    return self.data:Lookup("items", slotId)
end

function ObservableMapInventory:setItem(slotId, item)
    self.data:Set("items", slotId, item)
    self:slotUpdated(slotId)
end

function ObservableMapInventory:getSlots()
    return self.slots
end

function ObservableMapInventory:copyItem(item)
    return item:DeepCopy()
end

function ObservableMapInventory:subscribe(observer)
    self.data:Subscribe(observer)
end

function ObservableMapInventory:slotUpdated(slotId)
    self.data.dirtySlot = slotId
    self.data:NotifyObservers()
end

function ObservableMapInventory:new(o)
    o = Inventory:new(o or {})
    o.data = o.data or tablex.observable()
    o.data.items = tablex.observable()
    o.slots = o.slots or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

return ObservableMapInventory