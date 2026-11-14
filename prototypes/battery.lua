local ze = require("__zombiesextended-core__.lib")
local cfg = require("configuration")

local subgroup = "equipment"

if ze.separate_tab() then
  subgroup  = "ds-equipment"
end

for x,battery in pairs(cfg.personal_battery) do
    
    ze.unlock(battery.technology, battery.name)
    
    data:extend(
        {       
            ze.recipe(battery),    
            {
                type = "item",
                name = battery.name,
                icon = "__zombiesextended-equipment__/graphics/icons/" .. battery.name .. ".png",
                icon_size = 64,
                placed_as_equipment_result = battery.name,
                subgroup = subgroup,
                order = "bz-" .. battery.order,
                default_request_amount = 5,
                stack_size = 20
            },
            {
                type = "battery-equipment",
                name = battery.name,
                sprite =
                {
                    filename = "__zombiesextended-equipment__/graphics/equipment/" .. battery.name .. ".png",
                    width = 32,
                    height = 64,
                    priority = "medium"
                },
                shape =
                {
                    width = 1,
                    height = 2,
                    type = "full"
                },
                energy_source =
                {
                    type = "electric",
                    buffer_capacity = battery.capacity,
                    usage_priority = "tertiary"
                },
                categories = {"armor"}
            }
        }
    )
end