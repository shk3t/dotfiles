local M = {}

function M.len(tbl)
  local count = 0
  for _ in pairs(tbl) do
    count = count + 1
  end
  return count
end

function M.is_empty(tbl)
  return next(tbl) == nil
end

function M.sorted_pairs(tbl, f)
  local keys = vim.tbl_keys(tbl)
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

function M.compact(tbl)
  local new_tbl = {}
  local i = 1
  for _, v in pairs(tbl) do
    new_tbl[i] = v
    i = i + 1
  end
  return new_tbl
end

function M.merge_lists(...)
  local result = {}
  for _, tbl in pairs({ ... }) do
    vim.list_extend(result, tbl)
  end
  return result
end

-- Data structure
function M.set(list)
  local set = {}
  for _, l in pairs(list) do
    set[l] = true
  end
  return set
end

-- Dot-chained get
function M.geget(tbl, keyseq)
  local curval = tbl
  for _, key in pairs(keyseq) do
    curval = curval and curval[key]
  end
  return curval
end
-- Dot-chained set
function M.seset(tbl, keyseq, value)
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
