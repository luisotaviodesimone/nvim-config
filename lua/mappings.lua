require "nvchad.mappings"
local builtin = require "telescope.builtin"
local custom_telescope = require "configs.telescope"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
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

-- UndoTree mappings
map("n", "<leader>u", vim.cmd.UndotreeToggle)

map("n", "<C-b>", ":NvimTreeToggle<CR>", {})

-- Move line up and down
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

map("n", "<leader>ff", custom_telescope.my_find_files)
map("n", "<leader>fr", builtin.registers)
map("n", '<leader>fg', builtin.git_status)

map("n", "<leader>tt", function()
  return require("base46").toggle_theme()
end, { desc = "Toggle Theme" })

map("n", "<leader>tr", function()
  return require("base46").toggle_transparency()
end, { desc = "Toggle Transperency" })
