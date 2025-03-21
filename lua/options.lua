require "nvchad.options"

-- add yours here!

local opt = vim.opt
local o = vim.o
local bo = vim.bo

opt.nu = true
opt.relativenumber = true
opt.smartindent = true

-- Set character list for certain invisible characters
opt.listchars = { trail = "·" }
opt.list = true


-- Set clipboard
o.clipboard = ""
o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Set tabspaces
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
bo.softtabstop = 2

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
