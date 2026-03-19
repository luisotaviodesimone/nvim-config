local function get_visual_selected()
  local _, start_row, start_col, _ = unpack(vim.fn.getpos "v")
  local _, end_row, end_col, _ = unpack(vim.fn.getpos ".")
  if start_row > end_row or (start_row == end_row and start_col > end_col) then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end
  return vim.api.nvim_buf_get_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, {})
end

local function add_console_log(text)
  local current_line = vim.api.nvim_get_current_line()
  local indentation = current_line:match "^%s*" or ""
  local log_statement = indentation .. "console.log(" .. text .. ");"
  vim.api.nvim_set_current_line(current_line)
  vim.api.nvim_buf_set_lines(
    0,
    vim.api.nvim_win_get_cursor(0)[1],
    vim.api.nvim_win_get_cursor(0)[1],
    false,
    { log_statement }
  )
end

vim.keymap.set("v", "<leader>l", function()
  local selected_text = get_visual_selected()

  if #selected_text == 0 then
    print "No text selected"
    return
  end

  local text_to_log = table.concat(selected_text, " ")
  add_console_log(text_to_log)
end, { desc = "Copy selected text to clipboard" })

