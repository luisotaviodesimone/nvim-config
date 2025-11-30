require "custom.utils"

local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = { "isort", "black" },
    -- Use a sub-list to run only the first available formatter
    typescriptreact = { "prettierd", "prettier" },
    typescript = { "prettierd", "prettier" },
    javascript = { "prettierd", "prettier" },
    sql = { "sql_formatter" },
    xml = { "xmllint" },
    json = { "fixjson" },
    jsonc = { "fixjson" },
    bash = { "beautysh" },
    sh = { "beautysh" },
    yaml = { "yamlfix", "kubectl_neat" },
    markdown = { "mdformat" },
    toml = { "taplo" },
    nix = { "nixpkgs_fmt" },
    terraform = { "tofu_fmt" },
    htmldjango = { "djlint" },
    -- wget https://github.com/google/google-java-format/releases/download/v1.25.2/google-java-format-1.25.2-all-deps.jar && mv google-java-format-1.25.2-all-deps.jar ~/.local/bin
    java = { "java ~/.local/bin/google-java-format-1.25.2-all-deps.jar -i" },
    make = { "format_makefile" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  formatters = {
    kubectl_neat = function()
      local kubectl_neat_path = os.capture "which kubectl-neat"
      print(kubectl_neat_path)
      return {
        command = require("conform.util").find_executable {
          kubectl_neat_path,
        },
      }
    end,
    format_makefile = function()
      local current_file = vim.api.nvim_buf_get_name(0)
      return {
        command = "mbake",
        args = { "format", current_file },
        stdin = false,
      }
    end,
  },

  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

vim.env.YAMLFIX_WHITELINES = "1"

require("conform").formatters.mdformat = {
  append_args = { "--number" },
}

require("conform").setup(options)
