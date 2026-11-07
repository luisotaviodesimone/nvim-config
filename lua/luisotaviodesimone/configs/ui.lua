local M = {}

local themes = { "onedark", "dracula" }
local transparent_groups = {
  "Normal",
  "NormalNC",
  "NormalFloat",
  "FloatBorder",
  "SignColumn",
  "FoldColumn",
  "LineNr",
  "CursorLineNr",
  "EndOfBuffer",
  "NvimTreeNormal",
  "NvimTreeNormalNC",
  "TelescopeNormal",
  "TelescopeBorder",
}

vim.g.transparent = true

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("Transparency", { clear = true }),
  callback = function()
    if vim.g.transparent then
      for _, group in ipairs(transparent_groups) do
        vim.api.nvim_set_hl(
          0,
          group,
          vim.tbl_extend("force", vim.api.nvim_get_hl(0, { name = group, link = false }), { bg = "NONE" })
        )
      end
    end
  end,
})

require("onedark").setup { style = "dark" }
vim.cmd.colorscheme "onedark"

function M.toggle_theme()
  vim.cmd.colorscheme(vim.g.colors_name == themes[1] and themes[2] or themes[1])
end

function M.toggle_transparency()
  vim.g.transparent = not vim.g.transparent
  vim.cmd.colorscheme(vim.g.colors_name)
end

-- statusline (close to NvChad's default layout)
require("lualine").setup {
  options = {
    theme = "auto",
    globalstatus = true,
    component_separators = "",
    section_separators = { left = "", right = "" },
    disabled_filetypes = { statusline = { "NvimTree" } },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { { "filename", symbols = { modified = "●" } } },
    lualine_c = { "branch", "diff" },
    lualine_x = { "diagnostics", "lsp_status" },
    lualine_y = {
      function()
        return "󰉋 " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      end,
    },
    lualine_z = { "location" },
  },
}

-- tabufline replacement
require("mini.bufremove").setup()
require("bufferline").setup {
  options = {
    close_command = function(buf)
      require("mini.bufremove").delete(buf)
    end,
    offsets = { { filetype = "NvimTree", text = "", highlight = "NvimTreeNormal" } },
    show_buffer_close_icons = true,
    separator_style = "thin",
  },
}

-- terminals (replacement for nvchad.term)
require("toggleterm").setup {
  size = function(term)
    return term.direction == "vertical" and math.floor(vim.o.columns * 0.5) or math.floor(vim.o.lines * 0.3)
  end,
}

local Terminal = require("toggleterm.terminal").Terminal
local terms = {
  vsp = Terminal:new { direction = "vertical", count = 101 },
  sp = Terminal:new { direction = "horizontal", count = 102 },
  float = Terminal:new { direction = "float", count = 103, float_opts = { border = "rounded" } },
}

function M.toggle_term(pos)
  terms[pos]:toggle()
end

return M
