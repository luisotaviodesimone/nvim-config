require("csvview").setup { view = { display_mode = "border" } }
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "csv", "tsv" },
  callback = function()
    vim.cmd "CsvViewEnable"
  end,
})

