local InventoryItem = require("moonlight-inventory.server.lua.inventory_item")

local Inventory = {}

function Inventory:addToView(view)
    for _, slotId in ipairs(self.slotIds) do
        local slot = self.entity:GetOrCreateAttribute(slotId)
        view:AddAttribute(slotId, slot)
    end
end

function Inventory:getSlotCount(item)
    return #self.slotIds
end

function Inventory:getSlot(slotId)
    if type(slotId) == "number" then
        slotId = self.slotIds[slotId]
    end
    return self.entity:GetOrCreateAttribute(slotId)
end

function Inventory:findItems(filter)
    local items = {}
    for _, slotId in ipairs(self.slotIds) do
        local slot = self:getSlot(slotId)
        local item = slot.Value
        if item and (not filter or filter(item) then
            table.insert(items, InventoryItem:fromInventorySlot(self, slot))
        end
    end
    return items
end

function Inventory:addItem(item)
    for _, slotId in ipairs(self.slotIds) do
        local slot = self:getSlot(slotId)
        if slot.Value == nil then
            slot.Value = tablex.managed(item)
            return nil
        end
    end
    return item
end

function Inventory:increaseItemAt(slotId, amount)
    if amount < 0 then
        return self.decreaseItemAt(slotId, math.abs(amount))
    end
    local slot = self:getSlot(slotId)
    local item = slot.Value
    local count = item.count or 1
    item.count = count + amount
    slot:Refresh()
    return 0
end

function Inventory:decreaseItemAt(slotId, amount)
    if amount < 0 then
        return self.increaseItemAt(slotId, math.abs(amount))
    end
    local slot = self:getSlot(slotId)
    local item = slot.Value
    local count = item.count or 1
    if amount < count then
        item.count = count - amount
        slot:Refresh()
        return 0
    else
        slot.Value = nil
        return math.max(0, amount - count)
    end
end

function Inventory:getItem(slotId)
    local slot = self:getSlot(slotId)
    local item = slot.Value
    if item then
        return InventoryItem:fromInventorySlot(self, slot)
    end
end

function Inventory:countItem(filter)
    local count = 0
    for _, slotId in ipairs(self.slotIds) do
        local slot = self:getSlot(slotId)
        local item = slot.Value
        if item and filter(item) then
            count = count + (item.count or 1)
        end
    end
    return count
end

function Inventory:fromEntityAttributes(entity, slotIds)
    local o = {
        entity = entity,
        slotIds = slotIds
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

return Inventory