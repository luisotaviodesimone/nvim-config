local group = vim.api.nvim_create_augroup("Sops", { clear = true })
local MARK = "ENC[AES256_GCM"

local function err(msg)
  vim.notify("sops: " .. msg, vim.log.levels.ERROR)
end

-- cwd = file's dir, so sops walks up to the project's .sops.yaml
local function sops(path, args, opts)
  opts = vim.tbl_extend("force", { cwd = vim.fs.dirname(path) }, opts or {})
  return vim.system(vim.list_extend({ "sops" }, args), opts):wait(15000)
end

local function is_encrypted(path)
  if vim.fn.filereadable(path) == 0 then
    return false
  end
  local f = assert(io.open(path, "rb"))
  local content = f:read "*a"
  f:close()
  if not content:find(MARK, 1, true) then
    return false
  end
  local out = sops(path, { "filestatus", path })
  local ok, st = pcall(vim.json.decode, out.stdout or "")
  return out.code == 0 and ok and st.encrypted == true
end

local function mtime(path)
  local st = vim.uv.fs_stat(path)
  return st and (st.mtime.sec .. "." .. st.mtime.nsec)
end

-- Runs fn without recording undo: otherwise `u` crosses views and plaintext
-- can land in the undofile
local function without_undo(buf, fn)
  local ul = vim.bo[buf].undolevels
  vim.bo[buf].undolevels = -1
  local ok, e = pcall(fn)
  vim.bo[buf].undolevels = ul
  if not ok then
    err(tostring(e))
  end
end

local function save(ev)
  local buf, path = ev.buf, vim.api.nvim_buf_get_name(ev.buf)
  if ev.event ~= "BufWriteCmd" or vim.fn.fnamemodify(ev.file, ":p") ~= path then
    return err "decrypted view can only be saved whole, to its own file"
  end
  if vim.b[buf].sops_mtime ~= mtime(path) and vim.v.cmdbang == 0 then
    return err "file changed on disk, use :e! to reload or :w! to overwrite"
  end
  local text = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n") .. "\n"
  local out = sops(path, { "edit", path }, {
    stdin = text,
    env = {
      -- sops reopens the editor on invalid content; by then stdin is empty and
      -- `test -s` aborts instead of looping or saving an empty file
      SOPS_EDITOR = [[sh -c 'cat > "$1"; test -s "$1"' sh]],
      -- sops uses a plaintext temp file: keep it in RAM
      TMPDIR = vim.fn.isdirectory "/dev/shm" == 1 and "/dev/shm" or nil,
    },
  })
  if out.code ~= 0 and out.code ~= 200 then -- 200 = unchanged
    return err("NOT saved\n" .. (out.stderr or "timeout"))
  end
  vim.b[buf].sops_mtime = mtime(path)
  vim.bo[buf].modified = false
  vim.api.nvim_exec_autocmds("BufWritePost", { buffer = buf })
end

local function on_read(buf)
  local path, bo, b = vim.api.nvim_buf_get_name(buf), vim.bo[buf], vim.b[buf]
  if path == "" or (bo.buftype ~= "" and not b.sops) then
    return
  end
  vim.api.nvim_clear_autocmds { group = group, buffer = buf }
  if not is_encrypted(path) then
    if b.sops then
      bo.buftype = ""
    end
    return
  end

  b.sops = true
  bo.buftype, bo.swapfile, bo.undofile = "", false, false
  if b.sops_view == nil then
    b.sops_view = true -- initial state of the toggle
  end
  if not b.sops_view then
    return
  end

  b.sops_mtime = mtime(path)
  local out = sops(path, { "decrypt", path })
  if out.code ~= 0 then
    b.sops_view = false
    return err(out.stderr or "timeout")
  end
  -- Copilot may already be attached to the encrypted view
  for _, c in ipairs(vim.lsp.get_clients { bufnr = buf, name = "copilot" }) do
    vim.lsp.buf_detach_client(buf, c.id)
  end
  -- acwrite first: without our autocmd `:w` fails instead of writing plaintext
  bo.buftype = "acwrite"
  vim.api.nvim_create_autocmd({ "BufWriteCmd", "FileWriteCmd", "FileAppendCmd" }, {
    group = group,
    buffer = buf,
    callback = save,
  })
  without_undo(buf, function()
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split((out.stdout:gsub("\n$", "")), "\n"))
  end)
  bo.modified = false
end

vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  nested = true,
  callback = function(ev)
    on_read(ev.buf)
  end,
})

local function reload(buf)
  vim.bo[buf].buftype = ""
  without_undo(buf, function()
    vim.cmd "edit!"
  end)
end

-- mksession restores acwrite buffers by name only, i.e. empty: read them again
vim.api.nvim_create_autocmd("SessionLoadPost", {
  group = group,
  nested = true,
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[buf].buftype == "acwrite" and not vim.b[buf].sops and is_encrypted(vim.api.nvim_buf_get_name(buf)) then
        vim.api.nvim_buf_call(buf, function()
          reload(buf)
        end)
      end
    end
  end,
})

local function command(name, desc, fn)
  vim.api.nvim_create_user_command(name, function()
    local buf = vim.api.nvim_get_current_buf()
    if vim.bo[buf].modified then
      return err "unsaved changes, save or :e! first"
    end
    fn(buf, vim.api.nvim_buf_get_name(buf))
  end, { desc = desc })
end

for name, verb in pairs { SopsEncrypt = "encrypt", SopsDecrypt = "decrypt" } do
  command(name, "sops: " .. verb .. " file on disk", function(buf, path)
    local out = sops(path, { verb, "--in-place", path })
    if out.code ~= 0 then
      return err(out.stderr or "timeout")
    end
    reload(buf)
    vim.notify("sops: file " .. verb .. "ed on disk")
  end)
end

command("SopsToggle", "sops: toggle decrypted view", function(buf)
  if not vim.b[buf].sops then
    return err "not a sops file"
  end
  vim.b[buf].sops_view = not vim.b[buf].sops_view
  reload(buf)
end)
