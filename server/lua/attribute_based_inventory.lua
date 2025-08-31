local ManagedTableInventory = require("moonlight-inventory.server.lua.managed_table_inventory")

local AttributeBasedInventory = ManagedTableInventory:new()

function AttributeBasedInventory:addToView(view)
    view:AddAttribute("inventory", self.attribute)
end

function AttributeBasedInventory:slotUpdated(slotId)
    self.data.dirtySlot = slotId
    self.attribute:Refresh()
end

function AttributeBasedInventory:new(attribute, slotIds, data)
    data = data or {}
    data.attribute = attribute
    data.data = attribute.Value
    data.slots = slotIds
    local o = ManagedTableInventory:new(data)
    setmetatable(o, self)
    self.__index = self
    return o
end

return AttributeBasedInventory