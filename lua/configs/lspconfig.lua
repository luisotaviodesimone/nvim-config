-- EXAMPLE
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "html", "cssls", "ts_ls", "gopls", "pyright", "yamlls", "marksman", "tailwindcss", "jdtls" }

-- LSP settings (for overriding per client)
local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    handlers = handlers,
  }
end

local yamlls_config = require "configs.yamlls"

lspconfig.yamlls.setup(yamlls_config)

-- c++
lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.signatureHelper = false
    on_attach(client, bufnr)
  end,
  on_init = on_init,
  capabilities = capabilities,
}

-- emmet
lspconfig.emmet_language_server.setup {
  filetypes = {
    "css",
    "eruby",
    "html",
    "javascript",
    "javascriptreact",
    "less",
    "sass",
    "scss",
    "pug",
    "typescriptreact",
  },
}
