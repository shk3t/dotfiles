local caches = require("lib.cache")
local consts = require("consts")

local M = {}

function M.backward_file_search(filename)
  local curdir = vim.fn.getcwd()
  repeat
    local target_path = curdir .. "/" .. filename
    if vim.fn.filereadable(target_path) == 1 then
      return target_path
    end
    curdir = vim.fn.fnamemodify(curdir, ":h")
  until curdir == "/"
end
function M.backward_file_search_c(filename)
  return caches.cache({ "backward_file_search", vim.fn.getcwd(), filename }, M.backward_file_search, { filename })
end

M.python_path = (function()
  local venvdirs = { "venv", ".venv" }

  for _, venvdir in pairs(venvdirs) do
    local pybin = M.backward_file_search(venvdir .. "/bin/python")
    if pybin and vim.fn.executable(pybin) == 1 then
      return pybin
    end
  end

  return consts.DEFAULT_PYTHON_PATH
end)()

return M
