require "nvchad.mappings"
local builtin = require "telescope.builtin"
local my_telescope = require "configs.telescope"
local gitsigns = require "gitsigns"

-- add yours here
local map = vim.keymap.set

-- todo comments

map("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

map("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

-- oil

map("n", "<leader>o", ":Oil<cr>")

-- harpoon
local ui = require "harpoon.ui"
local mark = require "harpoon.mark"

map("n", "<leader>a", function()
  mark.add_file()
end, { desc = "Add file to harpoon" })
map("n", "<leader>hn", function()
  ui.nav_next()
end, { desc = "Navigate to next harpoon file" })
map("n", "<leader>hp", function()
  ui.nav_prev()
end, { desc = "Navigate to previous harpoon file" })
map("n", "<leader>hm", function()
  ui.toggle_quick_menu()
end, { desc = "Toggle harpoon menu" })

-- gitlinker
map(
  "n",
  "<leader>gb",
  '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".copy_to_clipboard})<cr>',
  { desc = "Copy repo url reference to clipboard" }
)

map(
  "v",
  "<leader>gb",
  '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".copy_to_clipboard})<cr>',
  { desc = "Copy repo url reference to clipboard" }
)

map("i", "jk", "<ESC>")
map("i", "JK", "<ESC>")

-- Makes it possible to copy to system buffer easier
map("n", "<leader>y", '"+y', { desc = "Copy to system buffer" })
map("v", "<leader>y", '"+y', { desc = "Copy to system buffer" })
map("n", "<leader>Y", '"+Y', { desc = "Copy to system buffer" })

-- Makes it possible to paste from system buffer
-- map("n", "<leader>p", "\"+p", { desc = "Paste from system buffer" })
map("v", "<leader>p", '"+p', { desc = "Paste from system buffer" })
-- map("n", "<leader>P", "\"+P", { desc = "Paste from system buffer" })

-- LSP Diagnostics API mappings
map("n", "g]", ":lua vim.diagnostic.goto_next()<CR>", { desc = "LSP Go to next diagnostic" })
map("n", "g[", ":lua vim.diagnostic.goto_prev()<CR>", { desc = "LSP Go to previous diagnostic" })
map("n", "go", ":lua vim.diagnostic.open_float()<CR>", { desc = "LSP Open floating diagnostic message" })
map("n", "gh", ":lua vim.lsp.buf.hover()<CR>", { desc = "LSP Open selected method description" })

-- GitSigns mappings
map("v", "<leader>gh", gitsigns.reset_hunk, { desc = "Reset selected git hunk" })

-- UndoTree mappings
map("n", "<leader>u", vim.cmd.UndotreeToggle)

-- NvimTree mappings
map("n", "<C-b>", ":NvimTreeToggle<CR>", {})
map("n", "<leader>co", ":NvimTreeCollapse<CR>", {})

-- Move line up and down
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Telescope Mappings
map("n", "<leader>ff", my_telescope.my_find_files, { desc = "Telescope find files function" })
map("n", "<leader>fr", builtin.registers)
map("n", "<leader>fg", builtin.git_status)
map("n", "<leader>fg", builtin.git_status)
map("n", "<leader>fs", my_telescope.get_yaml_schemas(), { desc = "Activate new yaml schemas" })

map("n", "<leader>tt", function()
  return require("base46").toggle_theme()
end, { desc = "Toggle Theme" })

map("n", "<leader>tr", function()
  return require("base46").toggle_transparency()
end, { desc = "Toggle Transperency" })
