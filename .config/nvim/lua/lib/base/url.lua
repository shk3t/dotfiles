local M = {}

function M.char_to_hex(c) return ("%%%02X"):format(c:byte()) end

function M.hex_to_char(x) return string.char(tonumber(x, 16)) end

function M.url_encode(url)
  if url == nil then return end
  url = url:gsub("\n", "\r\n")
  url = url:gsub("([^%w ])", M.char_to_hex)
  url = url:gsub(" ", "+")
  return url
end

function M.url_decode(url)
  if url == nil then return end
  url = url:gsub("+", " ")
  url = url:gsub("%%(%x%x)", M.hex_to_char)
  return url
end

return M
