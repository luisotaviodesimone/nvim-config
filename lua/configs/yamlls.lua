local get_file_name = require("custom.utils").get_file_name
local is_avoidable = require("custom.utils").is_avoidable

-- local cfg = require("yaml-companion").setup {
--   -- detect k8s schemas based on file content
--   builtin_matchers = {
--     kubernetes = { enabled = true },
--   },
--   -- schemas available in Telescope picker
--   schemas = {
--     -- not loaded automatically, manually select with
--     -- :Telescope yaml_schema
--     {
--       name = "Argo CD Application",
--       uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json",
--     },
--     {
--       name = "SealedSecret",
--       uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/bitnami.com/sealedsecret_v1alpha1.json",
--     },
--     {
--       name = "Cloud Init",
--       uri = "https://raw.githubusercontent.com/canonical/cloud-init/main/cloudinit/config/schemas/versions.schema.cloud-config.json",
--     },
--     -- schemas below are automatically loaded, but added
--     -- them here so that they show up in the statusline
--     {
--       name = "Kustomization",
--       uri = "https://json.schemastore.org/kustomization.json",
--     },
--     {
--       name = "GitHub Workflow",
--       uri = "https://json.schemastore.org/github-workflow.json",
--     },
--   },

--   lspconfig = {
--     settings = {
--       yaml = {
--         validate = true,
--         schemaStore = {
--           enable = false,
--           url = "",
--         },

--         -- schemas from store, matched by filename
--         -- loaded automatically
--         schemas = require("schemastore").yaml.schemas {
--           select = {
--             "kustomization.yaml",
--             "GitHub Workflow",
--             "docker-compose.yml",
--           },
--         },
--       },
--     },
--   },
-- }

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

-- return cfg
return yamlls_config
