require "luisotaviodesimone.configs.options"

vim.filetype.add { extension = { tofu = "opentofu", tofuvars = "opentofu-vars" } }

vim.g.mapleader = " "

require "luisotaviodesimone.plugins"
require "luisotaviodesimone.configs.ui"

vim.schedule(function()
  require "luisotaviodesimone.configs.mappings"
end)

require "luisotaviodesimone.configs.autocmds"
