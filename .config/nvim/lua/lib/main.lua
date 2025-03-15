local keymap = vim.keymap.set
local consts = require("lib.consts")
local state = require("lib.state")

local M = {}

M.is_empty = function(tbl)
  return next(tbl) == nil
end

M.is_in_list = function(target, list)
  for _, value in pairs(list) do
    if target == value then
      return true
    end
  end
  return false
end

M.fallback = function(action, args, default)
  local ok, result = pcall(action, unpack(args))
  return ok and result or default
end

-- sequential get
M.geget = function(tbl, keyseq)
  local curval = tbl
  for _, key in pairs(keyseq) do
    curval = curval and curval[key]
  end
  return curval
end

-- sequential set
M.seset = function(tbl, keyseq, value)
  local last_key = table.remove(keyseq)

  local curval = tbl
  for _, key in pairs(keyseq) do -- except last key
    local nextval = curval[key]
    if not nextval then
      nextval = {}
      curval[key] = nextval
    end
    curval = nextval
  end

  curval[last_key] = value
end

M.cache = function(keyseq, action, args)
  local value = M.geget(state.cache, keyseq)
  if value == nil then
    value = action(unpack(args))
    M.seset(state.cache, keyseq, value)
  end
  return value
end

M.backward_file_search = function(target)
  local curdir = vim.fn.getcwd()
  repeat
    local target_path = curdir .. "/" .. target
    if vim.fn.filereadable(target_path) == 1 then
      return target_path
    end
    curdir = vim.fn.fnamemodify(curdir, ":h")
  until curdir == vim.fn.expand("~")
end
M.backward_file_search_c = function(target)
  return M.cache({ "backward_file_search", vim.fn.getcwd(), target }, M.backward_file_search, { target })
end

M.require_or = function(module, default)
  return M.fallback(require, { module }, default)
end

M.local_config_or = function(local_keyseq, global_value)
  local local_config_path = M.backward_file_search_c(consts.LOCAL_CONFIG_FILE)
  if local_config_path then
    return M.geget(dofile(local_config_path), local_keyseq)
  end
  return global_value
end
M.local_config_or_c = function(local_keyseq, global_value)
  return M.cache({ "local_config", unpack(local_keyseq) }, M.local_config_or, { local_keyseq, global_value })
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
  inputstr = inputstr or ""
  sep = sep or "%s"
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

M.norm = function(command)
  vim.cmd("normal! " .. M.replace_termcodes(command))
end

M.rnorm = function(command)
  vim.cmd("normal " .. M.replace_termcodes(command))
end

M.tnorm = function(command)
  vim.api.nvim_input("<C-\\><C-O>")
  vim.cmd("normal! " .. M.replace_termcodes(command))
end

M.preserve_location = function(callback)
  if type(callback) == "string" then
    return function()
      M.norm("m" .. consts.PRESERVE_MARK .. callback .. "`" .. consts.PRESERVE_MARK)
      vim.cmd.delmarks(consts.PRESERVE_MARK)
    end
  end

  return function()
    M.norm("m" .. consts.PRESERVE_MARK)
    callback()
    M.norm("`" .. consts.PRESERVE_MARK)
    vim.cmd.delmarks(consts.PRESERVE_MARK)
  end
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

M.contains = function(str, sub)
  return string.find(str, sub) ~= nil
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

M.filter_list = function(condition, items)
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

M.keys = function(tbl)
  local keys = {}
  for key in pairs(tbl) do
    table.insert(keys, key)
  end
  return keys
end

M.sorted_pairs = function(tbl, f)
  local keys = M.keys(tbl)
  table.sort(keys, f)
  local i = 0
  return function() -- iterator
    i = i + 1
    local key = keys[i]
    if key ~= nil then
      return key, tbl[key]
    end
  end
end

M.set = function(list)
  local set = {}
  for _, l in pairs(list) do
    set[l] = true
  end
  return set
end

M.map_easy_closing = function()
  keymap("n", "q", ":q<CR>", {
    buffer = true,
    silent = true,
  })
end

M.natural_order_with_filetype_cmp = function(left, right)
  local left_ft_priority = consts.FILETYPE_PRIORITIES[left.type]
  local right_ft_priority = consts.FILETYPE_PRIORITIES[right.type]
  if left_ft_priority ~= -1 and right_ft_priority ~= -1 and left_ft_priority ~= right_ft_priority then
    return left_ft_priority < right_ft_priority
  end

  left = left.name:lower()
  right = right.name:lower()

  if left == right then
    return false
  end

  for i = 1, math.max(string.len(left), string.len(right)), 1 do
    local l = string.sub(left, i, -1)
    local r = string.sub(right, i, -1)

    if type(tonumber(string.sub(l, 1, 1))) == "number" and type(tonumber(string.sub(r, 1, 1))) == "number" then
      local l_number = tonumber(string.match(l, "^[0-9]+"))
      local r_number = tonumber(string.match(r, "^[0-9]+"))

      if l_number ~= r_number then
        return l_number < r_number
      end
    elseif string.sub(l, 1, 1) ~= string.sub(r, 1, 1) then
      return l < r
    end
  end
end

M.DEFAULT_PYTHON_PATH = "/usr/bin/python"

M.python_path = (function()
  local workdir = vim.fn.getcwd()
  local venvdirs = { "venv", ".venv" }

  for _, venvdir in pairs(venvdirs) do
    local pybin = M.backward_file_search(venvdir .. "/bin/python")
    if pybin and vim.fn.executable(pybin) == 1 then
      return pybin
    end
  end

  return M.DEFAULT_PYTHON_PATH
end)()

M.term = function(command)
  -- Create buf if not exists
  if not vim.api.nvim_buf_is_valid(state.main_term.buf) then
    state.main_term.buf = vim.api.nvim_create_buf(false, true)
  end

  -- Create win if not exists
  if not vim.api.nvim_win_is_valid(state.main_term.win) then
    state.main_term.win = vim.api.nvim_open_win(state.main_term.buf, true, {
      split = "below",
      height = 16,
    })
  else
    vim.api.nvim_set_current_win(state.main_term.win)
  end

  -- Use buf as terminal if it is not
  if vim.bo.filetype ~= "terminal" then
    vim.cmd.terminal()
    vim.cmd.sleep("50m")
  end

  vim.fn.chansend(vim.bo.channel, { command .. "\r\n" })
end

M.is_auxiliary_buffer = function(buf)
  buf = buf or 0
  local buf_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
  local buf_filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })

  return M.is_in_list(buf_name, consts.AUXILIARY.FILENAMES)
    or M.contains(buf_name, consts.DAP.REPL_FILENAME_PATTERN)
    or buf_filetype == "terminal"
end

return M
