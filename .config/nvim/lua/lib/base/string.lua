local M = {}

M.contains = function(str, sub)
  return string.find(str, sub) ~= nil
end

M.contains_any = function(str, subs)
  return string.find(str, table.concat(subs, "|")) ~= nil
end

M.split = function(inputstr, sep)
  inputstr = inputstr or ""
  sep = sep or "%s"
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

return M
