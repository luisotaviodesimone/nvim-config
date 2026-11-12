-- Build hooks must exist before vim.pack.add so they also run on first install
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if kind == "delete" then
      return
    end
    if name == "telescope-fzf-native.nvim" then
      vim.system({ "make" }, { cwd = ev.data.path }):wait()
    elseif name == "nvim-treesitter" and kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd "nvim-treesitter"
      end
      vim.cmd "TSUpdate"
    end
  end,
})

local gh = function(repo)
  return "https://github.com/" .. repo
end

vim.pack.add {
  -- deps / ui
  gh "nvim-lua/plenary.nvim",
  gh "nvim-tree/nvim-web-devicons",
  gh "navarasu/onedark.nvim",
  gh "Mofiqul/dracula.nvim",
  gh "nvim-lualine/lualine.nvim",
  gh "akinsho/bufferline.nvim",
  gh "nvim-mini/mini.bufremove",
  gh "akinsho/toggleterm.nvim",
  gh "lukas-reineke/indent-blankline.nvim",
  gh "folke/which-key.nvim",
  gh "rcarriga/nvim-notify",

  -- files / navigation
  gh "nvim-tree/nvim-tree.lua",
  gh "stevearc/oil.nvim",
  gh "nvim-telescope/telescope.nvim",
  gh "nvim-telescope/telescope-fzf-native.nvim",
  gh "nvim-telescope/telescope-frecency.nvim",
  gh "ThePrimeagen/harpoon",
  gh "rmagatti/auto-session",
  gh "mbbill/undotree",

  -- editing
  gh "tpope/vim-abolish",
  gh "tpope/vim-commentary",
  gh "folke/todo-comments.nvim",
  gh "windwp/nvim-autopairs",
  gh "zbirenbaum/copilot.lua",
  { src = gh "nvim-treesitter/nvim-treesitter", version = "main" },

  -- completion
  gh "hrsh7th/nvim-cmp",
  gh "L3MON4D3/LuaSnip",
  gh "rafamadriz/friendly-snippets",
  gh "saadparwaiz1/cmp_luasnip",
  gh "hrsh7th/cmp-nvim-lua",
  gh "hrsh7th/cmp-nvim-lsp",
  gh "hrsh7th/cmp-buffer",
  "https://codeberg.org/FelipeLema/cmp-async-path",

  -- lsp / format
  gh "neovim/nvim-lspconfig",
  gh "mason-org/mason.nvim",
  gh "WhoIsSethDaniel/mason-tool-installer.nvim",

  gh "mfussenegger/nvim-jdtls",
  gh "b0o/SchemaStore.nvim",
  gh "stevearc/conform.nvim",
  { src = gh "saghen/blink.cmp", version = vim.version.range "^1" },

  -- git
  gh "lewis6991/gitsigns.nvim",
  gh "ruifm/gitlinker.nvim",

  -- misc
  gh "allaman/kustomize.nvim",
  gh "tpope/vim-dadbod",
  gh "kristijanhusak/vim-dadbod-ui",
  gh "kristijanhusak/vim-dadbod-completion",
  gh "hat0uma/csvview.nvim",
}

-- notify
local notify = require "notify"
notify.setup { stages = "static", fps = 0 }
vim.notify = notify

require("oil").setup { default_file_explorer = true }
require("auto-session").setup { suppressed_dirs = { "~/", "~/Downloads", "/" }, log_level = "error" }
require("todo-comments").setup {}
require("kustomize").setup {}
require("which-key").setup {}

local ibl_hooks = require "ibl.hooks"
ibl_hooks.register(ibl_hooks.type.WHITESPACE, ibl_hooks.builtin.hide_first_space_indent_level)
require("ibl").setup { indent = { char = "│" }, scope = { char = "│" } }

-- snippets
require("luasnip").config.set_config { history = true, updateevents = "TextChanged,TextChangedI" }
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load()
require("luasnip.loaders.from_lua").lazy_load()


require "luisotaviodesimone.plugins.dadbod"
require "luisotaviodesimone.plugins.conform"
require "luisotaviodesimone.configs.lspconfig"
require "luisotaviodesimone.plugins.mason" -- mason (PATH already handled in options.lua)
require "luisotaviodesimone.plugins.gitsigns"
require "luisotaviodesimone.plugins.treesitter"
require "luisotaviodesimone.plugins.csvview"

