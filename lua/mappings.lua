-- require "nvchad.mappings"
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

-- Remap jk to escape in insert mode
map("i", "jk", "<ESC>")
map("i", "JK", "<ESC>")

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map({ "n", "x" }, "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "general format file" })

-- Navigation mappings
map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

-- Makes it possible to copy to system buffer easier
map("n", "<leader>y", '"+y', { desc = "Copy to system buffer" })
map("v", "<leader>y", '"+y', { desc = "Copy to system buffer" })
map("n", "<leader>Y", '"+Y', { desc = "Copy to system buffer" })

-- Makes it possible to paste from system buffer
-- map("n", "<leader>p", "\"+p", { desc = "Paste from system buffer" })
map("v", "<leader>p", '"+p', { desc = "Paste from system buffer" })
-- map("n", "<leader>P", "\"+P", { desc = "Paste from system buffer" })

---- LSP
-- Diagnostics API mappings
map("n", "g]", ":lua vim.diagnostic.goto_next()<CR>", { desc = "LSP Go to next diagnostic" })
map("n", "g[", ":lua vim.diagnostic.goto_prev()<CR>", { desc = "LSP Go to previous diagnostic" })
map("n", "go", ":lua vim.diagnostic.open_float()<CR>", { desc = "LSP Open floating diagnostic message" })
map("n", "gh", ":lua vim.lsp.buf.hover()<CR>", { desc = "LSP Open selected method description" })
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- GitSigns mappings
map("v", "<leader>gh", gitsigns.reset_hunk, { desc = "Reset selected git hunk" })

-- UndoTree mappings
map("n", "<leader>u", vim.cmd.UndotreeToggle)

-- Move selected line up and down
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Remap page up and page down to centralize the cursor
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")

-- Telescope Mappings
map("n", "<leader>ff", my_telescope.my_find_files, { desc = "Telescope find files function" })
map("n", "<leader>fr", builtin.registers)
map("n", "<leader>fg", builtin.git_status)
map("n", "<leader>fs", my_telescope.get_yaml_schemas(), { desc = "Activate new yaml schemas" })
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })

map("n", "<leader>tt", function()
  return require("base46").toggle_theme()
end, { desc = "Toggle Theme" })

map("n", "<leader>tr", function()
  return require("base46").toggle_transparency()
end, { desc = "Toggle Transperency" })

map("n", "<leader>th", function()
  require("nvchad.themes").open()
end, { desc = "telescope nvchad themes" })
