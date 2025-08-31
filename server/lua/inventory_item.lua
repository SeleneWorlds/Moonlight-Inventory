local InventoryItem = {}

function InventoryItem:increase(amount)
    self.inventory:increaseCountAt(self.slotId, amount)
end

function InventoryItem:decrease(amount)
    self.inventory:decreaseCountAt(self.slotId, amount)
end

function InventoryItem:fromInventorySlot(inventory, slotId, item)
    local o = {
        inventory = inventory,
        slotId = slotId,
        item = item
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

return InventoryItem