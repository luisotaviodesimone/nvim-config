require("nvim-treesitter").install {
  "bash",
  "css",
  "go",
  "gotmpl",
  "helm",
  "hcl",
  "html",
  "java",
  "javascript",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "prisma",
  "python",
  "terraform",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "vue",
  "yaml",
}
vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})
