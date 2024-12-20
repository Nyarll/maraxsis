---does the same thing as swap_nightvision_to_correct_prototype, but only for one equipment
---@param grid LuaEquipmentGrid
---@param surface LuaSurface
---@param equipment LuaEquipment
local function swap_nightvision(grid, surface, equipment)
    local equipment_name = equipment.name
    local position = equipment.position
    local target
    if surface.name == maraxsis.TRENCH_SURFACE_NAME then
        if equipment_name:match("%-disabled$") then return end
        target = equipment_name .. "-disabled"
    else
        target = equipment_name:gsub("%-disabled$", "")
        if target == equipment_name then return end
    end

    local all_nightvision = prototypes.get_equipment_filtered {{filter = "type", type = "night-vision-equipment"}}
    if not all_nightvision[target] then return end

    local energy = equipment.energy
    grid.take {equipment = equipment}
    local new_equipment = grid.put {name = target, position = position}
    new_equipment.energy = energy
end

---darkness is a core mechanic in maraxsis. disable nightvision when entering a trench & enable it when leaving.
---@param grid LuaEquipmentGrid
---@param surface LuaSurface
local function swap_nightvision_to_correct_prototype(grid, surface)
    for _, equipment in pairs(grid.equipment) do
        if equipment.type == "night-vision-equipment" then
            swap_nightvision(grid, surface, equipment)
        end
    end
end

maraxsis.on_event({
    defines.events.on_player_changed_surface,
    defines.events.on_player_armor_inventory_changed,
    defines.events.on_player_created,
}, function(event)
    if storage.stop_infinite_nightvision_recursion_loop then return end

    local player = game.get_player(event.player_index)
    if not player then return end
    local armor = player.get_inventory(defines.inventory.character_armor)
    if not armor then return end

    for i = 1, #armor do
        local stack = armor[i]
        if stack.valid_for_read and stack.is_armor then
            local grid = stack.grid
            if grid then
                swap_nightvision_to_correct_prototype(grid, player.surface)
            end
        end
    end
end)

maraxsis.on_event(defines.events.on_equipment_inserted, function(event)
    local equipment = event.equipment
    if not equipment.valid or equipment.type ~= "night-vision-equipment" then return end
    local grid = event.grid
    if not grid.valid then return end

    for _, player in pairs(game.players) do
        local armor = player.get_inventory(defines.inventory.character_armor)
        if not armor then goto continue end
        for i = 1, #armor do
            local stack = armor[i]
            if stack.valid_for_read and stack.is_armor and stack.grid == grid then
                swap_nightvision(grid, player.surface, equipment)
            end
        end
        ::continue::
    end
end)
