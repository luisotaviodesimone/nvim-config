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
    },
  }
end

return {
  my_find_files = my_find_files,
}
