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
      "-g",
      "!**/.venv/*",
    },
  }
end

local function get_yaml_schemas()
  return ":Telescope yaml_schema<CR>"
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
telescope.load_extension "yaml_schema"

return {
  my_find_files = my_find_files,
  get_yaml_schemas = get_yaml_schemas,
}
