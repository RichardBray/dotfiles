require("nvchad.configs.lspconfig").defaults()

local nvlsp = require "nvchad.configs.lspconfig"
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.diagnostic.config({
  virtual_text = true,
  float = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

require("mason-lspconfig").setup({
  ensure_installed = { "gopls", "ts_ls" },
})

vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })

vim.lsp.config("ruff", {
  capabilities = capabilities,
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
})

vim.lsp.config("gopls", {
  capabilities = capabilities,
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
})

vim.lsp.config("ts_ls", {
  capabilities = capabilities,
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
})

vim.lsp.config("svelte", {
  capabilities = capabilities,
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  filetypes = { "svelte" },
})

local servers = { "html", "cssls" }

for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, {
    capabilities = capabilities,
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
  })
end

for _, lsp in ipairs({ "html", "cssls", "ts_ls", "svelte", "gopls", "ruff" }) do
  vim.lsp.enable(lsp)
end
