require "options"

vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

-- require "nvchad.autocmds"

-- Essa parte é importante pra os lsp
local autocmd = vim.api.nvim_create_autocmd
-- user event that loads after UIEnter + only if file buf is there
autocmd({ "BufReadPost", "BufNewFile" }, {
  -- group = vim.api.nvim_create_augroup("NvFilePost", { clear = true }),
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })

    -- if not vim.g.ui_entered and args.event == "UIEnter" then
      -- vim.g.ui_entered = true
    -- end

    -- if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
    if file ~= "" and buftype ~= "nofile" then
      vim.api.nvim_exec_autocmds("User", { pattern = "FilePost", modeline = false })
      -- vim.api.nvim_del_augroup_by_name "NvFilePost"

      vim.schedule(function()
        vim.api.nvim_exec_autocmds("FileType", {})

        if vim.g.editorconfig then
          require("editorconfig").config(args.buf)
        end
      end)
    end
  end,
})

vim.schedule(function()
  require "mappings"
end)

vim.api.nvim_create_autocmd({ "VimLeave" }, {
  callback = function()
    vim.cmd "sleep 50m"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("FixTerraformCommentString", { clear = true }),
  callback = function(ev)
    vim.bo[ev.buf].commentstring = "# %s"
  end,
  pattern = { "terraform", "hcl" },
})
