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

  -- git
  gh "lewis6991/gitsigns.nvim",
  gh "ruifm/gitlinker.nvim",

  -- misc
  gh "allaman/kustomize.nvim",
  gh "tpope/vim-dadbod",
  gh "kristijanhusak/vim-dadbod-ui",
  gh "kristijanhusak/vim-dadbod-completion",
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

require("gitsigns").setup {
  signs = {
    delete = { text = "󰍵" },
    changedelete = { text = "󱕖" },
  },
}

local ibl_hooks = require "ibl.hooks"
ibl_hooks.register(ibl_hooks.type.WHITESPACE, ibl_hooks.builtin.hide_first_space_indent_level)
require("ibl").setup { indent = { char = "│" }, scope = { char = "│" } }

require("copilot").setup {
  suggestion = {
    enabled = true,
    auto_trigger = true,
    hide_during_completion = false,
    debounce = 10,
    keymap = {
      accept = "<M-l>",
      accept_word = false,
      accept_line = false,
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
  filetypes = { yaml = true, ["."] = true },
}

-- mason (PATH already handled in options.lua)
require("luisotaviodesimone.plugins.mason")

-- treesitter (main branch: install parsers + start highlighting per buffer)
require("luisotaviodesimone.plugins.treesitter")

-- snippets
require("luasnip").config.set_config { history = true, updateevents = "TextChanged,TextChangedI" }
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load()
require("luasnip.loaders.from_lua").lazy_load()

-- completion (mappings copied from NvChad v2.5)
local cmp = require "cmp"
cmp.setup {
  completion = { completeopt = "menu,menuone" },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif require("luasnip").expand_or_jumpable() then
        require("luasnip").expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif require("luasnip").jumpable(-1) then
        require("luasnip").jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "nvim_lua" },
    { name = "async_path" },
  },
}

require("nvim-autopairs").setup { fast_wrap = {}, disable_filetype = { "TelescopePrompt", "vim" } }
cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())

-- dadbod
require "luisotaviodesimone.plugins.dadbod"

require "luisotaviodesimone.plugins.conform"
require "luisotaviodesimone.configs.lspconfig"
