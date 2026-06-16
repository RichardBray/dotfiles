-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

-- Filming mode: launch nvim with FIRECRAWL_FILMING=1 to use the Firecrawl theme
local filming = vim.env.FIRECRAWL_FILMING == "1"

M.base46 = {
	theme = filming and "firecrawl" or "tokyonight",

	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },
}

return M
