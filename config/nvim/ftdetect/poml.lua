-- Set filetype for .poml files to use XML syntax highlighting
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.poml",
  callback = function()
    vim.bo.filetype = "xml"
  end,
})
