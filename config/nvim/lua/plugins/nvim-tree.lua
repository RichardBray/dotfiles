return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    view = {
      width = 30,
      side = "right",
      relativenumber = true,
    },
    filters = {
      dotfiles = false,
    },
    renderer = {
      indent_markers = {
        enable = true,
      },
      icons = {
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
        },
      },
    },
  },
  config = function(_, opts)
    require("nvim-tree").setup(opts)
    vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle nvim-tree" })
    vim.keymap.set("n", "<leader>tf", "<cmd>NvimTreeFocus<CR>", { desc = "Focus nvim-tree" })
  end,
}

