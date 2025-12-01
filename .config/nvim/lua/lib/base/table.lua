local M = {}

M.print = function(tbl)
  for k, v in pairs(tbl) do
    print(k, v)
  end
end

M.len = function(tbl)
  local count = 0
  for _ in pairs(tbl) do
    count = count + 1
  end
  return count
end

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

M.filter_list = function(condition, items)
  local result = {}
  for _, v in pairs(items) do
    if condition(v) then
      result[#result + 1] = v
    end
  end
  return result
end

M.compact = function(tbl)
  local new_tbl = {}
  local i = 1
  for _, v in pairs(tbl) do
    new_tbl[i] = v
    i = i + 1
  end
  return new_tbl
end

M.merge_lists = function(...)
  local result = {}
  for _, tbl in ipairs({ ... }) do
    vim.list_extend(result, tbl)
  end
  return result
end

-- Data structure
M.set = function(list)
  local set = {}
  for _, l in pairs(list) do
    set[l] = true
  end
  return set
end

-- Dot-chained get
M.geget = function(tbl, keyseq)
  local curval = tbl
  for _, key in pairs(keyseq) do
    curval = curval and curval[key]
  end
  return curval
end
-- Dot-chained set
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

return M
