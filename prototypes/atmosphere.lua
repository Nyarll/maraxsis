data:extend {{
    type = "fluid",
    name = "maraxsis-atmosphere",
    default_temperature = 25,
    max_temperature = 100,
    heat_capacity = "1kJ",
    base_flow_rate = data.raw.fluid.steam.base_flow_rate,
    base_color = {1, 1, 1},
    flow_color = {0.5, 0.5, 1},
    icon = "__maraxsis__/graphics/icons/atmosphere.png",
    icon_size = 64,
    gas_temperature = 25,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-atmosphere",
    category = "chemistry",
    energy_required = 10,
    ingredients = {},
    results = {
        {type = "fluid", name = "maraxsis-atmosphere", amount = 100}
    },
    enabled = false,
    main_product = "maraxsis-atmosphere",
    surface_conditions = {{
        property = "pressure",
        min = 1000,
        max = 2000,
    }}
}}

data:extend {{
    type = "fluid",
    name = "maraxsis-liquid-atmosphere",
    default_temperature = 25,
    max_temperature = 100,
    heat_capacity = "1kJ",
    base_flow_rate = data.raw.fluid.steam.base_flow_rate,
    flow_color = {1, 1, 1},
    base_color = {0.5, 0.5, 1},
    icon = "__maraxsis__/graphics/icons/liquid-atmosphere.png",
    icon_size = 64,
    gas_temperature = 100,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-liquid-atmosphere",
    category = "cryogenics",
    energy_required = 10,
    ingredients = {
        {type = "fluid", name = "maraxsis-atmosphere", amount = 100}
    },
    results = {
        {type = "fluid", name = "maraxsis-liquid-atmosphere", amount = 1}
    },
    enabled = false,
    main_product = "maraxsis-liquid-atmosphere",
    show_amount_in_title = true,
    allow_decomposition = false,
    allow_productivity = true,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-liquid-atmosphere-decompression",
    category = "maraxsis-hydro-plant",
    energy_required = 9,
    ingredients = {
        {type = "fluid", name = "maraxsis-liquid-atmosphere", amount = 1}
    },
    results = {
        {type = "fluid", name = "maraxsis-atmosphere", amount = 90}
    },
    enabled = false,
    main_product = "maraxsis-atmosphere",
    show_amount_in_title = true,
    allow_decomposition = false,
    allow_productivity = true,
}}

table.insert(data.raw.technology["cryogenic-plant"].effects, {
    type = "unlock-recipe",
    recipe = "maraxsis-liquid-atmosphere"
})

table.insert(data.raw.technology["cryogenic-plant"].effects, {
    type = "unlock-recipe",
    recipe = "maraxsis-liquid-atmosphere-decompression"
})