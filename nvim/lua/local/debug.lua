local python_default_config = require("lib.debug").python_default_config

local M = {}

M.local_configs = {
  python = {
    ["gogame/backend"] = {
      vim.tbl_extend("force", python_default_config, {
        name = "GoGame FastApi",
        program = vim.fn.getcwd() .. "/run.py",
        args = {"--debug"},
        -- console = "externalTerminal",
      }),
      vim.tbl_extend("force", python_default_config, {
        name = "Default",
        program = "${file}",
      }),
    },
    ["lms/server"] = {
      vim.tbl_extend("force", python_default_config, {
        name = "LMS Django",
        program = vim.fn.getcwd() .. "/manage.py",
        args = {"runserver", "--noreload"},
      }),
    },
  },
}

return M
