local M = {}

M.is_empty = function(tbl)
  return next(tbl) == nil
end

M.replace_termcodes = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

M.print_table = function(tbl)
  for k, v in pairs(tbl) do
    print(k, v)
  end
end

M.split_string = function(inputstr, sep)
  if inputstr == nil then
    inputstr = ""
  end
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in inputstr:gmatch("([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

M.norm = function(command)
  vim.cmd("normal! " .. M.replace_termcodes(command))
end

M.vc_cmd = function(vimcmd)
  vimcmd()
  for i = 1, vim.v.count - 1 do
    vimcmd()
  end
end

M.get_visual = function()
  local _, ls, cs = unpack(vim.fn.getpos("v"))
  local _, le, ce = unpack(vim.fn.getpos("."))
  if ls > le then
    ls, le = le, ls
  end
  if cs > ce then
    cs, ce = ce, ls
  end
  local visual = vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
  return visual[1] or ""
end

M.save_jump = function()
  vim.cmd("normal! m'")
end
M.center_win = function()
  vim.cmd("normal! zz")
end

M.cwd_contains = function(str)
  return vim.fn.getcwd():find(str)
end

M.get_highlight = function(name)
  return vim.api.nvim_get_hl(0, { name = name })
end

M.highlight = function(name, upd_val)
  local old_val = vim.api.nvim_get_hl(0, { name = name })
  local merged_val = vim.tbl_extend("force", old_val, upd_val)
  vim.api.nvim_set_hl(0, name, merged_val)
end

M.get_recent_buffers = function()
  local bufnrs = vim.tbl_filter(function(b)
    if 1 ~= vim.fn.buflisted(b) then
      return false
    end
    return true
  end, vim.api.nvim_list_bufs())
  table.sort(bufnrs, function(a, b)
    return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
  end)
  return bufnrs
end

M.find = function(condition, items)
  for _, v in pairs(items) do
    if condition(v) then
      return v
    end
  end
end
M.filter = function(condition, items)
  local result = {}
  for _, v in pairs(items) do
    if condition(v) then
      result[#result + 1] = v
    end
  end
  return result
end

M.cprev = function()
  if not pcall(vim.cmd.cprevious) then
    vim.cmd.clast()
  end
end
M.cnext = function()
  if not pcall(vim.cmd.cnext) then
    vim.cmd.cfirst()
  end
end

M.sorted_pairs = function(t, f)
  local a = {}
  for n in pairs(t) do
    table.insert(a, n)
  end
  table.sort(a, f)
  local i = 0 -- iterator variable
  local iter = function() -- iterator function
    i = i + 1
    if a[i] == nil then
      return nil
    else
      return a[i], t[a[i]]
    end
  end
  return iter
end

M.set = function(list)
  local set = {}
  for _, l in ipairs(list) do
    set[l] = true
  end
  return set
end

return M
