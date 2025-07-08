return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "supermaven-inc/supermaven-nvim", -- Reference the standalone supermaven plugin
    },
    opts = function(_, opts)
      -- Get a reference to the existing sources table or create a new one
      local sources = opts.sources or {}
      
      -- Add supermaven as a source to nvim-cmp with high priority
      table.insert(sources, 1, { name = "supermaven", group_index = 2 })
      
      -- Update the sources in the options
      opts.sources = sources
      
      -- Return the updated options
      return opts
    end,
  },
}

