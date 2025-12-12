local keymap = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local cmds = require("lib.cmds")
local dap = require("dap")
local strings = require("lib.base.string")
local sys = require("lib.system")
local tables = require("lib.base.table")
local debug_configs = require("plugin.data.dap").debug_configs
local consts = require("consts")
local files = require("lib.file")
local lcfg = require("lib.localcfg")
local state = require("state")
local teleutils = require("plugin.util.telescope")
local utils = require("plugin.util.dap")

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
dap.adapters.bashdb = {
  type = "executable",
  command = consts.MASON.PACKAGES .. "/bash-debug-adapter/bash-debug-adapter",
  name = "bashdb",
}
dap.adapters.cppdbg = {
  id = "cppdbg",
  type = "executable",
  command = consts.MASON.BIN .. "/OpenDebugAD7",
}
dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = consts.MASON.BIN .. "/js-debug-adapter",
    args = { "${port}" },
  },
}

local function set_language_configurations()
  for _, language in pairs(vim.tbl_keys(debug_configs)) do
    dap.configurations[language] = {}
    local local_configs = lcfg.local_config_or({ "debug", language }, nil, { reload = false })
    if local_configs then
      dap.configurations[language] = local_configs
    else
      for path, config in tables.sorted_pairs(debug_configs[language]) do
        if type(path) == "number" or type(path) == "string" and strings.contains(vim.fn.getcwd(), path) then
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
keymap("n", "<F8>", dap.step_over)
keymap("n", "<F7>", dap.step_into)
keymap("n", "<S-F8>", dap.step_out)
keymap("n", "<S-F9>", dap.goto_)
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
keymap("n", "[b", utils.breakpoint_jump_back)
keymap("n", "]b", utils.breakpoint_jump_forward)
keymap(
  "n",
  "<Space>tb",
  teleutils.quickfix_picker("Breakpoints", function()
    vim.cmd.copen()
    dap.list_breakpoints()
  end)
)
keymap("n", "[s", dap.up)
keymap("n", "]s", dap.down)

autocmd("FileType", {
  pattern = "dap-repl",
  callback = function()
    keymap("i", "<C-K>", "<C-W>k", { buffer = true })
    keymap("i", "<C-W>", "<C-O>db<BS>", { buffer = true })
    keymap("i", "<C-P>", "<Up><End>", { buffer = true, remap = true })
    keymap("i", "<C-N>", "<Down><End>", { buffer = true, remap = true })
    keymap("n", "<CR>", function()
      local row = unpack(vim.api.nvim_win_get_cursor(0))
      local current_buffer = vim.api.nvim_win_get_buf(0)
      local count = vim.api.nvim_buf_line_count(current_buffer)
      if row == count then
        cmds.typekeys("<Insert><CR>")
      else
        utils.trigger_first_action()
      end
    end, { buffer = true, remap = true })
    keymap("n", "o", function()
      utils.trigger_first_action()
    end, { buffer = true, remap = true })
  end,
})
autocmd("FileType", {
  pattern = "dap-float",
  callback = function()
    keymap("n", "o", function()
      utils.trigger_first_action()
    end, { buffer = true, remap = true })
  end,
})
