local collision_mask_util = require("collision-mask-util")

require "prototypes.collision-mask"
require "prototypes.swimming"

data.raw["technology"]["maraxsis-promethium-productivity"].unit.ingredients = table.deepcopy(data.raw["technology"]["research-productivity"].unit.ingredients)

data.raw.radar["maraxsis-sonar"].next_upgrade = nil -- fix crash with 5dim

-- alien biomes compatibility
for _, planet in pairs{"maraxsis", "maraxsis-trench"} do
    planet = data.raw.planet[planet]
    local decoratives = planet.map_gen_settings.autoplace_settings.decorative.settings
    for name in pairs(decoratives) do
        local decorative = data.raw["optimized-decorative"][name]
        if not decorative then
            error("Decorative " .. name .. " not found")
        elseif not decorative.autoplace then
            decoratives[name] = nil
        end
    end
end

-- more alien biomes compatibility
if mods["alien-biomes"] then
    for _, tile in pairs(data.raw.tile) do
        if tile.name:find("%-underwater") and tile.collision_mask.layers[maraxsis_collision_mask] then
            tile.collision_mask.layers.item = nil
        end     
    end
end

-- 5dim compatibility
for prototype in pairs(defines.prototypes.entity) do
    for name, entity in pairs(data.raw[prototype] or {}) do
        local next_upgrade = data.raw[prototype][entity.next_upgrade or ""]
        if next_upgrade then
            local collision_mask_1 = collision_mask_util.get_mask(entity)
            local collision_mask_2 = collision_mask_util.get_mask(next_upgrade)
            if not collision_mask_util.masks_are_same(collision_mask_1, collision_mask_2) then
                entity.next_upgrade = nil
            end
        else
            entity.next_upgrade = nil
        end
        if not entity.minable then
            entity.next_upgrade = nil
        end
    end
end

for _, recipe in pairs(data.raw.recipe) do
    if recipe.category == "maraxsis-hydro-plant-or-assembling" then
        recipe.always_show_made_in = true
    end
end

data.raw["equipment-grid"]["maraxsis-diesel-submarine-equipment-grid"].equipment_categories = table.deepcopy(data.raw["equipment-grid"]["spidertron-equipment-grid"].equipment_categories)
data.raw["equipment-grid"]["maraxsis-nuclear-submarine-equipment-grid"].equipment_categories = table.deepcopy(data.raw["equipment-grid"]["spidertron-equipment-grid"].equipment_categories)
