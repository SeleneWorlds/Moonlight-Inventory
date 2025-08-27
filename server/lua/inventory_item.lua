local InventoryItem = {}

function InventoryItem:decrease(amount)
    self.inventory:removeItemAt(self.slotId, amount)
end

function InventoryItem:fromInventorySlot(inventory, slot)
    local o = {
        inventory = inventory,
        slotId = slot.Name,
        owner = slot.Owner,
        slot = slot,
        content = slot.Value,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

return InventoryItem