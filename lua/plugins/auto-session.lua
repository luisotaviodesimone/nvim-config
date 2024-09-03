-- local function change_nvim_tree_dir()
--   local nvim_tree = require "nvim-tree"
--   nvim_tree.change_dir(vim.fn.getcwd())
-- end

return {
  "rmagatti/auto-session",
  lazy = false,
  dependencies = {
    "nvim-telescope/telescope.nvim", -- Only needed if you want to use session lens
  },

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { "~/", "~/Downloads", "/" },
    log_level = "error",
    -- post_restore_cmds = { change_nvim_tree_dir, "NvimTreeOpen" },
    pre_save_cmds = { "NvimTreeClose" },

    -- log_level = 'debug',
  },
}
