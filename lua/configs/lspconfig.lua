-- EXAMPLE
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local get_file_name = require("custom.utils").get_file_name

local servers = {
  "html",
  "cssls",
  "ts_ls",
  "gopls",
  "pyright",
  "yamlls",
  "marksman",
  "tailwindcss",
  "jdtls",
  "helm_ls",
  "terraformls",
}

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

-- local yamlls_config = require "configs.yamlls"

-- lspconfig.yamlls.setup(yamlls_config)

local yamlls_config = {
  settings = {
    yaml = {
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
      schemas = {
        -- ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
        -- ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
        -- ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/playbook"] = "*/*play*/*/*.yml",
        -- ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
        -- ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
        -- ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
        -- ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
        ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "*-ci*.{yml,yaml}",
        -- ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
        -- ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*compose*.{yml,yaml}",
        -- ["https://raw.githubusercontent.com/datreeio/CRDs-catalog/refs/heads/main/argoproj.io/application_v1alpha1.json"] = "*.application.{yml,yaml}",
      },
      validate = true,
      completion = true,
      hover = true,
      format = {
        enabled = false,
      },
    },
  },
}

-- get file name to add schemas
local function add_schemas()
  local file_name = get_file_name()
  if not file_name then
    return
  end

  local schemas = yamlls_config.settings.yaml.schemas
  if not file_name:match ".*compose*.*" then
    schemas["kubernetes"] = "*"
  end
end

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.yml", "*.yaml" },
  callback = function()
    add_schemas()
  end,
})

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
    "htmldjango",
  },
}
