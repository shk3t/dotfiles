local M = {}

M.char_to_hex = function(c) return ("%%%02X"):format(c:byte()) end

M.urlencode = function(url)
  if url == nil then return end
  url = url:gsub("\n", "\r\n")
  url = url:gsub("([^%w ])", M.char_to_hex)
  url = url:gsub(" ", "+")
  return url
end

M.hex_to_char = function(x) return string.char(tonumber(x, 16)) end

M.urldecode = function(url)
  if url == nil then return end
  url = url:gsub("+", " ")
  url = url:gsub("%%(%x%x)", M.hex_to_char)
  return url
end

return M
