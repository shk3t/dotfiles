local files = require("lib.file")

local base_config = {
  python = {
    type = "python",
    request = "launch",
    pythonPath = files.python_path,
    justMyCode = true,
    cwd = vim.fn.getcwd(),
  },
  go = {
    type = "delve",
    request = "launch",
  },
}

local M = {}

M.debug_configs = {
  python = {
    ["/"] = {
      vim.tbl_extend("force", base_config.python, {
        name = "Default",
        program = "${file}",
      }),
      vim.tbl_extend("force", base_config.python, {
        name = "Default deep",
        program = "${file}",
        justMyCode = false,
      }),
    },
  },
  -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
  go = {
    ["/"] = {
      vim.tbl_extend("force", base_config.go, {
        name = "Default",
        program = "${file}",
      }),
    },
  },
  c = {
    {
      name = "Default",
      type = "cppdbg",
      request = "launch",
      program = function()
        return vim.fn.getcwd() .. "/c.out"
      end,
      cwd = "${workspaceFolder}",
      stopAtEntry = false,
      -- args = {function() return vim.fn.input("Args: ") end},
    },
  },
}

M.debug_configs.cpp = M.debug_configs.c
M.debug_configs.rust = M.debug_configs.c

return M
