local M = {}

function M.contains(str, sub)
  return string.find(str, sub) ~= nil
end

function M.contains_any(str, subs)
  return string.find(str, table.concat(subs, "|")) ~= nil
end

function M.split(inputstr, sep)
  inputstr = inputstr or ""
  sep = sep or "%s"
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

return M
