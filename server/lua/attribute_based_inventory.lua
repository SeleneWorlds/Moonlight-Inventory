local ManagedTableInventory = require("moonlight-inventory.server.lua.managed_table_inventory")

local AttributeBasedInventory = ManagedTableInventory:new()

function AttributeBasedInventory:addToView(view)
    view:AddAttribute("inventory", self.attribute)
end

function AttributeBasedInventory:slotUpdated(slotId)
    table.insert(self.dirtySlots, slotId)
    self.attribute:Refresh()
    self.dirtySlots = {}
end

function AttributeBasedInventory:new(attribute)
    local o = ManagedTableInventory:new({
        attribute = attribute,
        dirtySlots = {},
        data = attribute.Value
    })
    setmetatable(o, self)
    self.__index = self
    return o
end

return AttributeBasedInventory