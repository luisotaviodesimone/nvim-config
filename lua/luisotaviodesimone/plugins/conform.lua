require "luisotaviodesimone.custom.utils"

local oxfmtFormatter = { "oxfmt", "prettierd", "prettier", stop_after_first = true }

local options = {
	default_format_opts = {
		timeout_ms = 3000,
		async = false,
		quiet = false,
		lsp_format = "fallback",
	},
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = { "isort", "black" },
    -- Use a sub-list to run only the first available formatter
    javascript = oxfmtFormatter,
    typescript = oxfmtFormatter,
    typescriptreact = oxfmtFormatter,
    vue = oxfmtFormatter,
    json = oxfmtFormatter,
    jsonc = oxfmtFormatter,
    html = oxfmtFormatter,
    css = oxfmtFormatter,
    scss = oxfmtFormatter,
    markdown = oxfmtFormatter,
    ["markdown.mdx"] = oxfmtFormatter,
    yaml = { "yamlfix", "kubectl_neat" },
    sql = { "sql_formatter" },
    xml = { "xmllint" },
    bash = { "beautysh" },
    sh = { "beautysh" },
    toml = { "taplo" },
    nix = { "nixpkgs_fmt" },
    terraform = { "tofu_fmt" },
    ["terraform-vars"] = { "tofu_fmt" },
    opentofu = { "tofu_fmt" },
    ["opentofu-vars"] = { "tofu_fmt" },
    htmldjango = { "djlint" },
    -- wget https://github.com/google/google-java-format/releases/download/v1.25.2/google-java-format-1.25.2-all-deps.jar && mv google-java-format-1.25.2-all-deps.jar ~/.local/bin
    java = { "java ~/.local/bin/google-java-format-1.25.2-all-deps.jar -i" },
    make = { "format_makefile" },
    csv = { "csv_compact" },
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
    oxfmt = {
      require_cwd = true,
    },
    -- trims spaces around every cell; alignment is only visual (csvview.nvim)
    csv_compact = {
      command = "python3",
      args = {
        "-c",
        [=[
import csv, io, sys
rows = csv.reader(io.TextIOWrapper(sys.stdin.buffer, encoding="utf-8", newline=""))
csv.writer(sys.stdout, lineterminator="\n").writerows([c.strip() for c in r] for r in rows)
]=],
      },
    },
  },
}

vim.env.YAMLFIX_WHITELINES = "1"

require("conform").formatters.mdformat = {
  append_args = { "--number" },
}

require("conform").setup(options)
