local keymap = vim.keymap.set
local dap = require("dap")
local sys = require("lib.system")
local tables = require("lib.base.table")
local debug_configs = require("data.dap").debug_configs
local consts = require("consts")
local files = require("lib.file")
local lcfg = require("lib.localcfg")
local state = require("state")
local teleutils = require("util.telescope")
local utils = require("util.dap")

dap.defaults.fallback.external_terminal = {
  command = "/usr/bin/alacritty",
  args = { "-e" },
}
dap.defaults.auto_continue_if_many_stopped = false

dap.adapters.python = {
  type = "executable",
  command = files.python_path,
  args = { "-m", "debugpy.adapter" },
}
dap.adapters.delve = {
  type = "server",
  port = "${port}",
  executable = {
    command = "dlv",
    args = { "dap", "-l", "127.0.0.1:${port}" },
  },
}
dap.adapters.cppdbg = {
  id = "cppdbg",
  type = "executable",
  command = consts.MASON.BIN .. "/OpenDebugAD7",
}

local function set_language_configurations()
  for _, language in pairs(vim.tbl_keys(debug_configs)) do
    dap.configurations[language] = {}
    local local_configs = lcfg.local_config_or({ "debug", language }, nil, { reload = false })
    if local_configs then
      dap.configurations[language] = local_configs
    else
      for path, config in tables.sorted_pairs(debug_configs[language]) do
        if type(path) == "number" or type(path) == "string" and vim.fn.getcwd():find(path) then
          for _, config_entry in pairs(config) do
            table.insert(dap.configurations[language], config_entry)
          end
        end
      end
    end
  end
end
set_language_configurations()

dap.listeners.after.event_initialized["steal_focus"] = function()
  print("Debugger is active!")
end
dap.listeners.after.event_continued["steal_focus"] = function()
  state.system.tmux_window_id = sys.get_tmux_window()
end
dap.listeners.after.event_stopped["steal_focus"] = function()
  sys.focus_window(state.system.terminal_window_id)
  sys.focus_tmux_window(state.system.tmux_window_id)
end
dap.listeners.after.event_stopped["clear_focused_thread"] = function(session, body)
  state.dap.focus.thread = {}
end

keymap("n", "<F9>", dap.continue)
keymap("n", "<S-F9>", dap.goto_)
keymap("n", "<F8>", dap.step_over)
keymap("n", "<F7>", dap.step_into)
keymap("n", "<S-F7>", dap.step_out)
keymap("n", "<Space>df", dap.focus_frame)
keymap("n", "<Space>dr", function()
  vim.cmd.wall()
  dap.run_last()
end)
keymap("n", "<Space>b", dap.toggle_breakpoint)
keymap("n", "<Space>BC", function()
  dap.set_breakpoint(vim.fn.input(""))
end)
keymap("n", "<Space>BL", function()
  dap.set_breakpoint(nil, nil, vim.fn.input(""))
end)
keymap("n", "[B", utils.breakpoint_jump_back)
keymap("n", "]B", utils.breakpoint_jump_forward)
keymap(
  "n",
  "<Space>tb",
  teleutils.quickfix_picker("Breakpoints", function()
    vim.cmd.copen()
    dap.list_breakpoints()
  end)
)
keymap("n", "[S", dap.up)
keymap("n", "]S", dap.down)
