local python_default_config = require("lib.debug").python_default_config

local M = {}

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
    ["/itresume/lms"] = { django_cfg, django_deep_debug_cfg },
    ["/itresume/wb%-backend"] = {
      django_cfg,
      django_deep_debug_cfg,
      vim.tbl_extend("force", python_default_config, {
        name = "Try Django script",
        program = vim.fn.getcwd() .. "/bin/try.py",
      }),
      vim.tbl_extend("force", python_default_config, {
        name = "Try Django script deep",
        program = vim.fn.getcwd() .. "/bin/try.py",
        justMyCode = false,
      }),
      vim.tbl_extend("force", python_default_config, {
        name = "Deep debug makemigrations",
        program = vim.fn.getcwd() .. "/manage.py",
        args = { "makemigrations", "stats", "users" },
        justMyCode = false,
      }),
      vim.tbl_extend("force", python_default_config, {
        name = "Deep debug migrate",
        program = vim.fn.getcwd() .. "/manage.py",
        args = { "migrate" },
        justMyCode = false,
      }),
    },
    ["/modeling/simpy_coursework"] = {
      vim.tbl_extend("force", python_default_config, {
        name = "Main",
        program = vim.fn.getcwd() .. "/main.py",
      }),
    },
  },
}

return M
