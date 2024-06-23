require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Makes it possible to copy to system buffer easier
map("n", "<leader>y", '"+y', { desc = "Copy to system buffer" })
map("v", "<leader>y", '"+y', { desc = "Copy to system buffer" })
map("n", "<leader>Y", '"+Y', { desc = "Copy to system buffer" })

-- Makes it possible to paste from system buffer
-- map("n", "<leader>p", "\"+p", { desc = "Paste from system buffer" })
map("v", "<leader>p", '"+p', { desc = "Paste from system buffer" })
-- map("n", "<leader>P", "\"+P", { desc = "Paste from system buffer" })

-- map("v", "<leader>gd")

-- UndoTree mappings
map("n", "<leader>u", vim.cmd.UndotreeToggle)

map("n", "<C-b>", ":NvimTreeToggle<CR>", {})

-- Move line up and down
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

local builtin = require "telescope.builtin"
vim.keymap.set("n", "<leader>ff", function()
  builtin.find_files {
    find_command = {
      "rg",
      "--files",
      "--hidden",
      "--no-ignore-vcs",
      "-g",
      "!**/.git/*",
      "-g",
      "!**/node_modules/*",
      "-g",
      "!**/.repro/*",
    },
  }
end)
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
