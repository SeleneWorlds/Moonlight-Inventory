local InventoryItem = require("moonlight-inventory.server.lua.inventory_item")

local Inventory = {}

function Inventory:findInventoryItems(filter)
    local items = {}
    for _, slotId in ipairs(self:getSlots()) do
        local item = self:getItem(item)
        if item and (not filter or filter(item)) then
            table.insert(items, InventoryItem:fromInventorySlot(self, slotId, item))
        end
    end
    return items
end

function Inventory:addItem(item)
    local emptySlots = {}
    local rest = self:getItemCount(item)
    for _, slotId in ipairs(self:getSlots()) do
        local slotItem = self:getItem(slotId)
        if slotItem ~= nil then
            if self:canMergeItem(slotItem, item) then
                local maxCount = math.min(self:getItemMaxCount(slotItem), self:getSlotMaxCount(slotId))
                local spaceLeft = maxCount - self:getItemCount(slotItem)
                if spaceLeft > 0 then
                    local amount = math.min(spaceLeft, rest)
                    local mergedItem = self:mergeItems(slotItem, amount == self:getItemCount(item) and item or self:copyItemWithCount(item, amount))
                    if mergedItem then
                        self:setItem(slotId, mergedItem)
                        rest = rest - amount
                    end
                end
            end
        else
            table.insert(emptySlots, slotId)
        end
        if rest <= 0 then
            return 0
        end
    end
    for _, slotId in ipairs(emptySlots) do
        local amount = math.min(self:getSlotMaxCount(slotId), rest)
        self:setItem(slotId, amount == self:getItemCount(item) and item or self:copyItemWithCount(item, amount))
        rest = rest - amount
        if rest <= 0 then
            return 0
        end
    end
    return rest
end

function Inventory:increaseCountAt(slotId, amount)
    if amount < 0 then
        return self.decreaseItemAt(slotId, math.abs(amount))
    end
    local item = self:getItem(slotId)
    local count = self:getItemCount(item)
    self:setItemCount(item, count + amount)
    self:slotUpdated(slotId)
    return 0
end

function Inventory:decreaseCountAt(slotId, amount)
    if amount < 0 then
        return self.increaseItemAt(slotId, math.abs(amount))
    end
    local item = self:getItem(item)
    local count = self:getItemCount(item)
    if amount < count then
        self:setItemCount(item, count - amount)
        self:slotUpdated(slotId)
        return 0
    else
        self:setItem(slotId, nil)
        return math.max(0, amount - count)
    end
end

function Inventory:getInventoryItem(slotId)
    local item = self:getItem(slotId)
    if item then
        return InventoryItem:fromInventorySlot(self, slotId, item)
    end
end

function Inventory:setItemCount(item, count)
    item.count = count
end

function Inventory:getItemCount(item)
    return item.count
end

function Inventory:getItemMaxCount(item)
    return 64
end

function Inventory:getSlotMaxCount(slotId)
    return 64
end

function Inventory:slotUpdated(slotId)
end

function Inventory:countItem(filter)
    local count = 0
    for _, slotId in ipairs(self:getSlots()) do
        local item = self:getItem(slotId)
        if item and filter(item) then
            count = count + self:getItemCount(item)
        end
    end
    return count
end

function Inventory:canMergeItem()
    return false
end

function Inventory:mergeItems(item, other)
    return nil
end

function Inventory:getSlotCount()
    return #self:getSlots()
end

function Inventory:copyItemWithCount(item, count)
    local copy = self:copyItem(item)
    self:setItemCount(copy, count)
    return copy
end

function Inventory:getItem(slotId)
    error("Inventory:getItem is abstract and must be implemented in a subclass.")
end

function Inventory:setItem(slotId, item)
    error("Inventory:setItem is abstract and must be implemented in a subclass.")
end

function Inventory:getSlots()
    error("Inventory:getSlots is abstract and must be implemented in a subclass.")
end

function Inventory:copyItem(item)
    error("Inventory:copyItem is abstract and must be implemented in a subclass.")
end

function Inventory:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

return Inventory