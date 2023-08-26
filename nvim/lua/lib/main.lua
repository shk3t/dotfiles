local M = {}

M.is_empty = function(tbl) return next(tbl) == nil end

M.replace_termcodes = function(str) return vim.api.nvim_replace_termcodes(str, true, true, true) end

M.print_table = function(tbl) for k, v in pairs(tbl) do print(k, v) end end

M.split_string = function(inputstr, sep)
  if sep == nil then sep = "%s" end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do table.insert(t, str) end
  return t
end

M.norm = function(command) vim.cmd("normal! " .. M.replace_termcodes(command)) end

M.vc_cmd = function(vimcmd)
  vimcmd()
  for i = 1, vim.v.count - 1 do vimcmd() end
end

M.save_jump = function() vim.cmd("normal! m'") end
M.center_win = function() vim.cmd("normal! zz") end

M.cwd_contains = function(str) return string.find(vim.fn.getcwd(), str) end

M.get_highlight = function(name) return vim.api.nvim_get_hl(0, {name = name}) end

M.highlight = function(name, upd_val)
  local old_val = vim.api.nvim_get_hl(0, {name = name})
  local merged_val = vim.tbl_extend("force", old_val, upd_val)
  vim.api.nvim_set_hl(0, name, merged_val)
end

M.get_recent_buffers = function()
  local bufnrs = vim.tbl_filter(function(b)
    if 1 ~= vim.fn.buflisted(b) then return false end
    return true
  end, vim.api.nvim_list_bufs())
  table.sort(bufnrs, function(a, b) return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused end)
  return bufnrs
end

M.find = function(condition, items) for _, v in pairs(items) do if condition(v) then return v end end end
M.filter = function(condition, items)
  local result = {}
  for _, v in pairs(items) do if condition(v) then result[#result + 1] = v end end
  return result
end

M.cprev = function() if not pcall(vim.cmd.cprevious) then vim.cmd.clast() end end
M.cnext = function() if not pcall(vim.cmd.cnext) then vim.cmd.cfirst() end end

return M
