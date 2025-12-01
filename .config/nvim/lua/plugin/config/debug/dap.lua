local keymap = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local cmds = require("lib.cmds")
local dap = require("dap")
local strings = require("lib.base.string")
local sys = require("lib.system")
local tables = require("lib.base.table")
local debug_configs = require("plugin.data.debug").debug_configs
local lcfg = require("lib.localcfg")
local state = require("state")
local teleutils = require("plugin.util.telescope")
local utils = require("plugin.util.debug")

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

local function breakpoint_jump(find_func)
  local cur_row, cur_col = unpack(vim.api.nvim_win_get_cursor(0))
  local cur_buf = vim.api.nvim_get_current_buf()
  local cur_win = vim.api.nvim_get_current_win()
  vim.cmd.copen()
  dap.list_breakpoints()
  local qflist = vim.fn.getqflist()
  vim.cmd.cclose()
  vim.api.nvim_set_current_win(cur_win)
  qflist = tables.filter_list(function(v)
    return v.bufnr == cur_buf
  end, qflist)
  if tables.is_empty(qflist) then
    return
  end
  cmds.save_jump()
  vim.api.nvim_win_set_cursor(0, { find_func(cur_row, qflist), cur_col })
end
local function bp_find_prev(cur_row, qflist)
  for i = #qflist, 1, -1 do
    if qflist[i].lnum - cur_row < 0 then
      return qflist[i].lnum
    end
  end
  return qflist[#qflist].lnum
end
local function bp_find_next(cur_row, qflist)
  for i = 1, #qflist do
    if qflist[i].lnum - cur_row > 0 then
      return qflist[i].lnum
    end
  end
  return qflist[1].lnum
end

keymap({ "i", "n", "v" }, "<F9>", dap.continue)
keymap({ "i", "n", "v" }, "<F8>", dap.step_over)
keymap({ "i", "n", "v" }, "<F7>", dap.step_into)
keymap({ "i", "n", "v" }, "<S-F8>", dap.step_out)
keymap({ "i", "n", "v" }, "<S-F9>", dap.goto_)
keymap("n", "<Space>b", dap.toggle_breakpoint)
keymap("n", "<Space>BC", function()
  dap.set_breakpoint(vim.fn.input(""))
end)
keymap("n", "<Space>BL", function()
  dap.set_breakpoint(nil, nil, vim.fn.input(""))
end)
keymap("n", "<Space>df", dap.focus_frame)
keymap("n", "[b", function()
  breakpoint_jump(bp_find_prev)
end)
keymap("n", "]b", function()
  breakpoint_jump(bp_find_next)
end)
keymap("n", "[s", dap.up)
keymap("n", "]s", dap.down)
keymap("n", "<Space>dc", dap.repl.open)
keymap("n", "<Space>dr", function()
  vim.cmd.wall()
  dap.run_last()
end)
keymap(
  "n",
  "<Space>tb",
  teleutils.quickfix_picker("Breakpoints", function()
    vim.cmd.copen()
    dap.list_breakpoints()
  end)
)

dap.defaults.fallback.external_terminal = {
  command = "/usr/bin/alacritty",
  args = { "-e" },
}
dap.defaults.auto_continue_if_many_stopped = false

dap.adapters.python = {
  type = "executable",
  command = cmds.python_path,
  args = { "-m", "debugpy.adapter" },
}
dap.adapters.cppdbg = {
  id = "cppdbg",
  type = "executable",
  command = vim.env.HOME .. "/.local/share/nvim/mason/bin/OpenDebugAD7",
}
dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = vim.env.HOME .. "/.local/share/nvim/mason/bin/js-debug-adapter",
    args = { "${port}" },
  },
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
  command = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/bash-debug-adapter",
  name = "bashdb",
}

local function setup_configs()
  for _, language in pairs({ "python", "go", "c", "cpp", "rust", "javascript", "typescript", "sh" }) do
    dap.configurations[language] = {}
    local local_configs = lcfg.local_config_or({ "debug", language }, nil, { reload = false })
    if local_configs then
      dap.configurations[language] = local_configs
      goto continue
    end

    for path, config in tables.sorted_pairs(debug_configs[language]) do
      if type(path) == "number" or type(path) == "string" and strings.contains(vim.fn.getcwd(), path) then
        for _, config_entry in pairs(config) do
          table.insert(dap.configurations[language], config_entry)
        end
      end
    end
    ::continue::
  end
end
setup_configs()

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
