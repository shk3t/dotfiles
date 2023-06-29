local dap = require("dap")
local dapui = require("dapui")
local widgets = require("dap.ui.widgets")
local keymap = vim.keymap.set
local t = require("ashket.utils").t
local split_string = require("ashket.utils").split_string
local merge_tables = require("ashket.utils").merge_tables

local terminal_window_id = vim.fn.system([[xdotool getactivewindow]])
local tmux_window_id = vim.fn.system([[tmux display-message -p "#I"]])
dap.listeners.after.event_initialized["steal_focus"] = function() print("Debugger is active!") end
dap.listeners.after.event_continued["steal_focus"] = function()
  tmux_window_id = vim.fn.system([[tmux display-message -p "#I"]])
end
dap.listeners.after.event_stopped["steal_focus"] = function()
  vim.fn.system("xdotool windowactivate " .. terminal_window_id)
  vim.fn.system("[[ $TMUX ]] && tmux select-window -t " .. tmux_window_id)
end

-- dap.listeners.after.event_initialized["auto_open_close"] = function() dapui.open() end
-- dap.listeners.before.event_terminated["auto_open_close"] = function() dapui.close() end
-- dap.listeners.before.event_exited["auto_open_close"] = function() dapui.close() end

local python_path = (function()
  local cwd = vim.fn.getcwd()
  local venvdirs = {"venv", ".venv"}

  for _, venvdir in ipairs(venvdirs) do
    local venvpath = cwd .. "/" .. venvdir
    local pybin = venvpath .. "/bin/python"
    if vim.fn.executable(pybin) == 1 then return pybin end

    if vim.fn.isdirectory(venvpath) == 1 then
      for venvsubdir, filetype in vim.fs.dir(venvpath) do
        pybin = venvpath .. "/" .. venvsubdir .. "/bin/python"
        if filetype == "directory" and vim.fn.executable(pybin) == 1 then return pybin end
      end
    end
  end

  return "/usr/bin/python"
end)()

local input_file = function() return vim.fn.getcwd() .. "/" .. vim.fn.input("File: ") end
local input_args = function() return split_string(vim.fn.input("Args: ")) end

local scopes_widget_winid = 0
local function open_custom_dapui()
  dapui.open()
  vim.fn.execute(t("normal! <C-W>l<C-W>k<C-W>j"))
  _, scopes_widget_winid = widgets.sidebar(widgets.scopes).open()
  vim.fn.execute(t("normal! <C-W>q80<C-W>|40<C-W>_<C-W>k<C-W>h"))
end
local function close_custom_dapui()
  dapui.close()
  vim.api.nvim_win_close(scopes_widget_winid, false)
  scopes_widget_winid = 0
end

keymap({"i", "n", "v"}, "<F9>", dap.continue)
keymap({"i", "n", "v"}, "<F8>", dap.step_over)
keymap({"i", "n", "v"}, "<F7>", dap.step_into)
keymap({"i", "n", "v"}, "<S-F8>", dap.step_out)
keymap({"i", "n", "v"}, "<S-F9>", dap.goto_)
keymap("n", "<Space>b", dap.toggle_breakpoint)
keymap("n", "<Space>BC", function() dap.set_breakpoint(vim.fn.input("")) end)
keymap("n", "<Space>BL", function() dap.set_breakpoint(nil, nil, vim.fn.input("")) end)
keymap("n", "<Space>df", dap.focus_frame)
-- keymap("n", "<Space>dl", dap.list_breakpoints)
keymap("n", "<Space>dc", dap.repl.open)
keymap("n", "<Space>dn", dap.up)
keymap("n", "<Space>dp", dap.down)
keymap("n", "<Space>dr", dap.run_last)
keymap("n", "<Space>ds", function() widgets.sidebar(widgets.scopes).open() end)
keymap("n", "<Space>dd", function()
  if scopes_widget_winid == 0 then
    open_custom_dapui()
  else
    scopes_widget_tabid = vim.api.nvim_win_get_tabpage(scopes_widget_winid)
    current_tabid = vim.api.nvim_get_current_tabpage()
    close_custom_dapui()
    if current_tabid ~= scopes_widget_tabid then open_custom_dapui() end
  end
end)
keymap({"n", "v"}, "<Space>dk", widgets.hover)

dap.defaults.fallback.external_terminal = {
  command = "/usr/bin/alacritty",
  args = {"-e"},
}

dapui.setup({
  controls = {enabled = false, element = "stacks"},
  icons = {collapsed = ">", current_frame = ">", expanded = "v"},
  floating = {border = "single"},
  layouts = {
    {
      elements = {
        {id = "watches", size = 0.15},
        {id = "scopes", size = 0.7},
        {id = "stacks", size = 0.15},
      },
      position = "right",
      size = 80,
    },
    {elements = {{id = "repl", size = 1}}, position = "bottom", size = 12},
  },
  render = {indent = 2},
})

dap.adapters.python = {
  type = "executable",
  command = python_path,
  args = {"-m", "debugpy.adapter"},
}
dap.adapters.lldb = {
  type = "executable",
  command = "/usr/bin/lldb-vscode",
  name = "lldb",
}

local python_default_config = {
  type = "python",
  request = "launch",
  pythonPath = python_path,
}
dap.configurations.python = {}
if string.find(vim.fn.getcwd(), "s11") then
  dap.configurations.python[1] = merge_tables(python_default_config,
                                              {
    name = "s11",
    program = vim.fn.getcwd() .. "/s11main.py",
  })
elseif string.find(vim.fn.getcwd(), "PharmacyServer") then
  dap.configurations.python[1] = merge_tables(python_default_config, {
    name = "Django (noreload)",
    program = vim.fn.getcwd() .. "/manage.py",
    args = {"runserver", "--noreload"},
  })
elseif string.find(vim.fn.getcwd(), "MDLPServer") then
  dap.configurations.python[1] = merge_tables(python_default_config,
                                              {
    name = "Flask",
    program = vim.fn.getcwd() .. "/main.py",
  })
else
  dap.configurations.python = {
    merge_tables(python_default_config, {name = "Default", program = "${file}"}),
    -- merge_tables(python_default_config, {
    --   name = "Specify file and args",
    --   program = input_file,
    --   args = input_args,
    -- }),
  }
end

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
