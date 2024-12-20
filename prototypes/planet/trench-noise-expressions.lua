local TRENCH_MOVEMENT_FACTOR = maraxsis.TRENCH_MOVEMENT_FACTOR

data:extend {{
    type = "noise-expression",
    name = "maraxsis_trench_elevation",
    expression = [[
        maraxsis_elevation(x /]] .. TRENCH_MOVEMENT_FACTOR .. [[, y /]] .. TRENCH_MOVEMENT_FACTOR .. [[)
    ]]
}}

data:extend {{
    type = "noise-expression",
    name = "maraxsis_trench_wall",
    expression = [[
        maraxsis_trench_elevation < 0.03
    ]]
}}

data:extend {{
    type = "noise-expression",
    name = "maraxsis_lava_master",
    expression = [[
        multioctave_noise{
            x = x,
            y = y,
            persistence = 0.5,
            seed0 = map_seed,
            seed1 = 1344,
            octaves = 1,
            input_scale = 1/250,
            output_scale = 1
        }
    ]]
}}

data:extend {{
    type = "noise-expression",
    name = "maraxsis_lava_master_master",
    expression = [[
        multioctave_noise{
            x = x,
            y = y,
            persistence = 0.5,
            seed0 = map_seed,
            seed1 = 1344,
            octaves = 5,
            input_scale = 1/100,
            output_scale = 1
        }
    ]]
}}

data:extend {{
    type = "noise-expression",
    name = "maraxsis_lava_river_1",
    expression = [[
        multioctave_noise{
            x = x,
            y = y,
            persistence = 0.5,
            seed0 = map_seed,
            seed1 = 13442,
            octaves = 2,
            input_scale = 1/40,
            output_scale = 1
        }
    ]]
}}

data:extend {{
    type = "noise-expression",
    name = "maraxsis_lava_river_2",
    expression = [[
        multioctave_noise{
            x = x,
            y = y,
            persistence = 0.5,
            seed0 = map_seed,
            seed1 = 56443,
            octaves = 2,
            input_scale = 1/40,
            output_scale = 1
        }
    ]]
}}

data:extend {{
    type = "noise-expression",
    name = "maraxsis_lava_thickness",
    expression = [[
        min(if (
            maraxsis_lava_master_master < 0,
            lava_thickness * (0.3 + maraxsis_lava_master_master) / 0.3,
            lava_thickness
        ), 0.3)
    ]],
    local_expressions = {
        lava_thickness = [[
            abs(maraxsis_lava_master)
        ]]
    }
}}

data:extend {{
    type = "noise-function",
    name = "maraxsis_lava_tile",
    expression = [[
        (expanded_thickness > 0.15) *
        min(
            ((-expanded_thickness < maraxsis_lava_river_1) * (maraxsis_lava_river_1 < expanded_thickness)) +
            ((-expanded_thickness < maraxsis_lava_river_2) * (maraxsis_lava_river_2 < expanded_thickness))
        , 1)
    ]],
    local_expressions = {
        expanded_thickness = [[
            maraxsis_lava_thickness * lava_thickness_modifier
        ]]
    },
    parameters = {"lava_thickness_modifier"}
}}

data:extend {{
    type = "noise-expression",
    name = "maraxsis_3x3_grid",
    expression = [[
        ((y %% 3) == 0) * ((x %% 3) == 0)
    ]]
}}

data:extend {{
    type = "noise-expression",
    name = "maraxsis_4x4_grid",
    expression = [[
        ((y %% 4) == 0) * ((x %% 4) == 0)
    ]]
}}

data.raw.tile["lava-hot-underwater"].autoplace = {
    probability_expression = [[
        maraxsis_trench_wall * (maraxsis_lava_master_master > 0) * maraxsis_lava_tile(1)
    ]],
    order = "b[lava]-a[maraxsis]"
}

data.raw["simple-entity"]["maraxsis-lava-lamp"].autoplace = {
    probability_expression = "maraxsis_4x4_grid * (maraxsis_lava_master_master > 0) * maraxsis_trench_wall * maraxsis_lava_tile(1)",
    order = "b[lava]-a[maraxsis]"
}

data.raw["simple-entity"]["maraxsis-trench-wall-collisionless"].autoplace = {
    probability_expression = [[
        maraxsis_3x3_grid * (maraxsis_trench_elevation < 0.05) * (maraxsis_trench_elevation >= 0.028)
    ]],
    order = "b[lava]-a[maraxsis]"
}

data.raw.tile["out-of-map"].autoplace = {
    probability_expression = [[
        1 - maraxsis_trench_wall
    ]],
    order = "a[out-of-map]-a[maraxsis]"
}

data.raw.tile["volcanic-cracks-hot-underwater"].autoplace = {
    probability_expression = [[
        maraxsis_trench_wall * maraxsis_lava_tile(1.5)
    ]],
    order = "c[tile]-a[maraxsis]"
}

data.raw.tile["volcanic-cracks-warm-underwater"].autoplace = {
    probability_expression = [[
        maraxsis_trench_wall * maraxsis_lava_tile(2.5)
    ]],
    order = "d[tile]-a[maraxsis]"
}

data.raw.tile["volcanic-folds-underwater"].autoplace = {
    probability_expression = [[maraxsis_trench_wall]],
    order = "e[tile]-a[maraxsis]"
}
