local M = {}

local caches = require("lib.cache")

M.backward_file_search = function(filename)
  local curdir = vim.fn.getcwd()
  repeat
    local target_path = curdir .. "/" .. filename
    if vim.fn.filereadable(target_path) == 1 then
      return target_path
    end
    curdir = vim.fn.fnamemodify(curdir, ":h")
  until curdir == "/"
end
M.backward_file_search_c = function(filename)
  return caches.cache({ "backward_file_search", vim.fn.getcwd(), filename }, M.backward_file_search, { filename })
end

return M
