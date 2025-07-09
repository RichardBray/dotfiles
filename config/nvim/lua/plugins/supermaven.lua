return {
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<Tab>",
          clear_suggestion = "<C-]>",
          accept_word = "<C-j>",
        },
        ignore_filetypes = {}, -- Add filetypes to ignore if needed
        color = {
          suggestion_color = "#808080",
          cterm = 244,
        },
        log_level = "info", -- set to "off" to disable logging completely
        disable_inline_completion = false, -- enable inline completion when not using cmp
        disable_keymaps = false, -- disable built-in keymaps for manual control
        -- condition = function()
        --   return false -- disable supermaven when needed
        -- end,
      })
    end,
  },
}
