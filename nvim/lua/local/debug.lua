local python_default_config = require("lib.debug").python_default_config

local M = {}

M.local_configs = {
  python = {
    ["s11"] = {
      vim.tbl_extend("force", python_default_config, {
        name = "s11",
        program = vim.fn.getcwd() .. "/s11main.py",
      }),
      vim.tbl_extend("force", python_default_config, {
        name = "s11 external terminal",
        program = vim.fn.getcwd() .. "/s11main.py",
        console = "externalTerminal",
      }),
      vim.tbl_extend("force", python_default_config,
                     {
        name = "Update policies",
        program = vim.fn.getcwd() .. "/update_policies.py",
      }),
      vim.tbl_extend("force", python_default_config, {
        name = "Update policies external terminal",
        program = vim.fn.getcwd() .. "/update_policies.py",
        console = "externalTerminal",
      }),
    },
    ["PharmacyServer"] = {
      vim.tbl_extend("force", python_default_config, {
        name = "Django (noreload)",
        program = vim.fn.getcwd() .. "/manage.py",
        args = {"runserver", "--noreload"},
      }),
    },
    ["MDLPServer"] = {
      vim.tbl_extend("force", python_default_config, {
        name = "Flask",
        program = vim.fn.getcwd() .. "/main.py",
      }),
    },
    ["gogame/backend"] = {
      vim.tbl_extend("force", python_default_config,
                     {
        name = "GoGame FastApi",
        program = vim.fn.getcwd() .. "/rundev.py",
      }),
      vim.tbl_extend("force", python_default_config, {
        name = "Default",
        program = "${file}",
      }),
    },
  },
}

return M
