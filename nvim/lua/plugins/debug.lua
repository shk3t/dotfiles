local dap = require("dap")
local dapui = require("dapui")
local widgets = require("dap.ui.widgets")
local lib = require("lib.main")
local dlib = require("lib.debug")
local local_configs = require("local.debug").local_configs
local keymap = vim.keymap.set

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

-- local input_file = function() return vim.fn.getcwd() .. "/" .. vim.fn.input("File: ") end
-- local input_args = function() return split_string(vim.fn.input("Args: ")) end

local dapui_config = {
  controls = {enabled = false, element = "stacks"},
  icons = {collapsed = ">", current_frame = ">", expanded = "v"},
  element_mappings = {
    stacks = {open = {"<CR>", "<2-LeftMouse>"}, expand = {"o", "O"}},
    watches = {remove = "D", edit = "C", repl = "S"},
  },
  expand_lines = false,
  floating = {border = "single"},
  layouts = {
    {
      elements = {
        {id = "watches", size = 0.1},
        {id = "scopes", size = 0.75},
        {id = "stacks", size = 0.15},
      },
      position = "right",
      size = 65,
    },
    {elements = {{id = "repl", size = 1}}, position = "bottom", size = 10},
  },
  render = {indent = 2},
}

local max_win_height = vim.api.nvim_win_get_height(0)
local scopes_widget_width = dapui_config.layouts[1].size
local scopes_widget_height = math.floor(lib.find(function(v) return v.id == "scopes" end,
                                                 dapui_config.layouts[1].elements).size * max_win_height)
local scopes_widget_winid = 0
local function open_custom_dapui()
  dapui.open()
  lib.norm("<C-W>l<C-W>k<C-W>j")
  _, scopes_widget_winid = widgets.sidebar(widgets.scopes).open()
  lib.norm("<C-W>q" .. scopes_widget_width .. "<C-W>|" .. scopes_widget_height .. "<C-W>_<C-W>k<C-W>h")
end
local function close_custom_dapui()
  dapui.close()
  vim.api.nvim_win_close(scopes_widget_winid, false)
  scopes_widget_winid = 0
end

local function breakpoint_jump(find_func)
  local cur_row, cur_col = unpack(vim.api.nvim_win_get_cursor(0))
  local cur_buf = vim.api.nvim_get_current_buf()
  local cur_win = vim.api.nvim_get_current_win()
  vim.cmd.copen()
  dap.list_breakpoints()
  local qflist = vim.fn.getqflist()
  vim.cmd.cclose()
  vim.api.nvim_set_current_win(cur_win)
  qflist = lib.filter(function(v) return v.bufnr == cur_buf end, qflist)
  if lib.is_empty(qflist) then return end
  lib.save_jump()
  vim.api.nvim_win_set_cursor(0, {find_func(cur_row, qflist), cur_col})
end
local function bp_find_prev(cur_row, qflist)
  for i = #qflist, 1, -1 do if qflist[i].lnum - cur_row < 0 then return qflist[i].lnum end end
  return qflist[#qflist].lnum
end
local function bp_find_next(cur_row, qflist)
  for i = 1, #qflist do if qflist[i].lnum - cur_row > 0 then return qflist[i].lnum end end
  return qflist[1].lnum
end

keymap({"i", "n", "x"}, "<F9>", dap.continue)
keymap({"i", "n", "x"}, "<F8>", dap.step_over)
keymap({"i", "n", "x"}, "<F7>", dap.step_into)
keymap({"i", "n", "x"}, "<S-F8>", dap.step_out)
keymap({"i", "n", "x"}, "<S-F9>", dap.goto_)
keymap("n", "<Space>b", dap.toggle_breakpoint)
keymap("n", "<Space>BC", function() dap.set_breakpoint(vim.fn.input("")) end)
keymap("n", "<Space>BL", function() dap.set_breakpoint(nil, nil, vim.fn.input("")) end)
keymap("n", "<Space>df", dap.focus_frame)
keymap("n", "[b", function() breakpoint_jump(bp_find_prev) end)
keymap("n", "]b", function() breakpoint_jump(bp_find_next) end)
keymap("n", "[s", dap.down)
keymap("n", "]s", dap.up)
keymap("n", "<Space>dc", dap.repl.open)
keymap("n", "<Space>dr", dap.run_last)
keymap("n", "<Space>ds", function() widgets.sidebar(widgets.scopes).open() end)
keymap("n", "<Space>dd", function()
  if scopes_widget_winid == 0 then
    open_custom_dapui()
  else
    local is_opened, scopes_widget_tabid =
      pcall(function() return vim.api.nvim_win_get_tabpage(scopes_widget_winid) end)
    if not is_opened then open_custom_dapui() end
    local current_tabid = vim.api.nvim_get_current_tabpage()
    close_custom_dapui()
    if current_tabid ~= scopes_widget_tabid then open_custom_dapui() end
  end
end)
keymap({"n", "x"}, "<Space>de", widgets.hover)

dap.defaults.fallback.external_terminal = {
  command = "/usr/bin/alacritty",
  args = {"-e"},
}

dapui.setup(dapui_config)

dap.adapters.python = {
  type = "executable",
  command = dlib.python_path,
  args = {"-m", "debugpy.adapter"},
}
dap.adapters.lldb = {
  type = "executable",
  command = "/usr/bin/lldb-vscode",
  name = "lldb",
}

dap.configurations.python = {}
for path, config in pairs(local_configs.python) do
  if lib.cwd_contains(path) then
    dap.configurations.python = config
    break
  end
end
if lib.is_empty(dap.configurations.python) then
  dap.configurations.python = {
    vim.tbl_extend("force", dlib.python_default_config, {
      name = "Default",
      program = "${file}",
    }),
    -- vim.tbl_extend("force", python_default_config, {
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
