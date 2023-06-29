local M = {}

M.t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

M.print_table = function(table)
  for k, v in pairs(table) do
    print(k, v)
  end
end

M.split_string = function(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

M.merge_tables = function(first_table, second_table)
  local new_table = {}
  for k, v in pairs(first_table) do
    new_table[k] = v
  end
  for k, v in pairs(second_table) do
    new_table[k] = v
  end
  return new_table
end

M.get_highlight = function(name)
  return vim.api.nvim_get_hl(0, {name = name})
end

M.highlight = function(name, upd_val)
  local old_val = vim.api.nvim_get_hl(0, {name = name})
  local merged_val = M.merge_tables(old_val, upd_val)
  vim.api.nvim_set_hl(0, name, merged_val)
end

return M
