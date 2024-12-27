return {
  "ThePrimeagen/harpoon",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local map = vim.keymap.set
    local ui = require "harpoon.ui"
    local mark = require "harpoon.mark"

    map("n", "<leader>a", function()
      mark.add_file()
    end)
    map("n", "<leader>hn", function()
      ui.nav_next()
    end)
    map("n", "<leader>hp", function()
      ui.nav_prev()
    end)
    map("n", "<leader>hm", function()
      ui.toggle_quick_menu()
    end)
  end,
}
