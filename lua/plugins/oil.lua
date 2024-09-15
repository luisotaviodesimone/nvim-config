return {
  "stevearc/oil.nvim",
  lazy = false,
  ---@module 'oil'
  -- -@type oil.SetupOpts
  opts = {
    default_file_explorer = true,
  },
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
}
