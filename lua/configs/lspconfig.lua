local get_file_name = require("custom.utils").get_file_name
local is_avoidable = require("custom.utils").is_avoidable
local utils = require "custom.utils"

require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html",
  "cssls",
  "vtsls",
  "rust_analyzer",
  "gopls",
  "pyright",
  "yamlls",
  "marksman",
  "tailwindcss",
  "jdtls",
  "helm_ls",
  "terraformls",
  "vue_ls",
}

local vue_language_server_path = vim.fn.stdpath "data"
  .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

local vue_plugin = {
  name = "@vue/typescript-plugin",
  location = vue_language_server_path,
  languages = { "vue" },
  configNamespace = "typescript",
}

vim.lsp.config("vtsls", {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
  },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
})

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

  local avoidable_patterns = {
    ".*compose*.*",
    "*-ci*.*",
  }

  if not is_avoidable(file_name, avoidable_patterns) then
    schemas["kubernetes"] = "*"
  end
end

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.yml", "*.yaml" },
  callback = function()
    add_schemas()
  end,
})

vim.lsp.config("yamlls", yamlls_config)

vim.lsp.enable(servers)

--- @class LspKeymap
--- @field mode string
--- @field lhs string
--- @field rhs function
--- @field opts? vim.keymap.set.Opts

--- @type table<string, LspKeymap>
local methods_n_keymaps = {
  ["textDocument/definition"] = {
    mode = "n",
    lhs = "gd",
    rhs = function()
      vim.g["textDocument/definition"] = true
      vim.lsp.buf.definition()
    end,
    opts = { desc = "LSP Go to definition" },
  },
  ["textDocument/declaration"] = {
    mode = "n",
    lhs = "gD",
    rhs = function()
      vim.g["textDocument/declaration"] = true
      vim.lsp.buf.declaration()
    end,
    opts = { desc = "LSP Go to declaration" },
  },
  ["textDocument/implementation"] = {
    mode = "n",
    lhs = "gi",
    rhs = function()
      vim.g["textDocument/implementation"] = true
      vim.lsp.buf.implementation()
    end,
    opts = { desc = "LSP Go to implementation" },
  },
  ["textDocument/references"] = {
    mode = "n",
    lhs = "gr",
    rhs = function()
      vim.g["textDocument/references"] = true
      vim.lsp.buf.references()
    end,
    opts = { desc = "LSP Go to references" },
  },
}

local function on_lsp_attach(callback)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    callback(client, args.buf, methods_n_keymaps)
  end,
})
end


vim.api.nvim_create_autocmd("CursorMoved", {
  callback = function()
    for method, _ in pairs(methods_n_keymaps) do
      if vim.g[method] then
        vim.cmd "normal! zz"
        vim.g[method] = false
      end
    end
  end,
})

return {
  on_lsp_attach = on_lsp_attach,
}

