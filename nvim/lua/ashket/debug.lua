local dap = require("dap")
local dapui = require("dapui")
local widgets = require("dap.ui.widgets")
local keymap = vim.keymap.set
local splitString = require("ashket.utils").splitString

local pythonPath = (function()
  local cwd = vim.fn.getcwd()
  local venvdirs = {"venv", ".venv"}

  for i, venvdir in ipairs(venvdirs) do
    local venvpath = cwd .. "/" .. venvdir
    local pybin = venvpath .. "/bin/python"
    if vim.fn.executable(pybin) == 1 then
      return pybin
    end

    if vim.fn.isdirectory(venvpath) == 1 then
      for venvsubdir, filetype in vim.fs.dir(venvpath) do
        pybin = venvpath .. "/" .. venvsubdir .. "/bin/python"
        if filetype == "directory" and vim.fn.executable(pybin) == 1 then
          return pybin
        end
      end
    end
  end

  return "/usr/bin/python"
end)()

local inputFile = function() return vim.fn.getcwd() .. "/" .. vim.fn.input("File: ") end

local inputArgs = function() return splitString(vim.fn.input("Args: ")) end

keymap({"i", "n", "v"}, "<F9>", dap.continue)
keymap({"i", "n", "v"}, "<F8>", dap.step_over)
keymap({"i", "n", "v"}, "<F7>", dap.step_into)
keymap({"i", "n", "v"}, "<S-F8>", dap.step_out)
keymap("n", "<Space>b", dap.toggle_breakpoint)
-- keymap("n", "<Space>dl", dap.list_breakpoints)
keymap("n", "<Space>dc", dap.repl.open)
keymap("n", "<Space>dp", dap.up)
keymap("n", "<Space>dn", dap.down)
keymap("n", "<Space>dr", dap.run_last)
keymap("n", "<Space>ds", function() widgets.sidebar(widgets.scopes).open() end)
keymap("n", "<Space>dd", function()
  -- vim.cmd([[execute "normal! \<C-W>o"]])
  dapui.open()
  vim.cmd([[execute "normal! \<C-W>l\<C-W>j"]])
  widgets.sidebar(widgets.scopes).open()
  vim.cmd([[execute "normal! \<C-W>q80\<C-W>|40\<C-W>_\<C-W>k\<C-W>h"]])
end)
-- keymap("n", "<Space>dk", dapui.eval)
keymap({"n", "v"}, "<Space>dk", widgets.hover)

dap.defaults.fallback.external_terminal = {
  command = "/usr/bin/alacritty",
  args = {"-e"},
}

dapui.setup({
  controls = {element = "stacks"},
  icons = {collapsed = ">", current_frame = ">", expanded = "v"},
  floating = {border = "single"},
  layouts = {
    {
      elements = {{id = "scopes", size = 0.8}, {id = "stacks", size = 0.2}},
      position = "right",
      size = 80,
    },
    {elements = {{id = "repl", size = 1}}, position = "bottom", size = 12},
  },
  render = {indent = 2},
})

dap.adapters.python = {
  type = "executable",
  -- command = getPythonPath(),
  command = pythonPath,
  args = {"-m", "debugpy.adapter"},
}
dap.adapters.lldb = {
  type = "executable",
  command = "/usr/bin/lldb-vscode", -- adjust as needed, must be absolute path
  name = "lldb",
}

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Default",
    program = "${file}",
    pythonPath = pythonPath,
  },
  {
    type = "python",
    request = "launch",
    name = "Specify file and args",
    program = inputFile,
    args = inputArgs,
    pythonPath = pythonPath,
  },
  {
    type = "python",
    request = "launch",
    name = "Django (noreload)",
    program = vim.fn.getcwd() .. "/manage.py",
    args = {"runserver", "--noreload"},
    pythonPath = pythonPath,
  },
  {
    type = "python",
    request = "launch",
    name = "s11",
    program = vim.fn.getcwd() .. "/s11main.py",
    pythonPath = pythonPath,
  },
}
dap.configurations.c = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function() return vim.fn.getcwd() .. "/c.out" end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {function() return vim.fn.input("Args: ") end},
  },
}
dap.configurations.cpp = dap.configurations.c
dap.configurations.rust = dap.configurations.c

-- dap.adapters.codelldb = {
--   type = "server",
--   port = "${port}",
--   executable = {
--     command = os.getenv("HOME") .. "/.local/share/nvim/mason/bin/codelldb",
--     args = {"--port", "${port}"},
--   },
-- }
-- dap.adapters.cppdbg = {
--   id = "cppdbg",
--   type = "executable",
--   command = os.getenv("HOME") .. "/.local/share/nvim/mason/bin/OpenDebugAD7",
-- }
-- dap.configurations.c = {
--   {
--     name = "Launch file",
--     type = "cppdbg",
--     request = "launch",
--     program = function() return vim.fn.getcwd() .. "/c.out" end,
--     cwd = "${workspaceFolder}",
--     stopAtEntry = false,
--     args = {function() return vim.fn.input("Args: ") end},
--     setupCommands = {
--       {
--         text = "-enable-pretty-printing",
--         description = "enable pretty printing",
--         ignoreFailures = false,
--       },
--     },
--   },
-- }
