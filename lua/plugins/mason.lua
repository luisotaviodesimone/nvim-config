return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "lua-language-server",
      "gopls",
      "clangd",
      "sql-formatter",
      "yaml-language-server",
      "stylua",
      "html-lsp",
      "css-lsp",
      "prettier",
    },
  },
}
