local ze = require("__zombiesextended-core__.lib")
local cfg = require("configuration")

for x,projectile in pairs(cfg.personal_canno_projectile) do
    data:extend(
        {
            {
                type = "projectile",
                name = projectile.name,
                flags = {"not-on-map"},
                acceleration = projectile.acceleration,
                action =
                {
                    type = "direct",
                    action_delivery =
                    {
                        type = "instant",
                        target_effects =
                        {
                            {
                                type = "create-entity",
                                entity_name = "big-explosion"
                            },
                            {
                                type = "damage",
                                damage = {amount = projectile.damage, type = "explosion"}
                            },
                            {
                                type = "create-entity",
                                entity_name = "medium-scorchmark-tintable",
                                check_buildability = true
                            },
                            {
                                type = "invoke-tile-trigger",
                                repeat_count = 1,
                            },
                            {
                                type = "destroy-decoratives",
                                from_render_layer = "decorative",
                                to_render_layer = "object",
                                include_soft_decoratives = true,
                                include_decals = false,
                                invoke_decorative_trigger = true,
                                decoratives_with_trigger_only = false,
                                radius = 5
                            },
                            {
                                type = "nested-result",
                                action =
                                {
                                    type = "area",
                                    radius = projectile.radius,
                                    action_delivery =
                                    {
                                        type = "instant",
                                        target_effects =
                                        {
                                            {
                                                type = "damage",
                                                damage = {amount = projectile.damage, type = "explosion"}
                                            },
                                            {
                                                type = "create-entity",
                                                entity_name = "explosion"
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                },
                light = {intensity = 0.5, size = 4},
                -- 2.x redrew the rocket as one frame; the 1.1 strip no longer fits.
                animation = util.table.deepcopy(data.raw.projectile["rocket"].animation),
                shadow = util.table.deepcopy(data.raw.projectile["rocket"].shadow),
                smoke =
                {
                    {
                        name = "smoke-fast",
                        deviation = {0.15, 0.15},
                        frequency = 1,
                        position = {0, 1},
                        slow_down_factor = 1,
                        starting_frame = 3,
                        starting_frame_deviation = 5,
                        starting_frame_speed = 0,
                        starting_frame_speed_deviation = 5
                    }
                }
            },
        }
    )
end

local subgroup = "military-equipment"

if ze.separate_tab() then
  subgroup  = "ds-equipment"
end


for x,pcd in pairs(cfg.personal_cannon_device) do
    
    ze.unlock(pcd.technology, pcd.name)
    
    data:extend(
        {
            {
                type = "recipe",
                name = pcd.name,
                enabled = false,
                energy_required = 10,
                ingredients = ze.ingredients(pcd.ingredients),
                results = ze.result(pcd.name)
            }, 
            {
                type = "item",
                name = pcd.name,
                icon = "__zombiesextended-equipment__/graphics/icons/" .. pcd.name .. ".png",
                icon_size = 64,
                place_as_equipment_result = pcd.name,
                subgroup = subgroup,
                order = "c" .. pcd.order,
                default_request_amount = 5,
                stack_size = 20
            },
            {
                type = "active-defense-equipment",
                name = pcd.name,
                sprite =
                {
                    filename = "__zombiesextended-equipment__/graphics/equipment/" .. pcd.name .. ".png",
                    width = 351,
                    height = 516,
                    priority = "medium"
                },
                shape =
                {
                    width = pcd.width,
                    height = pcd.height,
                    type = "full"
                },
                ability_icon =
                {
                    filename = "__zombiesextended-equipment__/graphics/icons/personal-cannon-defense-mk2-remote.png",
                    flags = { "icon" },
                    mipmap_count = 4,
                    size = 64
                },
                energy_source =
                {
                    type = "electric",
                    usage_priority = "secondary-input",
                    buffer_capacity = pcd.energy
                },
                attack_parameters =
                {
                    type = "projectile",
                    ammo_category = "electric",
                    cooldown = pcd.cooldown,
                    damage_modifier = 0.5,
                    range = pcd.distance,
                    ammo_type =
                    {
                        type = "projectile",
                        energy_consumption = pcd.energy,
                        projectile = pcd.projectile,
                        speed = 1,
                        action =
                        {
                            {
                                type = "direct",
                                action_delivery =
                                {
                                    {
                                        type = "projectile",
                                        projectile = pcd.projectile,
                                        starting_speed = 1.28
                                    }
                                }
                            }
                        }
                    }
                },
                automatic = pcd.auto,
                categories = {"armor"}
            },
        }
    )
end

for x,pcd_remote in pairs(cfg.personal_cannon_device_remote) do
    
    ze.unlock(pcd_remote.technology, pcd_remote.name)
    
    data:extend(
        {
            {
                type = "recipe",
                name = pcd_remote.name,
                enabled = true,
                energy_required = pcd_remote.craft_time,
                ingredients = ze.ingredients(pcd_remote.ingredients),
                results = ze.result(pcd_remote.name)
            },
            {
                type = "capsule",
                name = pcd_remote.name,
                icon = "__zombiesextended-equipment__/graphics/icons/" ..  pcd_remote.name .. ".png",
                icon_size = 64,
                capsule_action =
                {
                    type = "equipment-remote",
                    equipment = pcd_remote.personal_cannon_device
                },
                subgroup = subgroup,
                order = "c" .. pcd_remote.order,
                stack_size = 1
            }
        }
    )
end