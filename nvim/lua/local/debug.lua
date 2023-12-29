local python_default_config = require("lib.debug").python_default_config

local M = {}

M.local_configs = {
  python = {
    ["/"] = {
      vim.tbl_extend("force", python_default_config, {
        name = "Default",
        program = "${file}",
      }),
    },
    ["/gogame/backend"] = {
      vim.tbl_extend("force", python_default_config, {
        name = "GoGame FastApi",
        program = vim.fn.getcwd() .. "/run.py",
        args = {"--debug"},
        -- console = "externalTerminal",
      }),
    },
    ["/itresume"] = {
      vim.tbl_extend("force", python_default_config, {
        name = "Django",
        program = vim.fn.getcwd() .. "/manage.py",
        args = {"runserver", "--noreload"},
      }),
      vim.tbl_extend("force", python_default_config, {
        name = "Django deep debug",
        program = vim.fn.getcwd() .. "/manage.py",
        args = {"runserver", "--noreload"},
        justMyCode = false,
      }),
    },
    ["/wb%-backend"] = {
      vim.tbl_extend("force", python_default_config,
                     {
        name = "Try Django script",
        program = vim.fn.getcwd() .. "/bin/try.py",
      }),
    },
  },
}

return M
