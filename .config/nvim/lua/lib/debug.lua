local M = {}

local lib = require("lib.main")

M.python_default_config = {
  type = "python",
  request = "launch",
  pythonPath = lib.python_path,
  justMyCode = true,
  cwd = vim.fn.getcwd(),
}

M.go_default_config = {
  type = "delve",
  request = "launch",
}

return M
