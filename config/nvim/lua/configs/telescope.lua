local actions = require "telescope.actions"

require("telescope").setup {
  pickers = {
    buffers = {
      mappings = {
        i = {
          ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
          ["<c-w>"] = actions.delete_buffer,
        }
      }
    }
  }
}
