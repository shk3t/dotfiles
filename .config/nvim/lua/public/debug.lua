local M = {}

local ulib = require("lib.utils")

local python_default_config = {
  type = "python",
  request = "launch",
  pythonPath = ulib.python_path,
  justMyCode = true,
  cwd = vim.fn.getcwd(),
}
local go_default_config = {
  type = "delve",
  request = "launch",
}

local django_cfg = vim.tbl_extend("force", python_default_config, {
  name = "Django",
  program = vim.fn.getcwd() .. "/manage.py",
  args = { "runserver", "--noreload" },
})
local django_deep_debug_cfg = vim.tbl_extend("force", python_default_config, {
  name = "Django deep debug",
  program = vim.fn.getcwd() .. "/manage.py",
  args = { "runserver", "--noreload" },
  justMyCode = false,
})

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
    ["/gogame/backend"] = {
      vim.tbl_extend("force", python_default_config, {
        name = "GoGame FastApi",
        program = vim.fn.getcwd() .. "/run.py",
        args = { "--debug" },
        -- console = "externalTerminal",
      }),
    },
    ["/itresume/api"] = {
      vim.tbl_extend("force", python_default_config, {
        name = "Django",
        program = vim.fn.getcwd() .. "/server/manage.py",
        args = { "runserver", "--noreload" },
      }),
      vim.tbl_extend("force", python_default_config, {
        name = "Django deep debug",
        program = vim.fn.getcwd() .. "/server/manage.py",
        args = { "runserver", "--noreload" },
        justMyCode = false,
      }),
    },
    ["/itresume/vm%-service"] = { django_cfg, django_deep_debug_cfg },
    ["/itresume/lms"] = { django_cfg, django_deep_debug_cfg },
    ["/itresume/wb%-backend"] = { django_cfg, django_deep_debug_cfg },
    ["/car%-price%-prediction/ml%-service"] = { django_cfg, django_deep_debug_cfg },
    ["/itresume/analytics"] = {
      django_cfg,
      django_deep_debug_cfg,
      vim.tbl_extend("force", python_default_config, {
        name = "Try Django script",
        program = vim.fn.getcwd() .. "/scripts/try.py",
      }),
      vim.tbl_extend("force", python_default_config, {
        name = "Try Django script deep",
        program = vim.fn.getcwd() .. "/scripts/try.py",
        justMyCode = false,
      }),
      -- vim.tbl_extend("force", python_default_config, {
      --   name = "Deep debug makemigrations",
      --   program = vim.fn.getcwd() .. "/manage.py",
      --   args = { "makemigrations", "stats", "users" },
      --   justMyCode = false,
      -- }),
      -- vim.tbl_extend("force", python_default_config, {
      --   name = "Deep debug migrate",
      --   program = vim.fn.getcwd() .. "/manage.py",
      --   args = { "migrate" },
      --   justMyCode = false,
      -- }),
    },
  },
  -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
  go = {
    ["/"] = {
      vim.tbl_extend("force", go_default_config, {
        name = "Default",
        program = "${file}",
      }),
      -- {
      --   name = "Debug test", -- configuration for debugging test files
      --   type = "delve",
      --   request = "launch",
      --   mode = "test",
      --   program = "${file}"
      -- },
      -- -- works with go.mod packages and sub packages
      -- {
      --   name = "Debug test (go.mod)",
      --   type = "delve",
      --   request = "launch",
      --   mode = "test",
      --   program = "./${relativeFileDirname}"
      -- }
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
  sh = {
    {
      type = "bashdb",
      request = "launch",
      name = "Launch file",
      showDebugOutput = true,
      pathBashdb = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
      pathBashdbLib = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
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
