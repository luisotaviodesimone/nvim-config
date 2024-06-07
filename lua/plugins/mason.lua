return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "lua-language-server",
      "gopls",
      "clangd",
      "stylua",
      "html-lsp",
      "css-lsp",
      "prettier",
    },
  },
}
