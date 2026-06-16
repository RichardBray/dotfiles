-- Firecrawl base46 theme (NvChad)
-- Ported from the Firecrawl VS Code dark theme. Orange-forward, near-black bg.

local M = {}

M.base_30 = {
  white = "#d4d4d4",
  darker_black = "#181818",
  black = "#1e1e1e", --  nvim bg
  black2 = "#252526",
  one_bg = "#2a2a2a",
  one_bg2 = "#333333",
  one_bg3 = "#3a3a3a",
  grey = "#4a4a4a",
  grey_fg = "#585858",
  grey_fg2 = "#646464",
  light_grey = "#858585",
  red = "#f44747",
  baby_pink = "#FF9D4D",
  pink = "#fdba74",
  line = "#333333", -- for lines like vertsplit
  green = "#a0a0a0",
  vibrant_green = "#b5cea8",
  nord_blue = "#FF9D4D",
  blue = "#E97318",
  yellow = "#d7ba7d",
  sun = "#FFA500",
  purple = "#DCDCAA",
  dark_purple = "#c9a86a",
  teal = "#ce9178",
  orange = "#E97318",
  cyan = "#DCDCAA",
  statusline_bg = "#202020",
  lightbg = "#2a2a2a",
  pmenu_bg = "#E97318",
  folder_bg = "#E97318",
}

M.base_16 = {
  base00 = "#1e1e1e",
  base01 = "#252526",
  base02 = "#5a3a1a",
  base03 = "#52525b",
  base04 = "#cccccc",
  base05 = "#d4d4d4",
  base06 = "#e0e0e0",
  base07 = "#ffffff",
  base08 = "#fdba74",
  base09 = "#E97318",
  base0A = "#d7ba7d",
  base0B = "#ce9178",
  base0C = "#DCDCAA",
  base0D = "#DCDCAA",
  base0E = "#E97318",
  base0F = "#d16969",
}

M.polish_hl = {
  treesitter = {
    ["@variable"] = { fg = M.base_30.pink },
    ["@variable.parameter"] = { fg = M.base_16.base05 },
    ["@variable.member"] = { fg = M.base_16.base05 },
    ["@property"] = { fg = M.base_16.base05 },
    ["@function"] = { fg = M.base_30.purple },
    ["@function.call"] = { fg = M.base_30.purple },
    ["@function.method"] = { fg = M.base_30.purple },
    ["@constructor"] = { fg = M.base_30.purple },
    ["@keyword"] = { fg = M.base_30.orange },
    ["@keyword.import"] = { fg = M.base_30.orange },
    ["@string"] = { fg = M.base_30.teal },
    ["@string.regexp"] = { fg = M.base_30.red },
    ["@constant"] = { fg = M.base_30.orange },
    ["@type"] = { fg = M.base_30.yellow },
    ["@operator"] = { fg = M.base_30.orange },
    ["@decorator"] = { fg = M.base_30.purple },
  },
}

M.type = "dark"

return M
