require("gitsigns").setup {
  signs = {
    delete = { text = "󰍵" },
    changedelete = { text = "󱕖" },
  },
}

local gs_diff_ns = vim.api.nvim_create_namespace "gitsigns_diff"
local gs_total_ns = vim.api.nvim_create_namespace "gitsigns_diff_total"
local gs_total = {}
vim.api.nvim_set_decoration_provider(gs_total_ns, {
  on_win = function(_, _, buf)
    if vim.bo[buf].filetype ~= "gitsigns-diff" then
      return false
    end
    local added, removed = 0, 0
    for _, m in ipairs(vim.api.nvim_buf_get_extmarks(buf, gs_diff_ns, 0, -1, { details = true })) do
      if m[4].virt_text_pos == "right_align" then
        for _, chunk in ipairs(m[4].virt_text) do
          local n = tonumber(chunk[1]:match "%d+")
          if chunk[2] == "GitSignsAdd" then
            added = added + n
          elseif chunk[2] == "GitSignsDelete" then
            removed = removed + n
          end
        end
      end
    end
    gs_total[buf] = { { "+" .. added, "GitSignsAdd" }, { " -" .. removed, "GitSignsDelete" } }
  end,
  on_line = function(_, _, buf, row)
    if row == 0 then
      vim.api.nvim_buf_set_extmark(buf, gs_total_ns, 0, 0, {
        virt_text = gs_total[buf],
        virt_text_pos = "right_align",
        ephemeral = true,
      })
    end
  end,
})

