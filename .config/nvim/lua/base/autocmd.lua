local autocmd = vim.api.nvim_create_autocmd
local keymap = vim.keymap.set
local klib = require("lib.keymaps")
local lib = require("lib.main")
local state = require("lib.state")

-- Line numeration toggle
autocmd({ "FocusLost", "WinLeave" }, { command = "setlocal norelativenumber" })
autocmd({ "VimEnter", "FocusGained", "WinEnter" }, {
  callback = function()
    if vim.o.number then
      vim.opt_local.relativenumber = true
    end
  end,
})
-- Dynamic autoscroll near window edges
autocmd({ "VimEnter", "WinEnter", "WinResized" }, {
  callback = function()
    klib.set_default_scrolloff()
  end,
})
autocmd("ModeChanged", {
  pattern = "[vV]:*", -- After visual selection with mouse
  callback = function()
    klib.set_default_scrolloff()
  end,
})

-- Open help | man in vertical split
autocmd("BufEnter", {
  callback = function()
    if vim.bo.buftype == "help" or vim.bo.filetype == "man" then
      vim.cmd.wincmd("L")
    end
  end,
})

-- Reset mapping for Cmd window
autocmd("CmdwinEnter", {
  callback = function()
    keymap("n", "<CR>", "<CR>", { buffer = true })
  end,
})

-- Don't add the comment prefix when I hit o/O on a comment line.
autocmd("FileType", {
  callback = function()
    vim.opt_local.formatoptions:append("r")
    vim.opt_local.formatoptions:remove("c")
    vim.opt_local.formatoptions:remove("o")
  end,
})

-- Easy Window closing
autocmd("CmdwinEnter", { callback = lib.map_easy_closing })
autocmd("FileType", {
  pattern = { "help", "dap-float", "qf" },
  callback = lib.map_easy_closing,
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
    if vim.v.event.operator == "y" then
      pcall(function()
        lib.norm("`m")
        vim.cmd.delmarks("m")
      end)
    end
  end,
})

-- Close all auxiliary windows if all the main windows were closed
autocmd("WinEnter", {
  callback = function()
    if not lib.is_auxiliary_buffer() then
      return
    end
    for _, win in pairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if not lib.is_auxiliary_buffer(buf) then
        return
      end
    end
    vim.cmd("qa")
  end,
})

-- Do not restore deleted marks
autocmd("VimLeavePre", { command = "wshada!" })

-- Disable numbers in terminal mode
autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrolloff = 0
    vim.opt_local.sidescrolloff = 0
    vim.opt_local.signcolumn = "no"
    vim.bo.filetype = "terminal"
    vim.cmd.startinsert()
  end,
})
-- Consistent terminal mode after buffer switch
autocmd("WinEnter", {
  callback = function()
    if vim.bo.filetype == "terminal" and lib.contains(state.main_term.mode, "[tT]") then
      vim.cmd.startinsert()
    end
  end,
})
autocmd("WinLeave", {
  callback = function()
    if vim.bo.filetype == "terminal" then
      state.main_term.mode = vim.api.nvim_get_mode().mode
      vim.cmd.stopinsert()
    end
  end,
})
