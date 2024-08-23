local collision_mask = {'ground-tile', 'rail-layer', 'colliding-with-tiles-only'}

local colors = { -- default sub colors before they are tinted at runtime
    {195, 136, 24},
    {144, 31, 15},
    {14, 94, 146},
    {64, 12, 146},
}

local movement_energy_consumption = {
    1300,
    3000,
    6500,
    12000,
}

local burner_energy_sources = {
    {
        type = 'burner',
        fuel_category = 'jerry',
        effectivity = 1,
        fuel_inventory_size = 4,
        burnt_inventory_size = 4,
    },
    {
        type = 'burner',
        fuel_categories = {'quantum', 'nexelit'},
        effectivity = 1,
        fuel_inventory_size = 3,
        burnt_inventory_size = 3,
    },
    {
        type = 'burner',
        fuel_category = 'nuclear',
        effectivity = 1,
        fuel_inventory_size = 2,
        burnt_inventory_size = 2,
    },
    {
        type = 'burner',
        fuel_category = 'antimatter',
        effectivity = 1,
        fuel_inventory_size = 1,
        burnt_inventory_size = 0,
    },
}

for i = 1, 4 do
    local name = 'submarine-mk0' .. i
    local icon = '__pystellarexpeditiongraphics__/graphics/icons/submarine-mk0' .. i .. '.png'

    local item = {
        type = 'item',
        name = name,
        icon = icon,
        icon_size = 64,
        icon_mipmaps = nil,
        subgroup = 'pystellarexpedition-buildings-mk0' .. i,
        order = 'vga',
        place_result = name,
        stack_size = 1,
        flags = {'not-stackable'},
    }

    local item_tagged = {
        type = 'item-with-tags',
        name = name .. '-tagged',
        localised_description = {
            '?',
            {'', '[font=default-bold]', {'item-description.tagged-submarine-warning'}, '[/font]', {'entity-description.' .. name}},
            {'', '[font=default-bold]', {'item-description.tagged-submarine-warning'}, '[/font]'},
        },
        icon = icon,
        icon_size = 64,
        icon_mipmaps = nil,
        subgroup = 'pystellarexpedition-buildings-mk0' .. i,
        order = 'vgb',
        place_result = name,
        stack_size = 1,
        flags = {'not-stackable'},
    }

    local recipe = {
        type = 'recipe',
        name = name,
        ingredients = {
            {'iron-plate', 100},
        },
        result = name,
        enabled = false,
        energy_required = 10,
        category = 'crafting',
    }

    local lamp_layer = {
        direction_count = 64,
        frame_count = 1,
        repeat_count = 2,
        draw_as_glow = true,
        shift = {0, 0},
        scale = 1,
        stripes = {},
        height = 256,
        width = 256,
    }

    local mask_layer = {
        direction_count = 64,
        frame_count = 1,
        repeat_count = 2,
        shift = {0, 0},
        scale = 1,
        stripes = {},
        height = 256,
        width = 256,
        apply_runtime_tint = true,
        tint = {0.6, 0.6, 0.6}
    }

    local full_body_layer = {
        direction_count = 64,
        frame_count = 2,
        shift = {0, 0},
        scale = 1,
        stripes = {},
        height = 256,
        width = 256,
    }

    local shadow_layer = {
        direction_count = 64,
        frame_count = 1,
        repeat_count = 2,
        draw_as_shadow = true,
        shift = {6, 6},
        scale = 1,
        stripes = {},
        height = 256,
        width = 256,
    }

    for direction = 1, 64 do
        direction = (direction - 17) % 64 + 1
        if direction >= 34 and direction <= 64 then
            table.insert(lamp_layer.stripes, {
                filename = '__pypostprocessing__/empty.png',
                width_in_frames = 1,
                height_in_frames = 1,
            })
        else
            table.insert(lamp_layer.stripes, {
                filename = '__pystellarexpeditiongraphics__/graphics/entity/submarine/light/Sub-Mk1-LampMask-' .. direction .. '.png',
                width_in_frames = 1,
                height_in_frames = 1,
            })
        end
        table.insert(mask_layer.stripes, {
            filename = '__pystellarexpeditiongraphics__/graphics/entity/submarine/mask/Sub-Mk1-ColorMask-' .. direction .. '.png',
            width_in_frames = 1,
            height_in_frames = 1,
        })
        table.insert(shadow_layer.stripes, {
            filename = '__pystellarexpeditiongraphics__/graphics/entity/submarine/shadow/Sub-Mk1-Shadow-' .. direction .. '.png',
            width_in_frames = 1,
            height_in_frames = 1,
        })
        for j = 1, 2 do
            table.insert(full_body_layer.stripes, {
                filename = '__pystellarexpeditiongraphics__/graphics/entity/submarine/body/Sub-Mk1-' .. direction .. '-' .. j .. '.png',
                width_in_frames = 1,
                height_in_frames = 1,
            })
        end
    end

    local translucent_mask_layer = table.deepcopy(mask_layer)
    translucent_mask_layer.tint = {0.6, 0.6, 0.6, 0.6}

    local translucent_body_layer = table.deepcopy(full_body_layer)
    translucent_body_layer.tint = {1, 1, 1, 0.6}

    local mask_body_layer = table.deepcopy(mask_layer)
    mask_body_layer.tint = colors[i]
    mask_body_layer.apply_runtime_tint = false

    for _, layer in pairs{lamp_layer, mask_layer, shadow_layer, full_body_layer, translucent_body_layer, translucent_mask_layer, mask_body_layer} do
        layer.animation_speed = 1/4
        layer.max_advance = 1
    end

    local entity = table.deepcopy(data.raw['spider-vehicle']['phadaisus'])
    entity.name = name
    entity.icon = icon
    entity.icon_size = 64
    entity.icon_mipmaps = nil
	entity.torso_bob_speed = 0.4
    entity.minable.result = name .. '-tagged'
    entity.placeable_by = {item = name, count = 1}
    entity.max_health = 3000 * 2 ^ (i - 1)
    entity.collision_box = {{-1.4, -1.4}, {1.4, 1.4}}
    entity.selection_box = {{-1.4, -1.4}, {1.4, 1.4}}
    entity.drawing_box = {{-2.8, -2.8}, {2.8, 2.8}}
    entity.light_animation = nil
    entity.tank_driving = true
    entity.collision_mask = collision_mask
    entity.minimap_representation = {
		filename = '__pystellarexpeditiongraphics__/graphics/entity/submarine/map/submarine-map-tag.png',
		flags = {'icon'},
        tint = h2o2.tints[i],
		size = {64, 64}
	}
    entity.working_sound = table.deepcopy(data.raw.car.car.working_sound)
    entity.open_sound = nil
    entity.movement_energy_consumption = movement_energy_consumption[i] .. 'kW'
    entity.weight = entity.weight / (i + 1) * 4 * movement_energy_consumption[i] / 800
    entity.burner = burner_energy_sources[i]
    entity.guns = table.deepcopy(data.raw['spider-vehicle']['spidertron'].guns)
    entity.close_sound = nil
    entity.resistances = {
        {type = 'fire', percent = 100},
        {type = 'impact', percent = 100},
    }
    entity.has_belt_immunity = true
    if i > 1 then entity.immune_to_tree_impacts = true end
    if i > 2 then entity.immune_to_rock_impacts = true end
    entity.immune_to_cliff_impacts = true
    entity.inventory_size = i * 30
    entity.trash_inventory_size = 10
    entity.turret_animation = nil
    entity.friction = entity.friction * 5
    entity.rotation_speed = entity.rotation_speed * 0.2 * (i / 2 + 0.5)
    entity.spider_engine.legs[1].leg = 'submarine-leg'
    entity.graphics_set.light = {
        {
            color = {
                b = 1,
                g = 1,
                r = 1
            },
            intensity = 0.4,
            minimum_darkness = 0.3,
            size = 25
        },
        {
            color = {
                b = 1,
                g = 1,
                r = 1
            },
            minimum_darkness = 0.3,
            picture = {
                filename = '__core__/graphics/light-cone.png',
                flags = {
                    'light'
                },
                height = 200,
                priority = 'extra-high',
                scale = 2,
                width = 200
            },
            shift = {0, -15.4*1.5},
            size = 3,
            intensity = 0.8,
            type = 'oriented'
        }
    }
    entity.graphics_set.animation = {
        direction_count = 64,
        layers = {
            lamp_layer,
            full_body_layer,
            mask_body_layer,
            translucent_mask_layer,
            mask_layer,
            shadow_layer,
        }
    }

    local tech = {
        type = 'technology',
        name = name,
        icon = '__pystellarexpeditiongraphics__/graphics/technology/deep-sea-exploration-mk0' .. i .. '.png',
        icon_size = 128,
        icon_mipmaps = nil,
        effects = {
            {
                type = 'unlock-recipe',
                recipe = name,
            },
        },
        prerequisites = {},
        unit = {
            count = 100,
            ingredients = {
                {'automation-science-pack', 1},
                {'logistic-science-pack', 1},
                {'chemical-science-pack', 1},
            },
            time = 30,
        },
        order = 'a',
    }

    data:extend{item, item_tagged, recipe, entity, tech}
end

data.raw.item['antimatter'].fuel_category = 'antimatter'
data.raw.item['antimatter'].stack_size = 5

data:extend{{
    type = 'custom-input',
    key_sequence = '',
    linked_game_control = 'toggle-driving',
    name = 'toggle-driving',
}}

local vehicle_leg = table.deepcopy(data.raw['spider-leg']['py-fake-spidertron-leg'])
vehicle_leg.collision_mask = collision_mask
vehicle_leg.name = 'submarine-leg'
vehicle_leg.part_length = 0.1
data:extend{vehicle_leg}