local keymap = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local cmds = require("lib.cmds")
local consts = require("consts")
local inputs = require("lib.base.input")
local state = require("state")
local sys = require("lib.system")
local winbufs = require("lib.winbuf")

-- Don't add the comment prefix on o/O
autocmd("FileType", {
  callback = function()
    vim.opt_local.formatoptions:append("r")
    vim.opt_local.formatoptions:remove("c")
    vim.opt_local.formatoptions:remove("o")
  end,
})

-- Focused window line relative-numeration
autocmd({ "FocusLost", "WinLeave" }, { command = "setlocal norelativenumber" })
autocmd({ "VimEnter", "FocusGained", "WinEnter" }, {
  callback = function()
    if vim.o.number and state.relativenumber then
      vim.wo.relativenumber = true
    end
  end,
})
-- Dynamic autoscroll depending on window size
autocmd({ "BufEnter", "WinResized" }, {
  callback = function()
    cmds.set_default_scrolloff()
  end,
})
autocmd("ModeChanged", {
  pattern = "[vV]:*", -- After visual selection with mouse
  callback = function()
    cmds.set_default_scrolloff()
  end,
})

-- Highlight yank
autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 100 })
  end,
})
-- Yank preserve position
autocmd("TextYankPost", {
  callback = function()
    if vim.v.event.operator == "y" and state.preserved_position then
      vim.api.nvim_win_set_cursor(0, state.preserved_position)
      state.preserved_position = nil
    end
  end,
})

-- Easy Window closing
autocmd("FileType", {
  pattern = { "help", "dap-float", "qf" },
  callback = cmds.map_easy_closing,
})
-- Close all auxiliary windows if all the main windows were closed
autocmd("WinEnter", {
  callback = function()
    if not winbufs.is_auxiliary_buffer() then
      return
    end
    for _, win in pairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if not winbufs.is_auxiliary_buffer(buf) then
        return
      end
    end
    vim.cmd("qa")
  end,
})

-- Open help | man in vertical split
autocmd("BufEnter", {
  callback = function()
    if vim.bo.buftype == "help" or vim.bo.filetype == "man" then
      inputs.norm("<C-W>L82<C-W>|")
    end
  end,
})

-- Mapping for Cmd window
autocmd("CmdwinEnter", {
  callback = function()
    cmds.map_easy_closing()
    keymap("n", ":", "<NOP>", { buffer = true })
    keymap("n", "<CR>", "<CR>", { buffer = true })
    keymap("n", "<C-S>", "<CR>", { buffer = true })
    keymap({ "n" }, "<Esc>", "<C-W>q", { buffer = true })
    keymap({ "n", "i" }, "<C-C>", "<Esc><C-W>q", { buffer = true })
  end,
})

-- Terminal default mode is insert
autocmd({ "TermOpen", "WinEnter" }, {
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.cmd.startinsert()
    end
  end,
})

-- Auto language layout switch
local function need_save_layout()
  return vim.bo.buftype ~= "nofile" and vim.bo.buftype ~= "prompt" and vim.v.event.cmdtype ~= ":"
end
autocmd({ "InsertEnter", "CmdlineEnter" }, {
  callback = function()
    if need_save_layout() then
      sys.set_layout(state.system.mode_layout_idx)
    end
  end,
})
autocmd({ "InsertLeave", "CmdlineLeave" }, {
  callback = function()
    if need_save_layout() then
      state.system.mode_layout_idx = sys.get_layout()
    end
    sys.set_layout(consts.LAYOUT.ENGLISH_IDX)
  end,
})
