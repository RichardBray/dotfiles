return {
		"jim-at-jibba/nvim-redraft",
    event = "VeryLazy",
		dependencies = {
			{ "folke/snacks.nvim", opts = { input = {} } },
		},
		config = function()
			require("nvim-redraft").setup({
				-- Optional configuration
				system_prompt = "You are a code editing assistant...",
				keybindings = {
					visual_edit = "<leader>ae",
				},
			})
		end,
		build = "cd ts && npm install && npm run build",
}
