const mapPalette = [
  {
    "id": "GRASS",
    "block": "minecraft:grass_block",
    "rgb": [127, 178, 56],
  },
  {
    "id": "SAND",
    "block": "minecraft:sandstone",
    "rgb": [247, 233, 163],
  },
  {
    "id": "FIRE",
    "block": "minecraft:redstone_block",
    "rgb": [255, 0, 0],
  },
  {
    "id": "ICE",
    "block": "minecraft:blue_ice",
    "rgb": [160, 160, 255],
  },
  {
    "id": "METAL",
    "block": "minecraft:iron_block",
    "rgb": [167, 167, 167],
  },
  {
    "id": "PLANT",
    "block": "minecraft:oak_leaves",
    "rgb": [0, 124, 0],
  },
  {
    "id": "SNOW",
    "block": "minecraft:snow",
    "rgb": [255, 255, 255],
  },
  {
    "id": "CLAY",
    "block": "minecraft:clay",
    "rgb": [164, 168, 184],
  },
  {
    "id": "DIRT",
    "block": "minecraft:dirt",
    "rgb": [151, 109, 77],
  },
  {
    "id": "STONE",
    "block": "minecraft:stonebrick",
    "rgb": [112, 112, 112],
  },
  {
    "id": "WOOD",
    "block": "minecraft:oak_planks",
    "rgb": [143, 119, 72],
  },
  {
    "id": "QUARTZ",
    "block": "minecraft:polished_diorite",
    "rgb": [255, 252, 245],
  },
  {
    "id": "COLOR_ORANGE",
    "block": "minecraft:orange_concrete",
    "rgb": [216, 127, 51],
  },
  {
    "id": "COLOR_MAGENTA",
    "block": "minecraft:magenta_concrete",
    "rgb": [178, 76, 216],
  },
  {
    "id": "COLOR_LIGHT_BLUE",
    "block": "minecraft:light_blue_concrete",
    "rgb": [102, 153, 216],
  },
  {
    "id": "COLOR_YELLOW",
    "block": "minecraft:yellow_concrete",
    "rgb": [229, 229, 51],
  },
  {
    "id": "COLOR_LIGHT_GREEN",
    "block": "minecraft:lime_concrete",
    "rgb": [127, 204, 25],
  },
  {
    "id": "COLOR_PINK",
    "block": "minecraft:pink_concrete",
    "rgb": [242, 127, 165],
  },
  {
    "id": "COLOR_GRAY",
    "block": "minecraft:gray_concrete",
    "rgb": [76, 76, 76],
  },
  {
    "id": "COLOR_LIGHT_GRAY",
    "block": "minecraft:light_gray_concrete",
    "rgb": [153, 153, 153],
  },
  {
    "id": "COLOR_CYAN",
    "block": "minecraft:cyan_concrete",
    "rgb": [76, 127, 153],
  },
  {
    "id": "COLOR_PURPLE",
    "block": "minecraft:purple_concrete",
    "rgb": [127, 63, 178],
  },
  {
    "id": "COLOR_BLUE",
    "block": "minecraft:blue_concrete",
    "rgb": [51, 76, 178],
  },
  {
    "id": "COLOR_BROWN",
    "block": "minecraft:brown_concrete",
    "rgb": [102, 76, 51],
  },
  {
    "id": "COLOR_GREEN",
    "block": "minecraft:green_concrete",
    "rgb": [102, 127, 51],
  },
  {
    "id": "COLOR_RED",
    "block": "minecraft:red_concrete",
    "rgb": [153, 51, 51],
  },
  {
    "id": "COLOR_BLACK",
    "block": "minecraft:black_concrete",
    "rgb": [25, 25, 25],
  },
  {
    "id": "GOLD",
    "block": "minecraft:gold_block",
    "rgb": [250, 238, 77],
  },
  {
    "id": "DIAMOND",
    "block": "minecraft:diamond_block",
    "rgb": [92, 219, 213],
  },
  {
    "id": "LAPIS",
    "block": "minecraft:lapis_block",
    "rgb": [74, 128, 255],
  },
  {
    "id": "EMERALD",
    "block": "minecraft:emerald_block",
    "rgb": [0, 217, 58],
  },
  {
    "id": "PODZOL",
    "block": "minecraft:spruce_planks",
    "rgb": [129, 86, 49],
  },
  {
    "id": "NETHER",
    "block": "minecraft:netherrack",
    "rgb": [112, 2, 0],
  },
  {
    "id": "TERRACOTTA_WHITE",
    "block": "minecraft:cherry_planks",
    "rgb": [209, 177, 161],
  },
  {
    "id": "TERRACOTTA_ORANGE",
    "block": "minecraft:orange_terracotta",
    "rgb": [159, 82, 36],
  },
  {
    "id": "TERRACOTTA_MAGENTA",
    "block": "minecraft:magenta_terracotta",
    "rgb": [149, 87, 108],
  },
  {
    "id": "TERRACOTTA_LIGHT_BLUE",
    "block": "minecraft:light_blue_terracotta",
    "rgb": [112, 108, 138],
  },
  {
    "id": "TERRACOTTA_YELLOW",
    "block": "minecraft:yellow_terracotta",
    "rgb": [186, 133, 36],
  },
  {
    "id": "TERRACOTTA_LIGHT_GREEN",
    "block": "minecraft:lime_terracotta",
    "rgb": [103, 117, 53],
  },
  {
    "id": "TERRACOTTA_PINK",
    "block": "minecraft:pink_terracotta",
    "rgb": [160, 77, 78],
  },
  {
    "id": "TERRACOTTA_GRAY",
    "block": "minecraft:gray_terracotta",
    "rgb": [57, 41, 35],
  },
  {
    "id": "TERRACOTTA_LIGHT_GRAY",
    "block": "minecraft:light_gray_terracotta",
    "rgb": [135, 107, 98],
  },
  {
    "id": "TERRACOTTA_CYAN",
    "block": "minecraft:cyan_terracotta",
    "rgb": [87, 92, 92],
  },
  {
    "id": "TERRACOTTA_PURPLE",
    "block": "minecraft:purple_terracotta",
    "rgb": [122, 73, 88],
  },
  {
    "id": "TERRACOTTA_BLUE",
    "block": "minecraft:blue_terracotta",
    "rgb": [76, 62, 92],
  },
  {
    "id": "TERRACOTTA_BROWN",
    "block": "minecraft:brown_terracotta",
    "rgb": [76, 50, 35],
  },
  {
    "id": "TERRACOTTA_GREEN",
    "block": "minecraft:green_terracotta",
    "rgb": [76, 82, 42],
  },
  {
    "id": "TERRACOTTA_RED",
    "block": "minecraft:red_terracotta",
    "rgb": [142, 60, 46],
  },
  {
    "id": "TERRACOTTA_BLACK",
    "block": "minecraft:black_terracotta",
    "rgb": [37, 22, 16],
  },
  {
    "id": "CRIMSON_NYLIUM",
    "block": "minecraft:crimson_nylium",
    "rgb": [189, 48, 49],
  },
  {
    "id": "CRIMSON_PLANKS",
    "block": "minecraft:crimson_planks",
    "rgb": [148, 63, 97],
  },
  {
    "id": "CRIMSON_STEM",
    "block": "minecraft:crimson_hyphae",
    "rgb": [92, 25, 29],
  },
  {
    "id": "WARPED_NYLIUM",
    "block": "minecraft:warped_nylium",
    "rgb": [22, 126, 134],
  },
  {
    "id": "WARPED_PLANKS",
    "block": "minecraft:warped_planks",
    "rgb": [58, 142, 140],
  },
  {
    "id": "WARPED_STEM",
    "block": "minecraft:warped_hyphae",
    "rgb": [86, 44, 62],
  },
  {
    "id": "WARPED_WART",
    "block": "minecraft:nether_wart_block",
    "rgb": [20, 180, 133],
  },
  {
    "id": "DEEPSLATE",
    "block": "minecraft:deepslate",
    "rgb": [100, 100, 100],
  },
  {
    "id": "RAW_IRON_BLOCK",
    "block": "minecraft:raw_iron_block",
    "rgb": [216, 175, 147],
  },
  {
    "id": "GLOW_LICHEN",
    "block": "minecraft:verdant_froglight",
    "rgb": [127, 167, 150],
  },
];
