local files = require("lib.file")
local consts = require("consts")

local M = {}

local python_default_config = {
  type = "python",
  request = "launch",
  pythonPath = files.python_path,
  justMyCode = true,
  cwd = vim.fn.getcwd(),
}
local go_default_config = {
  type = "delve",
  request = "launch",
}

M.debug_configs = {
  python = {
    ["/"] = {
      vim.tbl_extend("force", python_default_config, {
        name = "Default",
        program = "${file}",
      }),
      vim.tbl_extend("force", python_default_config, {
        name = "Default deep",
        program = "${file}",
        justMyCode = false,
      }),
    },
  },
  -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
  go = {
    ["/"] = {
      vim.tbl_extend("force", go_default_config, {
        name = "Default",
        program = "${file}",
      }),
    },
  },
  sh = {
    {
      type = "bashdb",
      request = "launch",
      name = "Launch file",
      showDebugOutput = true,
      pathBashdb = consts.MASON.PACKAGES .. "/bash-debug-adapter/extension/bashdb_dir/bashdb",
      pathBashdbLib = consts.MASON.PACKAGES .. "/bash-debug-adapter/extension/bashdb_dir",
      trace = true,
      file = "${file}",
      program = "${file}",
      cwd = "${workspaceFolder}",
      pathCat = "cat",
      pathBash = "/bin/bash",
      pathMkfifo = "mkfifo",
      pathPkill = "pkill",
      args = {},
      env = {},
      terminalKind = "integrated",
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
  javascript = {
    {
      name = "Default",
      type = "pwa-node",
      request = "launch",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
  },
}

M.debug_configs.cpp = M.debug_configs.c
M.debug_configs.rust = M.debug_configs.c

local typescript_configurations = vim.deepcopy(M.debug_configs.javascript)
for _, config in pairs(typescript_configurations) do
  config.runtimeArgs = {
    "-r",
    "ts-node/register",
  }
end
M.debug_configs.typescript = typescript_configurations

return M
