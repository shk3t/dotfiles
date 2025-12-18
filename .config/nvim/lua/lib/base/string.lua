local M = {}

---@param str string
function M.lua_escape(str)
  return str:gsub("[%%%.%+%-%*%?%[%]%^%$%(%)]", "%%%0")
end

---@param str string
---@param subs table
function M.contains_any(str, subs)
  return string.find(str, table.concat(subs, "|")) ~= nil
end

---@param inputstr string
---@param sep string
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
