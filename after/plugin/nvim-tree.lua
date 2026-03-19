local nvim_tree = require "nvim-tree"

nvim_tree.setup {
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  view = {
    width = {
      min = -1,
      max = 40,
    },
  },
}
