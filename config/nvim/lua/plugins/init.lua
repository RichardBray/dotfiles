return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "javascript",
        "typescript",
        "tsx",
        "lua",
        "vim",
        "vimdoc",
        "html",
        "css",
        "markdown",
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    },
  },

  {
    "numToStr/Comment.nvim",
  },
}
