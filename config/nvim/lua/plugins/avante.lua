return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,
  opts = {
    provider = "openai",
    providers = {
      openai = {
        endpoint = "https://api.openai.com/v1",
        model = "gpt-4.1",
        timeout = 30000,
        extra_request_body = {
          max_completion_tokens = 8192,
          temperature = 0,
        },
      },
    },
    system_prompt = function()
      local ok, mcphub = pcall(require, "mcphub")
      if ok and mcphub then
        local hub = mcphub.get_hub_instance()
        if hub then
          return hub:get_active_servers_prompt()
        end
      end
      -- Fallback prompt if mcphub is not available or returns nil
      return "You are a helpful AI assistant. Answer the user's questions as best you can."
    end,
    custom_tools = function()
      local ok, mcphub_ext = pcall(require, "mcphub.extensions.avante")
      if ok and mcphub_ext then
        return {
          mcphub_ext.mcp_tool(),
        }
      end
      -- Return empty table if mcphub is not available
      return {}
    end,
  },
  build = "make",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "echasnovski/mini.pick",
    "nvim-telescope/telescope.nvim",
    "hrsh7th/nvim-cmp",
    "ibhagwan/fzf-lua",
    "nvim-tree/nvim-web-devicons",
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
        },
      },
    },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
