local ze = require("__zombiesextended-core__.lib")
local cfg = require("configuration")

local subgroup = "military-equipment"

if ze.separate_tab() then
  subgroup  = "ds-equipment"
end

for x,pld in pairs(cfg.personal_laser_device) do
     
    ze.unlock(pld.technology, pld.name)
    
    data:extend(
        {
            ze.recipe(pld),
            {
                type = "item",
                name = pld.name,
                icon = "__zombiesextended-equipment__/graphics/icons/" .. pld.name .. ".png",
                icon_size = 64,
                placed_as_equipment_result = pld.name,
                subgroup = subgroup,
                order = "c" .. pld.order,
                default_request_amount = 5,
                stack_size = 20
            },
            {
                type = "active-defense-equipment",
                name = pld.name,
                sprite =
                {
                    filename = "__zombiesextended-equipment__/graphics/equipment/" .. pld.name .. ".png",
                    width = 351,
                    height = 516,
                    priority = "medium"
                },
                shape =
                {
                    width = 2,
                    height = 4,
                    type = "full"
                },
                energy_source =
                {
                    type = "electric",
                    usage_priority = "secondary-input",
                    buffer_capacity = pld.energy_consumption_kJ * 5 .. "kJ"
                },
                attack_parameters =
                {
                    type = "beam",
                    ammo_category = "laser",
                    cooldown = pld.cooldown,
                    range = pld.distance,
                    damage_modifier = pld.damage,
                    ammo_type =
                    {
                        energy_consumption = pld.energy_consumption_kJ .. "kJ",
                        action =
                        {
                            type = "direct",
                            action_delivery =
                            {
                                type = "beam",
                                beam = "laser-beam",
                                max_length = pld.distance,
                                duration = 40,
                                source_offset = {0, -1.31439 }
                            }
                        }
                    }
                },
                automatic = true,
                categories = {"armor"}
            },
        }
    )
end