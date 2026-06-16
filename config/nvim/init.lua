vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)
vim.wo.relativenumber = true

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
        styles = {
           sidebars = "transparent",
           floats = "transparent",
        },
    },
  },
  { import = "plugins" },
}, lazy_config)

-- load theme: rebuild the base46 cache when it's missing or the active theme
-- changed (e.g. toggling FIRECRAWL_FILMING between launches)
local theme = require("chadrc").base46.theme
local marker = vim.g.base46_cache .. ".theme"
local cached = vim.uv.fs_stat(marker) and (io.open(marker):read "*a") or nil
if not vim.uv.fs_stat(vim.g.base46_cache .. "defaults") or cached ~= theme then
  require("base46").load_all_highlights()
  local f = io.open(marker, "w")
  if f then
    f:write(theme)
    f:close()
  end
end
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-- In filming mode the Firecrawl base46 theme handles colors; otherwise use tokyonight
if vim.env.FIRECRAWL_FILMING ~= "1" then
  vim.cmd [[colorscheme tokyonight-night]]
end
