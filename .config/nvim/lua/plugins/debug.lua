local dap = require("dap")
local daplib = require("lib.debug")
local dapui = require("dapui")
local lib = require("lib.main")
local widgets = require("dap.ui.widgets")
local debug_configs = require("global.debug").debug_configs
local keymap = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local consts = require("lib.consts")
local state = require("lib.state")

state.dap.widgets.scopes = widgets.sidebar(widgets.scopes)

dap.listeners.after.event_initialized["steal_focus"] = function()
  print("Debugger is active!")
end
dap.listeners.after.event_continued["steal_focus"] = function()
  state.system.tmux_window_id = vim.fn.system([[tmux display-message -p "#I"]])
end
dap.listeners.after.event_stopped["steal_focus"] = function()
  vim.fn.system("xdotool windowactivate " .. state.system.terminal_window_id)
  vim.fn.system("[[ $TMUX ]] && tmux select-window -t " .. state.system.tmux_window_id)
end

dap.listeners.after.event_stopped["clear_focused_thread"] = function(session, body)
  state.dap.focus.thread = {}
end

local dapui_config = {
  controls = { enabled = false, element = "stacks" },
  icons = { collapsed = ">", current_frame = ">", expanded = "v" },
  mappings = {
    add = "A",
    edit = "C",
    expand = { "<CR>", "<2-LeftMouse>", "o" },
    open = "O",
    remove = "D",
    repl = "r",
    toggle = "t",
  },
  element_mappings = {
    stacks = { open = { "<CR>", "<2-LeftMouse>", "o" } },
    -- breakpoints = { open = { "<CR>", "<2-LeftMouse>", "o" } },
  },
  expand_lines = false,
  floating = { border = consts.VERTICAL_BORDERS },
  layouts = {
    {
      elements = {
        { id = "stacks", size = 0.15 },
        { id = "scopes", size = 0.60 },
        { id = "watches", size = 0.25 },
      },
      position = "right",
      size = 65,
    },
    { elements = { { id = "repl", size = 1 } }, position = "bottom", size = 10 },
  },
  render = { indent = 2 },
}

local function breakpoint_jump(find_func)
  local cur_row, cur_col = unpack(vim.api.nvim_win_get_cursor(0))
  local cur_buf = vim.api.nvim_get_current_buf()
  local cur_win = vim.api.nvim_get_current_win()
  vim.cmd.copen()
  dap.list_breakpoints()
  local qflist = vim.fn.getqflist()
  vim.cmd.cclose()
  vim.api.nvim_set_current_win(cur_win)
  qflist = lib.filter_list(function(v)
    return v.bufnr == cur_buf
  end, qflist)
  if lib.is_empty(qflist) then
    return
  end
  lib.save_jump()
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

local function switch_thread_focus(step)
  if not daplib.update_focused_thread() or step == 0 then
    return
  end
  local threads = lib.compact(dap.session().threads)
  local f_thread = state.dap.focus.thread

  local start
  for i, v in pairs(threads) do
    if v.id == f_thread.id then
      start = i + 1
      print("i:", i)
    end
  end
  local finish = start + #threads - 2
  if step < 0 then
    start, finish = finish, start
  end

  for i = start, finish, step do
    local thread = threads[(i - 1) % #threads + 1]
    if not lib.contains_any(thread.name, consts.DAP.RUNTIME_THREADS) then
      f_thread.id = thread.id
      f_thread.name = thread.name
      break
    end
  end

  widgets.centered_float(widgets.threads)
  vim.fn.search("\\V" .. f_thread.name)
  daplib.trigger_first_action()
  vim.cmd.sleep("1m")
  vim.fn.search([[^\(.*\<\(]] .. table.concat(consts.DAP.RUNTIME_THREADS, [[\|]]) .. [[\)\>\)\@!.*$]])
  daplib.trigger_first_action()
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
keymap("n", "[t", function()
  switch_thread_focus(-1)
end)
keymap("n", "]t", function()
  switch_thread_focus(1)
end)
keymap("n", "<Space>dc", dap.repl.open)
keymap("n", "<Space>dr", function()
  vim.cmd.wall()
  dap.run_last()
end)
keymap("n", "<Space>ds", function()
  state.dap.widgets.scopes.toggle()
end)
keymap("n", "<Space>dt", function()
  widgets.centered_float(widgets.threads)
end)
keymap("n", "<Space>dg", dapui.toggle)
keymap({ "n", "v" }, "<Space>de", function(expr)
  widgets.hover(expr, { border = consts.VERTICAL_BORDERS })
end)

dap.defaults.fallback.external_terminal = {
  command = "/usr/bin/alacritty",
  args = { "-e" },
}
dap.defaults.auto_continue_if_many_stopped = false

dapui.setup(dapui_config)

dap.adapters.python = {
  type = "executable",
  command = lib.python_path,
  args = { "-m", "debugpy.adapter" },
}
dap.adapters.cppdbg = {
  id = "cppdbg",
  type = "executable",
  command = vim.env.HOME .. "/.local/share/nvim/mason/bin/OpenDebugAD7",
}
-- require("dap-vscode-js").setup({
--   -- https://github.com/mxsdev/nvim-dap-vscode-js/issues/58
--   -- https://www.reddit.com/r/neovim/comments/y7dvva/typescript_debugging_in_neovim_with_nvimdap/
--   debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
--   debugger_cmd = {"js-debug-adapter"},
--   adapters = {
--     "pwa-node",
--     "pwa-chrome",
--     "pwa-msedge",
--     "node-terminal",
--     "pwa-extensionHost",
--   },
-- })
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

for _, language in pairs({ "python", "go", "c", "cpp", "rust", "javascript", "typescript", "sh" }) do
  dap.configurations[language] = {}
  for path, config in lib.sorted_pairs(debug_configs[language]) do
    if type(path) == "number" or type(path) == "string" and lib.contains(vim.fn.getcwd(), path) then
      for _, config_entry in pairs(config) do
        table.insert(dap.configurations[language], config_entry)
      end
    end
  end
end

-- autocmd("BufWritePost", {
--   callback = function()
--     vim.cmd("silent lua require('dap').restart()")
--   end,
-- })
autocmd("FileType", {
  pattern = "dap-repl",
  callback = function()
    keymap("i", "<C-K>", "<C-W>k", { buffer = true })
    keymap("i", "<C-L>", "<C-W>k", { buffer = true })
    keymap("i", "<C-Q>", "<C-W>k", { buffer = true })
    keymap("i", "<C-W>", "<C-O>db<BS>", { buffer = true })
    keymap("i", "<C-P>", "<Up><End>", { buffer = true, remap = true })
    keymap("i", "<C-N>", "<Down><End>", { buffer = true, remap = true })
    keymap("n", "<CR>", function()
      local row = unpack(vim.api.nvim_win_get_cursor(0))
      local current_buffer = vim.api.nvim_win_get_buf(0)
      local count = vim.api.nvim_buf_line_count(current_buffer)
      if row == count then
        vim.api.nvim_input("<Insert><CR>")
      else
        daplib.trigger_first_action()
      end
    end, { buffer = true, remap = true })
  end,
})
autocmd("FileType", {
  pattern = "dap-float",
  callback = function()
    keymap("n", "o", function()
      daplib.trigger_first_action()
    end, { buffer = true, remap = true })
  end,
})
autocmd("BufEnter", {
  pattern = "DAP Watches",
  callback = function()
    keymap("i", "<C-W>", "<C-O>db<BS>", { buffer = true })
    keymap("n", "u", vim.cmd.undo, { buffer = true })
  end,
})
