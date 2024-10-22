local telescope = require "telescope"
local builtin = require "telescope.builtin"

local function my_find_files()
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
      "-g",
      "!**/target/*",
    },
  }
end

telescope.setup {
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
    },
  },
}

telescope.load_extension "fzf"
telescope.load_extension "frecency"

return {
  my_find_files = my_find_files,
}
