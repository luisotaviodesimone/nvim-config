local cfg = require("yaml-companion").setup {
  -- detect k8s schemas based on file content
  builtin_matchers = {
    kubernetes = { enabled = true },
  },
  -- schemas available in Telescope picker
  schemas = {
    -- not loaded automatically, manually select with
    -- :Telescope yaml_schema
    {
      name = "Argo CD Application",
      uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json",
    },
    {
      name = "SealedSecret",
      uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/bitnami.com/sealedsecret_v1alpha1.json",
    },
    {
      name = "Cloud Init",
      uri = "https://raw.githubusercontent.com/canonical/cloud-init/main/cloudinit/config/schemas/versions.schema.cloud-config.json",
    },
    -- schemas below are automatically loaded, but added
    -- them here so that they show up in the statusline
    {
      name = "Kustomization",
      uri = "https://json.schemastore.org/kustomization.json",
    },
    {
      name = "GitHub Workflow",
      uri = "https://json.schemastore.org/github-workflow.json",
    },
  },

  lspconfig = {
    settings = {
      yaml = {
        validate = true,
        schemaStore = {
          enable = false,
          url = "",
        },

        -- schemas from store, matched by filename
        -- loaded automatically
        schemas = require("schemastore").yaml.schemas {
          select = {
            "kustomization.yaml",
            "GitHub Workflow",
            "docker-compose.yml",
          },
        },
      },
    },
  },
}

return cfg
