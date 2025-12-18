-- require "nvchad.options"

local opt = vim.opt
local o = vim.o
local bo = vim.bo
local g = vim.g

opt.nu = true
opt.relativenumber = true
opt.smartindent = true

-- Set character list for certain invisible characters
opt.listchars = { trail = "·", tab = "  " }
opt.list = true

-- Set clipboard
o.clipboard = ""
o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- interval for writing swap file to disk, also used by gitsigns
o.updatetime = 250

-- Set tabspaces
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
bo.softtabstop = 2

-- Make borders rounded
g.border_style = "rounded"
o.termguicolors = true
o.winborder = "rounded"

-- Set highlight on search
opt.hlsearch = true

-- Set persistent undo
opt.undodir = os.getenv "HOME" .. "/.vim/undodir"
opt.undofile = true

-- Set swap directory
opt.directory = os.getenv "HOME" .. "/.vim/swapdir"
opt.swapfile = true

-- Set backup directory
opt.backupdir = os.getenv "HOME" .. "/.vim/.backup"
opt.backup = true

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH

-- Do not know what what these are for
o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400

-- o.cursorlineopt ='both' -- to enable cursorline!
vim.filetype.add {
  extension = {
    gotmpl = "gotmpl",
  },
  pattern = {
    [".*/templates/.*%.tpl"] = "helm",
    [".*/templates/.*%.ya?ml"] = "helm",
    ["helmfile.*%.ya?ml"] = "helm",
  },
}

-- Auto reload files changed outside of nvim
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  command = "if mode() != 'c' | checktime | endif",
})
