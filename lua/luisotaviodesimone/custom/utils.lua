function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, "r"))
  local s = assert(f:read "*a")
  f:close()
  if raw then
    return s
  end
  s = string.gsub(s, "^%s+", "")
  s = string.gsub(s, "%s+$", "")
  s = string.gsub(s, "[\n\r]+", " ")
  return s
end

local function dump(o)
  if type(o) == "table" then
    local s = "{ "
    for k, v in pairs(o) do
      if type(k) ~= "number" then
        k = '"' .. k .. '"'
      end
      s = s .. "[" .. k .. "] = " .. dump(v) .. ","
    end
    return s .. "} "
  else
    return tostring(o)
  end
end

local function get_file_name()
  local file = vim.fn.expand "%:t"
  if file == "" then
    return nil
  end
  return file
end

local function is_avoidable(file_name, patterns)
  for _, pattern in ipairs(patterns) do
    if file_name:match(pattern) then
      return true
    end
  end
  return false
end

-- Diagnostics API mappings
local function jump_diagnostic(count)
  return function()
    vim.diagnostic.jump {
      count = count,
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float { bufnr = bufnr, scope = "cursor", focus = false }
      end,
    }
  end
end

return {
  dump = dump,
  get_file_name = get_file_name,
  is_avoidable = is_avoidable,
  jump_diagnostic = jump_diagnostic,
}
