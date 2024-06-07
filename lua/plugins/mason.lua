return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "lua-language-server",
      "gopls",
      "clangd",
      "sql-formatter",
      "stylua",
      "html-lsp",
      "css-lsp",
      "prettier",
    },
  },
}
